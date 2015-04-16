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
    
    //self.state = [[NotInRegionLS alloc] initWithContext:self];
    // user may or may not be restoring this from a state, so do that
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.state = [self restoreLocationStateWithUserState:[defaults integerForKey:@"user_state"]];
    
    
    return self;
}

- (LocationState *)restoreLocationStateWithUserState:(UserState)state {
    
    NSLog(@"user state: %lu", state);
    if (state == UserStateRoaming) {
        NSLog(@"Instantiating Roaming from restored state");

        return [[Roaming alloc] initToRestoreState:state withContext:self];
    }
    else if (state == UserStateStudying) {
        NSLog(@"Instantiating Studying from restored state");
        
        return [[Studying alloc] initToRestoreState:state withContext:self];
    }
    
    NSLog(@"Instantiating NotInRegion");
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

- (void)regionConfirmedWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"LOCATIONSTATECONTEXT regionConfirmed");
    
    self.state = [[Studying alloc] initWithContext:self region:region BSSID:bssid andSSID:ssid];
}

- (Region *)getRegion {
    return [self.state getRegion];
}

- (NSString *)description {
    return self.state.description;
}

@end
