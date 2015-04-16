//
//  LocationStateHolder.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/12/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationStateContext.h"
#import "NotInRegionLS.h"
#import "Roaming.h"
#import "Studying.h"
#import "ApplicationState.h"
#import "Region.h"

@interface LocationStateContext()

@property (nonatomic, strong) LocationState *state;

@end

@implementation LocationStateContext

- (id)init {
    self = [super init];
    
    self.state = [self restoreLocationState];
    NSLog(@"Location State: %@", self.state);
    
    return self;
}

- (LocationState *)restoreLocationState {
    
    NSData *stateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_state"];
    if (stateData) {
        LocationState *restoredState = [NSKeyedUnarchiver unarchiveObjectWithData:stateData];
        restoredState.context = self;
        return restoredState;
    }
    
    return [[NotInRegionLS alloc] initWithContext:self];
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"LOCATIONSTATECONTEXT enteredRegion");
    
    self.state = [self.state enteredRegion:region withBSSID:bssid andSSID:ssid];;
}

- (void)exitedRegion {
    NSLog(@"LOCATIONSTATECONTEXT exitedRegion");
    
    self.state = [self.state exitedRegion];;
}

- (void)regionConfirmedWithRegion:(Region *)region zone:(Zone *)zone BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"LOCATIONSTATECONTEXT regionConfirmed");
    
    self.state = [[Studying alloc] initWithContext:self region:region zone:zone BSSID:bssid andSSID:ssid];
}

- (Region *)getRegion {
    return [self.state getRegion];
}

- (Zone *)getZone {
    return [self.state getZone];
}

- (NSString *)description {
    return self.state.description;
}

@end
