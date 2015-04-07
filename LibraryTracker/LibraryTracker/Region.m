//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"
#import "Zone.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum andZones:(NSArray *)zones {
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.idNum = idNum;
    self.zones = zones;
    self.totalCapacity = [self calculateCurrentPopulation];
    return self;
}

- (int)calculateCurrentPopulation {
    int population = 0;
    for (Zone *zone in self.zones) {
        population += zone.currentPopulation;
    }
    
    return population;
}

- (int)calculateTotalCapacity {
    int capacity = 0;
    for (Zone *zone in self.zones) {
        capacity += zone.maxCapacity;
    }
    
    return capacity;
}

@end
