//
//  LocationMonitor.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationMonitor.h"
#import <UIKit/UIKit.h>
#import "ApplicationState.h"

@interface LocationMonitor()

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationMonitor 

#pragma mark - Singleton init methods

+ (id)sharedLocation {
    static LocationMonitor *shared =nil;
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shared = [[LocationMonitor alloc] init];
    });
    return shared;

}

- (id)init {
    
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestAlwaysAuthorization];

        
        [self.locationManager startUpdatingLocation];
    }
    
    [self getCurrentWiFiName];
    return self;
}

#pragma mark - Permission check methods

// method to check whether there is permissions for location monitoring
// this is important!
- (BOOL)checkLocationManagerPermissions {
    if(![CLLocationManager locationServicesEnabled]) {
        NSLog(@"You need to enable Location Services");
        return  FALSE;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  ) {
        NSLog(@"You need to authorize Location Services for the APP");
        return  FALSE;
    }
    return TRUE;
}

#pragma mark - LocationMonitor - Region Monitoring methods

// call this method when setting a new university
- (void)addRegions:(NSArray *)regions {
    // clear out the current regions that it's monitoring
    [self clearRegionsMonitoring];
    
    // add each of the regions
    [self addRegionsToMonitor:regions];
    
    // check if already in a region
    [self checkIfAlreadyInRegion];
}

- (void)addRegionsToMonitor:(NSArray *)regions {
    for (CLCircularRegion *region in regions) {
        [self.locationManager startMonitoringForRegion:region];
    }
}

- (CLLocation *)getCurrentLocation {
    if ([self checkLocationManagerPermissions]) {
        NSLog(@"User permissions are Kosher");
        [self.locationManager startUpdatingLocation];
    }
    
    //
    
    return self.currentLocation;
}

- (NSString *)getCurrentWiFiName {
//    NSString *ssid = @"NO WIFI!";
//    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//    if ([ifs count] > 0) {
//        for (NSString *ifname in ifs) {
//            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
//            
//            if (info[@"SSID"]) {
//                ssid = info[@"SSID"];
//            }
//        }
//    }
//    
//    return ssid;
    return @"";
}



- (void)clearRegionsMonitoring {
    NSLog(@"Clearing the current regions monitoring");
    for(CLRegion *region in [[self.locationManager monitoredRegions] allObjects]) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}
- (void)checkIfAlreadyInRegion {
    [self getCurrentLocation];
    for (CLCircularRegion *region in [self.locationManager monitoredRegions]) {
        if ([region containsCoordinate:self.currentLocation.coordinate]) {
            NSLog(@"Already in the Region: %@", region.identifier);
            [self locationManager:self.locationManager didEnterRegion:region];
        }
    }
}

#pragma mark - CLLocationManagerDelegate - Region monitoring methods

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Started monitoring %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self createLocalNotificationWithAlertBody:[NSString stringWithFormat:@"Entered Region: %@", region.identifier]];
    
    // when user enters region - need to change user state to Roaming
    [[ApplicationState sharedInstance] userEnteredRegion:(CLCircularRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    [self createLocalNotificationWithAlertBody:[NSString stringWithFormat:@"Exited Region: %@", region.identifier]];
    
    // when user exits region - need to change user state to NotInRegion
    [[ApplicationState sharedInstance] userExitedRegion:(CLCircularRegion *)region];
}

#pragma mark - CLLocationManagerDelegate methods - CurrentLocation stuff

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Getting the user location");
    self.currentLocation = [locations lastObject];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    //use this if the user is already in a region
    NSLog(@"User already in region - %@", region.identifier);
    
    [self locationManager:self.locationManager didEnterRegion:region];
}

#pragma mark - Local Notification Methods

- (void)createLocalNotificationWithAlertBody:(NSString *)alert {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alert;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
