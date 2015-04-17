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


- (id)initWithContext:(LocationStateContext *)context region:(Region *)region zone:(Zone *)zone BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    
    self = [super initWithContext:context region:region zone:(Zone *)zone BSSID:bssid andSSID:ssid];
    
    [self startTimer];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
}

- (Roaming *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"ROAMING enteredRegion");
    
    if (![self.currentRegion.identifier isEqualToString:region.identifier]) {
        [self invalidateBackgroundTasks];
        return [[Roaming alloc] initWithContext:self.context region:region zone:[region findZoneInRegionWithBssid:bssid] BSSID:bssid andSSID:ssid];
    }
    
    return self;
}

- (NotInRegionLS *)exitedRegion {
    NSLog(@"ROAMING exitedRegion");
    
    [self invalidateBackgroundTasks];
    
    return [[NotInRegionLS alloc] initWithContext:self.context];
}

- (void)startTimer {
    //starts a timer for 2 minutes, in the background
    self.numTimesRanTimer = -1;
    self.numTimesNotInWifi = 0;
    
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    [self createLocalNotificationWithAlertBody:@"starting background tasks"];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:120.0
                                                  target:self
                                                selector:@selector(timerUpdateInfo:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self timerUpdateInfo:nil];
    
}

- (void)timerUpdateInfo:(id)sender {
    self.numTimesRanTimer++;
    
    //when the timer is fired, grabs the user's current location, wifi, etc
    NSString *newSSID = [[LocationMonitor sharedLocation] getCurrentSSID];

    //compare with what is in the data already,
    
    NSLog(@"Checking SSID, %@", newSSID);
    if (!newSSID) {
        // if the SSID is null, then the person is not connected to wifi
        // if they aren't on the wifi, then we don't care about the bssid
        // reset the num times timer has run
        [self createLocalNotificationWithAlertBody:@"SSID is null, resetting num times not on wifi"];
        NSLog(@"SSID is null, increasing num Times not on wifi");
        self.numTimesNotInWifi++;
    }
    else {
        // get the new location and bssid
        // we don't actually need location, but need it so we can run this in the background shhhhh
        NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
        
        if ([self checkSSID:newSSID]){
            // the IP address is the correct one that is associated with the university
            // compare how the new location and BSSID
            if (![self isRegionTheSame]) {
                [self createLocalNotificationWithAlertBody:@"User not in Region anymore"];
                [self.context exitedRegion];
            }
            else {
                [self updateBSSID:newBssid];
                
                // if the user has moved, the zone may or may not be the same
                // if the zone is null, then, there is a possibilty that the person has moved, and connected to a wifi in a different location
                // or that the system is making a mistake, because it does that more often that I'd like it to
                // if the zone is null, then the user may not actually be in this region
                // the user is in the correct Region with a registered Zone
                // if updateZone returns true, then the user has moved floors and we need to perform the algorithm again
                [self updatedZone:[self.currentRegion findZoneInRegionWithBssid:newBssid]];
            }
        }
        else {
            // the wifi is not null, and the user is on the wrong wifi.
            // this could be many things - maybe the user is tethering off their own or a friend's wifi?
            // of they are connected to a different wifi
            // set them to unknown floor
            NSLog(@"User is not in the wifi, confirming region");
            [self createLocalNotificationWithAlertBody:@"user is not on wifi, confirming region"];
            [self setCurrentZoneToUnknownFloor];
            [self regionConfirmed];
        }
    }
}

- (BOOL)isRegionTheSame {
    return [self.currentRegion.identifier isEqualToString:[[LocationMonitor sharedLocation] getCurrentRegionIdentifier]];
}

- (BOOL)checkSSID:(NSString *)ssid {
    if ([ssid isEqualToString:self.universityCommonSSID]) {
        // user is in the right wifi
        return YES;
    }
    return NO;
}

- (void)updateBSSID:(NSString *)bssid {
    NSLog(@"Checking the updated BSSID");
    if (![bssid isEqualToString:self.currentBSSID]) {
        NSLog(@"BSSID has changed, user on the move");
        [self createLocalNotificationWithAlertBody:@"BSSID has changed, user on the move"];
        self.currentBSSID = bssid;
    }
    else {
        [self createLocalNotificationWithAlertBody:@"User has not moved"];
        // user has not moved, one more check that the zones are the same
        NSLog(@"User has not moved");
    }
}

- (BOOL)updatedZone:(Zone *)zone {
    
    if (self.numTimesRanTimer > 2) {
        if (self.numTimesNotInWifi > 2) {
            NSLog(@"The zone cannot be confirmed, wifi issues or physical location not in library");
            [self createLocalNotificationWithAlertBody:@"Zone cannot be confirmed, exiting region"];
            // the user is not connected to the wifi, or is connected to the wifi but not actually in the library
            [self.context exitedRegion];
            return YES;
        }
        else if (![zone.identifier isEqualToString:self.currentZone.identifier]) {
            NSLog(@"Zones are the same, Number of times ran timer: %i", self.numTimesRanTimer);
            [self createLocalNotificationWithAlertBody:@"user confirmed in zone"];
            // user has not moved, potentially need to change state to studying
            // if the num times that the timer has started is above 3, then we can set the state to studying
            // also make sure that the background tasks are stopped
            [self regionConfirmed];
            return YES;
        }
        
        // everything checks out and the user is studying!
        [self regionConfirmed];
        return NO;
    }
    
    if (!zone) {
        // zone is null
        self.numTimesNotInWifi++;   //increment this because the user is not on the right wifi
        return YES;
    }
    else if (![zone.identifier isEqualToString:self.currentZone.identifier]) {
        // check if the zones are different, if they are, then change the zone
        NSLog(@"Updating the Zone");
        self.currentZone = zone;
        return YES;
    }
    
    return NO;
}

- (void)setCurrentZoneToUnknownFloor {
    self.currentZone = [self.currentRegion findZoneWithIdentifier:@"Unknown Floor"];
}

- (void)regionConfirmed {
    NSLog(@"Confirming region");
    [self invalidateBackgroundTasks];
    
    // called when the user has been in the region for an extended period of time
    [self.context regionConfirmedWithRegion:self.currentRegion
                                       zone:self.currentZone
                                      BSSID:self.currentBSSID
                                    andSSID:self.universityCommonSSID];
}

- (void)invalidateBackgroundTasks {
    // invalidate the background tasks inorder to save battery power and stuff
    // dont need to save the user state becuase the change of state does that for us
    NSLog(@"Attempting to invalidate the background task");
    [self.timer invalidate];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ROAMING // numTimesRanTimer: %i", self.numTimesRanTimer];
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
