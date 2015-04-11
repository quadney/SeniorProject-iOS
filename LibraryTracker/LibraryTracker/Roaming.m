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

@interface Roaming()

@property (nonatomic) NSTimer *timer;
@property int numTimesRanTimer;

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
    self.numTimesRanTimer = 0;
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    //starts a timer for 3 minutes, in the background
    [self startTimerForSeconds:30.0f];
    
}

- (void)startTimerForSeconds:(float)seconds {
    self.numTimesRanTimer++;
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
        // reset the num times timer has run
        self.numTimesRanTimer = 0;
        [self startTimerForSeconds:300.0f];
    }
    else {
        // get the new location and bssid
        // we don't actually need location, but need it so we can run this in the background shhhhh
        CLLocation *newLocation = [[LocationMonitor sharedLocation] getCurrentLocation];
        NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
        
        if ([self checkIpAddress:newIpAddress]){
            // the IP address is the correct one that is associated with the university
            
            // compare how the new location and BSSID
            if ([self updatedBSSID:newBssid]) {
                // if yes, then the user has moved
                // need to set a timer again
            }
        }
        else {
            // the wifi is not null, and the user is on the wrong wifi.
            // this could be many things - maybe the user is tethering off their own or a friend's wifi?
            // of they are connected to a different wifi
            // do I just add them to the unknown zone?
            [self regionConfirmed];
        }
    }
}

- (BOOL)checkIpAddress:(NSString *)ipAddress {
    if ([ipAddress isEqualToString:self.universityCommonIPAddress]) {
        // user is in the right wifi
        return YES;
    }
    return NO;
}

- (BOOL)updatedBSSID:(NSString *)bssid {
    if ([bssid isEqualToString:self.currentBSSID]) {
        // user has not moved, one more check that the zones are the same
        return [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
    }
    else {
        self.currentBSSID = bssid;  // current BSSID has changed, so need to find the Zone associated with that BSSID
        // check if the zone has changed
        [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
        return YES;
    }
}

- (BOOL)updatedZone:(Zone *)zone {
    if ([zone.identifier isEqualToString:self.currentZone.identifier]) {
        // user has not moved, potentially need to change state to studying
        // if the num times that the timer has started is above 3, then we can set the state to studying
        // also make sure that the background tasks are stopped
        if (self.numTimesRanTimer > 3) {
            [self regionConfirmed];
        }
        return NO;
    }
    else {
        // user is on a different floor, update things
        self.currentZone = zone;
        return YES;
    }
}

- (void)invalidateBackgroundTasks {
    // TODO
    // invalidate the background tasks inorder to save battery power and stuff
}

- (void)regionConfirmed {
    [self invalidateBackgroundTasks];
    // called when the user has been in the region for an extended period of time
    self.userState = [[Studying alloc] initWithRegion:self.currentRegion
                                                BSSID:self.currentBSSID
                                         andIPAddress:self.universityCommonIPAddress];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ROAMING - user is in the region: %@", self.currentRegion.identifier];
}

@end
