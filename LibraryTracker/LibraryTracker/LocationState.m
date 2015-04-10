//
//  LocationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationState.h"

@implementation LocationState

- (void)enteredRegion:(Region *)region withZone:(Zone *)zone andBssid:(NSString *)bssid {
    @throw [NSException exceptionWithName:@"AbstractClass"
                                   reason:@"This method must be overridden in subclasses"
                                 userInfo:nil];
}

- (Region *)getRegion {
    @throw [NSException exceptionWithName:@"InvalidState" reason:@"User not in Region" userInfo:nil];
}

- (void)exitedRegion {
    @throw [NSException exceptionWithName:@"AbstractClass"
                                   reason:@"This method must be overridden in subclasses"
                                 userInfo:nil];
}

- (NSString *)description {
    return @"LocationState - Abstract class";
}

@end
