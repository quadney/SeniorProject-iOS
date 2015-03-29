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

- (University *)createUniversityWithName:(NSString *)name location:(CLLocation *)location regions:(NSArray *)regions idNumber:(int)idNum {
    return [[University alloc] initWithName:name location:location regions:regions  idNumber:idNum];
}

- (Region *)createRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius idNumber:(int)idNum{
    return [[Region alloc] initWithIdentifier:name center:location radius:radius idNumber:idNum];
}

@end
