//
//  ModelFactory.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/5/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ModelFactory.h"

@implementation ModelFactory

+ (id)modelStore {
    static ModelFactory *modelFactoryInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelFactoryInstance = [[self alloc] init];
    });
    return modelFactoryInstance;
}

- (University *)createUniversityWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude idNumber:(int)idNum {
    return [[University alloc] initWithName:name latitude:latitude longitude:longitude idNumber:idNum];
}

- (Region *)createRegionWithIdentifier:(NSString *)identifier latitude:(float)latitude longitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum zones:(NSArray *)zones {
    
    return [[Region alloc] initWithIdentifier:identifier centerLatitude:latitude centerLongitude:longitude radius:radius idNumber:idNum andZones:zones];
}

- (Zone *)createZoneWithIdentifier:(NSString *)identifier idNumber:(int)idNum bssidData:(NSArray *)bssidData currentPopulation:(int)currentPop maxCapacity:(int)capacity altitude:(float)altitude {
    return [[Zone alloc] initWithIdentifier:identifier wifiBssidValues:bssidData idNumber:idNum currentPopulation:currentPop capacity:capacity altitude:altitude];
}

@end
