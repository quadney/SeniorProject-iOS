//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum andZones:(NSArray *)zones {
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.idNum = idNum;
    self.zones = zones;
    self.totalCapacity = [self calculateTotalCapacity];
    return self;
}

- (Zone *)findZoneInRegionWithBssid:(NSString *)bssid {
    for (Zone *zone in self.zones) {
        // go through each zone to see if BSSID matches
        if ([zone bssidIsInZone:bssid]) {
            return zone;
        }
    }
    return nil;
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
        if (![zone.identifier isEqualToString:@"Unknown Floor"]) {
            capacity += zone.maxCapacity;
        }
    }
    return capacity;
}

@end
