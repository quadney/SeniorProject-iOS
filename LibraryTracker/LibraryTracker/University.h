//
//  University.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Region.h"

@interface University : NSObject

@property NSMutableArray *regions;
@property NSString *name;
@property CLLocation *location;
@property int idNum;

- (id)initWithName:(NSString *)name location:(CLLocation *)location regions:(NSArray *)regions idNumber:(int)idNum;
- (void)addRegion:(Region *)region;

@end
