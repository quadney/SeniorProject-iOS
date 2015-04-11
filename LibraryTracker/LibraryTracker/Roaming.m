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

- (instancetype)initWithRegion:(Region *)region withZone:(Zone *)zone andBSSID:(NSString *)bssid {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    // need to conjur up some fancy algorithm to work with this
    // probably having to do with threads and timers and background stuff
    
    self = [super initWithRegion:region withZone:zone andBSSID:bssid];
    
    self.pastZones = [[NSMutableArray alloc] init];
    self.pastBssids = [[NSMutableArray alloc] init];
    
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timerUpdateInfo:)
                                                userInfo:nil repeats:YES];
    
}

- (void)timerUpdateInfo:(id)sender {
    CLLocation *newLocation = [[LocationMonitor sharedLocation] getCurrentLocation];
    NSString *newBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
    
    //[self compare]
}



- (void)regionConfirmed {
    // called when the user has been in the region for an extended period of time
    self.userState = [[Studying alloc] initWithRegion:self.userCurrentRegion
                                             withZone:self.userCurrentZone
                                             andBSSID:self.currentBSSID];
}

- (void)updateZone:(Zone *)zone {
    if ([zone.identifier isEqualToString:self.userCurrentZone.identifier]) {
        // user has not moved, potentially need to change state to studying
    }
    else {
        // user is on a different floor, update things
        [self.pastZones addObject:self.userCurrentZone];
        self.userCurrentZone = zone;
    }
}

- (void)updateBSSID:(NSString *)bssid {
    if ([bssid isEqualToString:self.currentBSSID]) {
        // user has not moved, potentially need to change state to studying
    }
    else {
        [self.pastBssids addObject:self.currentBSSID];
        self.currentBSSID = bssid;
    }
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Roaming - user is in the region: %@", self.userCurrentRegion.identifier];
}

@end
