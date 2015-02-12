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

- (University *)createUniversityWithName:(NSString *)name location:(CLLocation *)location regions:(NSArray *)regions;
- (Region *)createRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius zones:(NSArray *)zones;
- (Zone *)createZoneWithName:(NSString *)name wifiRouterIdentifier:(NSString *)wifiRouterIdentifier;

@end
