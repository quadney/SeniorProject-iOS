//
//  Roaming.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Roaming.h"
#import "Studying.h"
#import "NotInRegionLS.h"
#import "LocationMonitor.h"
#import "ApplicationState.h"

@interface Roaming()

@property (nonatomic) NSTimer *timer;
@property int numTimesRanTimer;

@end

@implementation Roaming


- (instancetype)initWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    // need to conjur up some fancy algorithm to work with this
    // probably having to do with threads and timers and background stuff
    
    self = [super initWithRegion:region BSSID:bssid andSSID:ssid];
    
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    [self startTimer];
    
    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    //when user enters region from not in region, set the current region to be Roaming
    
    self.userState = [[Roaming alloc] initWithRegion:region BSSID:bssid andSSID:ssid];
}

- (void)exitedRegion {
    // invalid state
    self.userState = [[NotInRegionLS alloc] init];
}

- (void)startTimer {
    //starts a timer for 30 seconds, in the background
    [self startTimerForSeconds:30.0f];
    
}

- (void)startTimerForSeconds:(float)seconds {
    self.numTimesRanTimer++;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                  target:self
                                                selector:@selector(timerUpdateInfo:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)timerUpdateInfo:(id)sender {
    //when the timer is fired, grabs the user's current location, wifi, etc
    NSString *newSSID = [[LocationMonitor sharedLocation] getCurrentSSID];

    //compare with what is in the data already,
    
    NSLog(@"Checking SSID, %@", newSSID);
    if (!newSSID) {
        // if the IP address is null, then the person is not connected to wifi
        // start the timer again, we'll check again in 5 minutes
        // if they aren't on the wifi, then we don't care about the bssid
        // reset the num times timer has run
        NSLog(@"SSID is null");
        self.numTimesRanTimer = 0;
        [self startTimerForSeconds:300.0f];
    }
    else {
        // get the new location and bssid
        // we don't actually need location, but need it so we can run this in the background shhhhh
        [[LocationMonitor sharedLocation] getCurrentLocation];
        NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
        
        if ([self checkSSID:newSSID]){
            // the IP address is the correct one that is associated with the university
            
            NSLog(@"User is in the correct wifi, updating the BSSID and stuff");
            // compare how the new location and BSSID
            if ([self updatedBSSID:newBssid]) {
                // if yes, then the user has moved
                // need to set a timer again, for 3 minutes
                [self startTimerForSeconds:180.0];
            }
        }
        else {
            // the wifi is not null, and the user is on the wrong wifi.
            // this could be many things - maybe the user is tethering off their own or a friend's wifi?
            // of they are connected to a different wifi
            // do I just add them to the unknown zone?
            NSLog(@"User is not in the wifi, confirming region");
            [self regionConfirmed];
        }
    }
}

- (BOOL)checkSSID:(NSString *)ssid {
    if ([ssid isEqualToString:self.universityCommonSSID]) {
        // user is in the right wifi
        return YES;
    }
    return NO;
}

- (BOOL)updatedBSSID:(NSString *)bssid {
    NSLog(@"Checking the updated BSSID");
    if ([bssid isEqualToString:self.currentBSSID]) {
        // user has not moved, one more check that the zones are the same
        NSLog(@"User has not moved");
        return [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
    }
    else {
        NSLog(@"BSSID has changed");
        self.currentBSSID = bssid;
        // current BSSID has changed, so need to find the Zone associated with that BSSID
        // check if the zone has changed
        [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
        return YES;
    }
}

- (BOOL)updatedZone:(Zone *)zone {
    if ([zone.identifier isEqualToString:self.currentZone.identifier]) {
        NSLog(@"Zones are the same, Number of times ran timer: %i", self.numTimesRanTimer);
        // user has not moved, potentially need to change state to studying
        // if the num times that the timer has started is above 3, then we can set the state to studying
        // also make sure that the background tasks are stopped
        
        if (self.numTimesRanTimer > 2) {
            [self regionConfirmed];
        }
        return NO;
    }
    else {
        NSLog(@"Zones are not the same");
        // user is on a different floor, update things
        self.currentZone = zone;
        return YES;
    }
}

- (void)regionConfirmed {
    NSLog(@"Confirming region");
    [self invalidateBackgroundTasks];
    // called when the user has been in the region for an extended period of time
    
    [[ApplicationState sharedInstance] regionConfirmed];
//    self.userState = [[Studying alloc] initWithRegion:self.currentRegion
//                                                BSSID:self.currentBSSID
//                                              andSSID:self.universityCommonSSID];
}

- (void)invalidateBackgroundTasks {
    // TODO
    // invalidate the background tasks inorder to save battery power and stuff
    NSLog(@"Attempting to invalidate the background task");
    [self.timer invalidate];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ROAMING // "];
}

@end
