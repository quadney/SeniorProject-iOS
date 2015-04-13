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
@property int numTimesNotInWifi;

@end

@implementation Roaming


- (id)initWithContext:(LocationStateContext *)context region:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    // need to conjur up some fancy algorithm to work with this
    // probably having to do with threads and timers and background stuff
    
    self = [super initWithContext:context region:region BSSID:bssid andSSID:ssid];
    
    [self startTimer];
    
    return self;
}

- (Roaming *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"ROAMING enteredRegion");
    
    [self invalidateBackgroundTasks];
    
    return [[Roaming alloc] initWithContext:self.context region:region BSSID:bssid andSSID:ssid];
}

- (NotInRegionLS *)exitedRegion {
    NSLog(@"ROAMING exitedRegion");
    
    [self invalidateBackgroundTasks];
    
    return [[NotInRegionLS alloc] initWithContext:self.context];
}

- (void)startTimer {
    //starts a timer for 30 seconds, in the background
    self.numTimesRanTimer = 0;
    self.numTimesNotInWifi = 0;
    
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    [self createLocalNotificationWithAlertBody:@"starting background tasks"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:180.0
                                                  target:self
                                                selector:@selector(timerUpdateInfo:)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (void)timerUpdateInfo:(id)sender {
    [self createLocalNotificationWithAlertBody:@"checking where user is"];
    self.numTimesRanTimer++;
    
    //when the timer is fired, grabs the user's current location, wifi, etc
    NSString *newSSID = [[LocationMonitor sharedLocation] getCurrentSSID];

    //compare with what is in the data already,
    
    NSLog(@"Checking SSID, %@", newSSID);
    if (!newSSID) {
        // if the SSID is null, then the person is not connected to wifi
        // if they aren't on the wifi, then we don't care about the bssid
        // reset the num times timer has run
        NSLog(@"SSID is null, reset num times the timer has run");
        [self createLocalNotificationWithAlertBody:@"SSID is null, resetting run times"];
        self.numTimesRanTimer = 0;
        self.numTimesNotInWifi++;
    }
    else {
        // get the new location and bssid
        // we don't actually need location, but need it so we can run this in the background shhhhh
        NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
        
        if ([self checkSSID:newSSID]){
            // the IP address is the correct one that is associated with the university
            // compare how the new location and BSSID
            [self updatedBSSID:newBssid];
        }
        else {
            // the wifi is not null, and the user is on the wrong wifi.
            // this could be many things - maybe the user is tethering off their own or a friend's wifi?
            // of they are connected to a different wifi
            // do I just add them to the unknown zone?
            NSLog(@"User is not in the wifi, confirming region");
            [self createLocalNotificationWithAlertBody:@"user is not on wifi, confirming region"];
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
        [self createLocalNotificationWithAlertBody:@"User has not moved"];
        
        return [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:self.currentBSSID]];
    }
    else {
        NSLog(@"BSSID has changed");
        [self createLocalNotificationWithAlertBody:@"BSSID has changed"];
        
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
            [self createLocalNotificationWithAlertBody:@"user confirmed in zone"];
            [self regionConfirmed];
        }
        else if (self.numTimesNotInWifi > 2) {
            // the user probably won't turn on their wifi, so remove the user from the region
            [self.context exitedRegion];
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
    NSLog(@"Context: %@", self.context);
    [self.context regionConfirmedWithRegion:self.currentRegion
                                      BSSID:self.currentBSSID
                                    andSSID:self.universityCommonSSID];
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

#pragma mark - Local Notification Methods

- (void)createLocalNotificationWithAlertBody:(NSString *)alert {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alert;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
