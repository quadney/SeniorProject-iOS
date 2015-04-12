//
//  LocationMonitor.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationMonitor.h"
#import "ApplicationState.h"
#import <CoreLocation/CoreLocation.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface LocationMonitor() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationMonitor 

#pragma mark - Singleton init methods

+ (id)sharedLocation {
    static LocationMonitor *shared =nil;
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shared = [[LocationMonitor alloc] initPrivate];
    });
    return shared;

}

- (id)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use: [LocationMonitor sharedLocation]"
                                 userInfo:nil];
    return nil;
}

- (id)initPrivate {
    
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        [self checkLocationManagerPermissions];
        
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

#pragma mark - Permission check methods

// method to check whether there is permissions for location monitoring
// this is important!
- (BOOL)checkLocationManagerPermissions {
    
    if (![CLLocationManager authorizationStatus]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if(![CLLocationManager locationServicesEnabled]) {
        NSLog(@"You need to enable Location Services");
        return  FALSE;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
        return  FALSE;
    }
    
    return TRUE;
}

#pragma mark - LocationMonitor - Region Monitoring methods

// call this method when setting a new university
- (void)setRegionsToMonitor:(NSArray *)regions {
    NSLog(@"LocationMonitor setRegionsToMonitor");
    
    // clear out the current regions that it's monitoring
    [self clearRegionsMonitoring];
        
    // add each of the regions
    [self addRegionsToMonitor:regions];
    
    // check if already in a region
    [self checkIfAlreadyInRegion];
}

- (void)addRegionsToMonitor:(NSArray *)regions {
    NSLog(@"LocationMonitor addRegionsToMonitor");
    
    for (CLCircularRegion *region in regions) {
        [self.locationManager startMonitoringForRegion:region];
    }
}

- (CLLocation *)getCurrentLocation {
    NSLog(@"LocationMonitor getCurrentLocation");
    
    if ([self checkLocationManagerPermissions]) {
        [self.locationManager startUpdatingLocation];
    }
    return self.currentLocation;
}

- (void)clearRegionsMonitoring {
    NSLog(@"LocationMonitor clearRegionsMonitoring");
    
    for(CLRegion *region in [[self.locationManager monitoredRegions] allObjects]) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

- (void)checkIfAlreadyInRegion {
    NSLog(@"LocationMonitor checkIfAlreadyInRegion");
    
    [self getCurrentLocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"user_studying"]) {
        // only check if already in a region IF we don't already know that the user is not studying
        
        for (CLCircularRegion *region in [self.locationManager monitoredRegions]) {
            if ([region containsCoordinate:self.currentLocation.coordinate]) {
                NSLog(@"Already in the Region: %@", region.identifier);
                [self locationManager:self.locationManager didEnterRegion:region];
            }
        }
    }
}

- (NSSet *)getMonitoredRegions {
    return [self.locationManager monitoredRegions];
}

#pragma mark - CLLocationManagerDelegate - Region monitoring methods

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    //NSLog(@"Started monitoring %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSLog(@"THERE WAS AN ERROR IN MONITORING FOR A REGION %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"Entered Region %@", region.identifier);
    
    // when user enters region - need to change user state to Roaming
    [[ApplicationState sharedInstance] userEnteredRegion:(CLCircularRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    NSLog(@"Exited Region %@", region.identifier);
    
    // when user exits region - need to change user state to NotInRegion
    [[ApplicationState sharedInstance] userExitedRegion:(CLCircularRegion *)region];
}

#pragma mark - CLLocationManagerDelegate methods - CurrentLocation stuff

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = [locations lastObject];
    
    if (self.currentLocation) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {    
    //use this if the user is already in a region
    NSLog(@"User already in region - %@", region.identifier);
    
    [self locationManager:self.locationManager didEnterRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LocationMonitor didFailWithError: %@", error);
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error"
                               message:@"Failed to Get Your Location"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

#pragma mark - WIFI Identification stuff

// getting the SSID number
// http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
/** Returns first non-empty SSID network info dictionary.
 *  @see CNCopyCurrentNetworkInfo */
- (NSString *)getCurrentBSSID
{
    return [[self getSSIDInfo] objectForKey:@"BSSID"];
}

- (NSString *)getCurrentSSID {
    return [[self getSSIDInfo] objectForKey:@"SSID"];
}

- (NSDictionary *)getSSIDInfo {
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    
    return SSIDInfo;
}

@end
