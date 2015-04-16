//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

#define kIdentifier     @"identifier"
#define kLatitude       @"latitude"
#define kLongitude      @"longitude"
#define kRadius         @"radius"
#define kIdNum          @"idNum"
#define kZones          @"zones"

@implementation Region

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum andZones:(NSArray *)zones {
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.idNum = idNum;
    self.zones = zones;
    self.totalCapacity = [self calculateTotalCapacity];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithIdentifier:[aDecoder decodeObjectForKey:kIdentifier]
                     centerLatitude:[aDecoder decodeFloatForKey:kLatitude]
                    centerLongitude:[aDecoder decodeFloatForKey:kLongitude]
                             radius:[aDecoder decodeFloatForKey:kRadius]
                           idNumber:(int)[aDecoder decodeIntegerForKey:kIdNum]
                           andZones:[aDecoder decodeObjectForKey:kZones]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:kIdentifier];
    [aCoder encodeFloat:self.center.latitude forKey:kLatitude];
    [aCoder encodeFloat:self.center.longitude forKey:kLongitude];
    [aCoder encodeFloat:self.radius forKey:kRadius];
    [aCoder encodeInteger:self.idNum forKey:kIdNum];
    [aCoder encodeObject:self.zones forKey:kZones];
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

- (Zone *)findZoneWithIdentifier:(NSString *)zoneIdentifier {
    for (Zone *zone in self.zones) {
        if ([zone.identifier isEqualToString:zoneIdentifier]) {
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
