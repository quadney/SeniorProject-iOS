//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@implementation InRegionLS

- (id)initWithRegion:(Region *)region {
    self = [super init];
    if (self) {
        self.userCurrentRegion = region;
    }
    return self;
}

- (Region *)getRegion {
    return self.userCurrentRegion;
}

@end
