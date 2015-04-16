//
//  Region.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLCircularRegion.h>
#import "Zone.h"

@interface Region : CLCircularRegion <NSCoding>

@property int idNum;
@property (nonatomic, strong) NSArray *zones;
@property int totalCapacity;

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum andZones:(NSArray *)zones;

- (int)calculateCurrentPopulation;
- (Zone *)findZoneInRegionWithBssid:(NSString *)bssid;
- (Zone *)findZoneWithIdentifier:(NSString *)zoneIdentifier;

@end
