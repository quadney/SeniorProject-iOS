//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@implementation InRegionLS

- (id)initWithRegion:(Region *)region withZone:(Zone *)zone andBSSID:(NSString *)bssid {
    self = [super init];
    if (self) {
        self.userCurrentRegion = region;
        self.userCurrentZone = zone;
        self.currentBSSID = bssid;
    }
    return self;
}

- (Region *)getRegion {
    return self.userCurrentRegion;
}

- (void)updateZone:(Zone *)zone {
    @throw [[NSException alloc] initWithName:@"InRegionsLS - hook method" reason:@"updateZone to be implemented in subclasses" userInfo:nil];
}

- (void)updateBSSID:(NSString *)bssid {
    @throw [[NSException alloc] initWithName:@"InRegionsLS - hook method" reason:@"updateBSSID to be implemented in subclasses" userInfo:nil];
}

@end
