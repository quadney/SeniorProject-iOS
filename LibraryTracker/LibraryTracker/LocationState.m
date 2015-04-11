//
//  LocationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationState.h"
#import "NotInRegionLS.h"

@implementation LocationState

- (Region *)getRegion {
    @throw [NSException exceptionWithName:@"InvalidState" reason:@"User not in Region" userInfo:nil];
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    @throw [NSException exceptionWithName:@"AbstractClass"
                                   reason:@"This method must be overridden in subclasses"
                                 userInfo:nil];
}

- (void)exitedRegion {
    @throw [NSException exceptionWithName:@"AbstractClass"
                                   reason:@"This method must be overridden in subclasses"
                                 userInfo:nil];
}

- (NSString *)description {
    return self.userState.description;
}

@end
