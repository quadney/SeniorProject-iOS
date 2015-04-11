//
//  Roaming.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Roaming.h"
#import "NotInRegionLS.h"
#import "Studying.h"
#import "LocationMonitor.h"
#import "ApplicationState.h"

@interface Roaming()

@property (nonatomic) NSTimer *timer;

@end

@implementation Roaming

- (instancetype)initWithRegion:(Region *)region BSSID:(NSString *)bssid andIPAddress:(NSString *)ipAddress {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    // need to conjur up some fancy algorithm to work with this
    // probably having to do with threads and timers and background stuff
    
    self = [super initWithRegion:region BSSID:bssid andIPAddress:ipAddress];
    
    NSLog(@"Starting timer to update background stuff");
    [self startTimer];
    
    return self;
}

- (void)startTimer {
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    //starts a timer for 3 minutes, in the background
    [self startTimerForSeconds:30.0f];
    
}

- (void)startTimerForSeconds:(float)seconds {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerUpdateInfo:)
                                                userInfo:nil repeats:YES];
}

- (void)timerUpdateInfo:(id)sender {
    //when the timer is fired, grabs the user's current location, wifi, etc
    NSString *newIpAddress = [[LocationMonitor sharedLocation] getCurrentIPAddress];

    //compare with what is in the data already,
    
    
    if (!newIpAddress) {
        // if the IP address is null, then the person is not connected to wifi
        // start the timer again, we'll check again in 5 minutes
        // if they aren't on the wifi, then we don't care about the bssid
        [self startTimerForSeconds:300.0f];
    }
    else {
        // get the new location and bssid
        // we don't actually need location, but need it so we can run this in the background shhhhh
        CLLocation *newLocation = [[LocationMonitor sharedLocation] getCurrentLocation];
        NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
        
        if ([self updatedIpAddress:newIpAddress]){
            // the IP address we knew before is different than the new one -
            // the user could have potentially gotten onto the network that we're interested in
            
            // compare how the new location and BSSID
        }
        else {
            // the IP addresses are the same
        }
    }
}

- (void)regionConfirmed {
    // called when the user has been in the region for an extended period of time
    self.userState = [[Studying alloc] initWithRegion:self.currentRegion
                                                BSSID:self.currentBSSID
                                         andIPAddress:self.currentIpAddress];
}

- (BOOL)updatedZone:(Zone *)zone {
    if ([zone.identifier isEqualToString:self.currentZone.identifier]) {
        // user has not moved, potentially need to change state to studying
        return NO;
    }
    else {
        // user is on a different floor, update things
        self.currentZone = zone;
        return YES;
    }
}

- (BOOL)updatedBSSID:(NSString *)bssid {
    if ([bssid isEqualToString:self.currentBSSID]) {
        // user has not moved, potentially need to change state to studying
        return NO;
    }
    else {
        self.currentBSSID = bssid;  // current BSSID has changed, so need to find the Zone associated with that BSSID
        // check if the zone has changed
        [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
        return YES;
    }
    
}

- (BOOL)updatedIpAddress:(NSString *)ipAddress {
    if ([ipAddress isEqualToString:self.currentIpAddress]) {
        // user is not on the wifi, which potentially invalidates everything
        return NO;
    }
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ROAMING - user is in the region: %@", self.currentRegion.identifier];
}

@end
