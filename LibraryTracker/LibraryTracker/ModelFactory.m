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

- (University *)createUniversityWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude regions:(NSArray *)regions idNumber:(int)idNum {
    return [[University alloc] initWithName:name latitude:latitude longitude:longitude regions:regions idNumber:idNum];
}

- (Region *)createRegionWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum {
    return [[Region alloc] initWithIdentifier:name centerLatitude:latitude centerLongitude:longitude radius:radius idNumber:idNum];
}

@end
