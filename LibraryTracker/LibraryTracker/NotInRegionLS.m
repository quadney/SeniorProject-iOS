//
//  NotInRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "NotInRegionLS.h"

@implementation NotInRegionLS

- (id)init {
    self = [super init];
    //self.userState = self;
    
    return self;
}

- (Region *)getRegion {
    return nil;
}

- (NSString *)description {
    return @"User is not in a Region";
}

@end
