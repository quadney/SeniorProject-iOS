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

- (void)enteredRegion:(Region *)region {
    //when user enters region from not in region, set the current region to be Roaming
    NSLog(@"NotInRegion - entering Region now");
    self.userState = [[Roaming alloc] initWithRegion:region];
    NSLog(@"%@", self.userState);
    
}

- (void)regionConfirmed; {
    @throw [NSException exceptionWithName:@"IllegalState"
                                   reason:@"User cannot be confirmed in a region is they are not in a region"
                                 userInfo:nil];
}

- (void)exitedRegion {
    // invalid state
    @throw [NSException exceptionWithName:@"IllegalState"
                                   reason:@"User cannot exit a region if they are not in a region"
                                 userInfo:nil];
}

- (NSString *)description {
    return @"User is not in a Region";
}

@end
