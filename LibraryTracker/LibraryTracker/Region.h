//
//  Region.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Zone.h"

@interface Region : CLCircularRegion

@property NSMutableArray *zones;
@property long currentPopulation;
@property long totalCapacity;

- (id)initWithIdentifier:(NSString *)name center:(CLLocation *)center radius:(CLLocationDistance)radius zones:(NSArray *)zones;
- (id)initWithCLCircularRegion:(CLCircularRegion *)circle;
- (void)addZone:(Zone *)zone;

@end
