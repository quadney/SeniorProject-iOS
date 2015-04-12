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

@implementation LocationStateContext

- (id)init {
    self = [super init];
    self.userState = [[NotInRegionLS alloc] initWithContext:self];
    
    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    //when user enters region from not in region, set the current region to be Roaming
    
    [self.userState enteredRegion:region withBSSID:bssid andSSID:ssid];

    self.userState = [[Roaming alloc] initWithContext:self region:region BSSID:bssid andSSID:ssid];
}

- (void)exitedRegion {
    
    [self.userState exitedRegion];
    
    self.userState = [[NotInRegionLS alloc] initWithContext:self];
    
}

- (void)regionConfirmedWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    self.userState = [[Studying alloc] initWithContext:self region:region BSSID:bssid andSSID:ssid];
}

- (Region *)getRegion {
    return [self.userState getRegion];
}

- (NSString *)description {
    return self.userState.description;
}

@end
