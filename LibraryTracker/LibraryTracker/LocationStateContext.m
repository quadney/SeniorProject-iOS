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


@interface LocationStateContext()

@property (nonatomic, strong) LocationState *state;

@end

@implementation LocationStateContext

- (id)init {
    self = [super init];
    self.state = [[NotInRegionLS alloc] init];
    
    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"LOCATIONSTATECONTEXT enteredRegion");
    
    //when user enters region from not in region, set the current region to be Roaming
    
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
