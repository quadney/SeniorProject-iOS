//
//  Zone.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Zone.h"

@implementation Zone

- (id)initWithName:(NSString *)name wifiRouter:(NSString *)wifiRouterIdentity {
    if (self = [super init]) {
        self.name = name;
        self.wifiRouterIdentifier = wifiRouterIdentity;
        self.currentPopulation = 0;
        self.totalCapacity = 0;
    }
    return self;
}

@end
