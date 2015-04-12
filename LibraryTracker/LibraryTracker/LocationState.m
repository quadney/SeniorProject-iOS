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

- (id)initWithContext:(LocationStateContext *)context {
    self = [super init];
    self.context = context;
    return self;
}

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

@end
