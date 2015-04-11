//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"

@implementation Studying

- (id)initWithRegion:(Region *)region BSSID:(NSString *)bssid andIPAddress:(NSString *)ipAddress {
    
    self = [super initWithRegion:region BSSID:bssid andIPAddress:ipAddress];

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING - userState: %@, region: %@", self.userState, self.currentRegion.identifier];
}

@end
