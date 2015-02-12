//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "NotInRegionLS.h"

@implementation Studying

- (id)initWithRegion:(Region *)region {
    // when Studying is instantiated, then there's nothing we need to do until the user exits the region
    
    self = [super initWithRegion:region];
    return self;
}

- (void)enteredRegion:(Region *)region {
    @throw [NSException exceptionWithName:@"IllegalState"
                                   reason:@"User in study mode, can't move regions"
                                 userInfo:nil];
}

- (void)regionConfirmed {
    @throw [NSException exceptionWithName:@"UnimplementedState"
                                   reason:@"User in study mode, region already confirmed"
                                 userInfo:nil];
    // this will probably have to change
    // because what about moving up and down?
    // TODO will do when get to that stage of implementation
}

- (void)exitedRegion {
    self.userState = [[NotInRegionLS alloc] init];
    NSLog(@"Studying - exited region: %@", self.userState);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Studying - userState: %@, region: %@", self.userState, self.userCurrentRegion.identifier];
}

@end
