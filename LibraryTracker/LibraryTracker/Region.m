//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name center:(CLLocation *)center radius:(CLLocationDistance)radius zones:(NSMutableArray *)zones {
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.zones = zones;
    return self;
}

@end
