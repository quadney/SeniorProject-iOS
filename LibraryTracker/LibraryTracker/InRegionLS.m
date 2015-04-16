//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

#define kCurrentRegion  @"region"
#define kCurrentZone    @"zone"
#define kCurrentBSSID   @"bssid"
#define kCommonSSID     @"ssid"


@implementation InRegionLS

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region zone:(Zone *)zone BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    self = [super initWithContext:context];
    
    if (self) {
        self.currentRegion = region;
        self.currentZone = zone;
        self.currentBSSID = bssid;
        self.universityCommonSSID = ssid;
        
        [self saveUserState];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    self.currentRegion = [aDecoder decodeObjectForKey:kCurrentRegion];
    self.currentZone = [aDecoder decodeObjectForKey:kCurrentZone];
    self.currentBSSID = [aDecoder decodeObjectForKey:kCurrentBSSID];
    self.universityCommonSSID = [aDecoder decodeObjectForKey:kCommonSSID];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.currentRegion forKey:kCurrentRegion];
    [aCoder encodeObject:self.currentZone forKey:kCurrentZone];
    [aCoder encodeObject:self.currentBSSID forKey:kCurrentBSSID];
    [aCoder encodeObject:self.universityCommonSSID forKey:kCommonSSID];
}

- (Region *)getRegion {
    return self.currentRegion;
}

- (Zone *)getZone {
    return self.currentZone;
}

@end
