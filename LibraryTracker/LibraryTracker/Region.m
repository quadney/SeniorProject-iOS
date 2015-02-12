//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name center:(CLLocation *)center radius:(CLLocationDistance)radius zones:(NSArray *)zones {
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.zones = [[NSMutableArray alloc] initWithArray:zones];
    return self;
}

- (id)initWithCLCircularRegion:(CLCircularRegion *)circle {
    self = [self initWithIdentifier:circle.identifier
                             center:[[CLLocation alloc] initWithLatitude:circle.center.latitude
                                                               longitude:circle.center.longitude]
                             radius:circle.radius
                              zones:nil];
    return self;
}

- (void)addZone:(Zone *)zone {
    [self.zones addObject:zone];
}

@end
