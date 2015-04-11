//
//  NotInRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "NotInRegionLS.h"
#import "Roaming.h"

@implementation NotInRegionLS

- (id)init {
    self = [super init];
    
    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    //when user enters region from not in region, set the current region to be Roaming
    
    self.userState = [[Roaming alloc] initWithRegion:region BSSID:bssid andSSID:ssid];
}

- (void)exitedRegion {
    // invalid state
    @throw [NSException exceptionWithName:@"IllegalState"
                                   reason:@"User cannot exit a region if they are not in a region"
                                 userInfo:nil];
}

- (Region *)getRegion {
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NOT IN REGION // "];
}

@end
