//
//  LocationMonitor.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationMonitor.h"

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
    }
    return self;
}

// method to check whether there is permissions for location monitoring
// this is important!
- (BOOL)checkLocationManagerPermissions {
    //TODO display this information to the user in an alert view
    if(![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"You need to enable Location Services");
        return  FALSE;
    }
    if(![CLLocationManager isMonitoringAvailableForClass:self.class])
    {
        NSLog(@"Region monitoring is not available for this Class");
        return  FALSE;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        NSLog(@"You need to authorize Location Services for the APP");
        return  FALSE;
    }
    return TRUE;
}

#pragma mark - Region Monitoring methods

// call this method when setting a new university or whatever
- (void)addRegions:(NSArray *)regions {
    // clear out the current regions that it's monitoring
    [self clearRegionsMonitoring];
    
    // add each of the regions
    for (CLRegion *region in regions) {
        // start tracking the region
        [self.locationManager startMonitoringForRegion:region];
    }
}

- (void)clearRegionsMonitoring {
    NSArray *currentRegions = [[self.locationManager monitoredRegions] allObjects];
    for(CLRegion *region in currentRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    
    if(state == CLRegionStateInside)
    {
        NSLog(@"##Entered Region - %@", region.identifier);
    }
    else if(state == CLRegionStateOutside)
    {
        NSLog(@"##Exited Region - %@", region.identifier);
    }
    else{
        NSLog(@"##Unknown state  Region - %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Started monitoring %@ region", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSLog(@"Entered Region - %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    NSLog(@"Exited Region - %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    // TODO
    
}

@end
