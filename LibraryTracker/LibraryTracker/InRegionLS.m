//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@implementation InRegionLS

- (id)initWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    self = [super init];
    if (self) {
        self.currentRegion = region;
        self.currentZone = [region findZoneInRegionWithBssid:bssid];
        self.currentBSSID = bssid;
        self.universityCommonSSID = ssid;
    }
    return self;
}

- (Region *)getRegion {
    return self.currentRegion;
}

@end
