//
//  ModelFactory.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/5/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "University.h"
#import "Region.h"
#import "Zone.h"

@interface ModelFactory : NSObject

+ (id)modelStore;

- (University *)createUniversityWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude idNumber:(int)idNum commonWifiName:(NSString *)globalWifiName;

- (Region *)createRegionWithIdentifier:(NSString *)identifier latitude:(float)latitude longitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum zones:(NSArray *)zones;

- (Zone *)createZoneWithIdentifier:(NSString *)identifier idNumber:(int)idNum bssidData:(NSArray *)bssidData currentPopulation:(int)currentPop maxCapacity:(int)capacity;

@end
