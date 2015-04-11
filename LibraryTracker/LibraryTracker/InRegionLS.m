//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@implementation InRegionLS

- (id)initWithRegion:(Region *)region withZone:(Zone *)zone BSSID:(NSString *)bssid andIPAddress:(NSString *)ipAddress {
    self = [super init];
    if (self) {
        self.userCurrentRegion = region;
        self.userCurrentZone = zone;
        self.currentBSSID = bssid;
        self.currentIpAddress = ipAddress;
    }
    return self;
}

- (Region *)getRegion {
    return self.userCurrentRegion;
}

- (BOOL)updatedZone:(Zone *)zone {
    @throw [[NSException alloc] initWithName:@"InRegionsLS - hook method" reason:@"updatedZone to be implemented in subclasses" userInfo:nil];
}

- (BOOL)updatedBSSID:(NSString *)bssid {
    @throw [[NSException alloc] initWithName:@"InRegionsLS - hook method" reason:@"updatedBSSID to be implemented in subclasses" userInfo:nil];
}

- (BOOL)updatedIpAddress:(NSString *)ipAddress {
    @throw [[NSException alloc] initWithName:@"InRegionsLS - hook method" reason:@"updatedIpAddress to be implemented in subclasses" userInfo:nil];
}

@end
