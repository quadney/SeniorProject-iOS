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

@interface ModelFactory : NSObject

+ (id)modelStore;

- (University *)createUniversityWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude regions:(NSArray *)regions idNumber:(int)idNum;
- (Region *)createRegionWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum currentPopulation:(int)currentPopulation capacity:(int)totalCapacity;

@end
