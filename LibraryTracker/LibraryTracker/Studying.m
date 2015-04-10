//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "Roaming.h"
#import "NotInRegionLS.h"

@implementation Studying

- (id)initWithRegion:(Region *)region withZone:(Zone *)zone andBSSID:(NSString *)bssid {
    
    self = [super initWithRegion:region withZone:zone andBSSID:bssid];

    return self;
}

- (void)enteredRegion:(Region *)region withZone:(Zone *)zone andBssid:(NSString *)bssid {
    // reigons may be next to each other, so entering another region is valid
    self.userState = [[Roaming alloc] initWithRegion:region withZone:zone andBSSID:bssid];
}

- (void)exitedRegion {
    self.userState = [[NotInRegionLS alloc] init];
    NSLog(@"Studying - exited region: %@", self.userState);
}

- (void)updateZone:(Zone *)zone {
    self.userCurrentZone = zone;
}

- (void)updateBSSID:(NSString *)bssid {
    self.currentBSSID = bssid;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Studying - userState: %@, region: %@", self.userState, self.userCurrentRegion.identifier];
}

@end
