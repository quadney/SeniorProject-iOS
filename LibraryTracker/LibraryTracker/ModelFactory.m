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

- (University *)createUniversityWithName:(NSString *)name location:(CLLocation *)location regions:(NSArray *)regions {
    return [[University alloc] initWithName:name location:location regions:regions];
}

- (Region *)createRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius zones:(NSArray *)zones {
    return [[Region alloc] initWithIdentifier:name center:location radius:radius zones:zones];
}

- (Zone *)createZoneWithName:(NSString *)name wifiRouterIdentifier:(NSString *)wifiRouterIdentifier {
    return [[Zone alloc] initWithName:name wifiRouter:wifiRouterIdentifier];
}

@end
