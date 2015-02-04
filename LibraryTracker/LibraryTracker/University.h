//
//  University.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface University : NSObject

@property NSArray *regions;
@property NSString *name;
@property CLLocation *location;

- (id)initWithName:(NSString *)name location:(CLLocation *)location regions:(NSArray *)regions;

@end
