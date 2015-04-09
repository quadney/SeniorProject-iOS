//
//  Roaming.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Roaming.h"
#import "NotInRegionLS.h"
#import "Studying.h"

@implementation Roaming

- (id)initWithRegion:(Region *)region {
    // when Roaming is instantiated, the system needs to evaluate where the user is frequently
    // need to conjur up some fancy algorithm to work with this
    // probably having to do with threads and shit
    
    self = [super initWithRegion:region];
    self.pastBSSIDs = [[NSMutableArray alloc] init];
    self.pastZones = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)enteredRegion:(Region *)region {
    // there is the possibility that there are regions next to each other?
    // so this is a vlid state
    // just change the userCurrentRegion
    self.userCurrentRegion = region;
}

- (void)regionConfirmed {
    // called when the user has been in the region for an extended period of time
    self.userState = [[Studying alloc] initWithRegion:self.userCurrentRegion];
}

- (void)exitedRegion {
    self.userState = [[NotInRegionLS alloc] init];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Roaming - user is in the region: %@", self.userCurrentRegion.identifier];
}

@end
