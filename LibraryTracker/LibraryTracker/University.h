//
//  University.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"

@interface University : NSObject

@property NSArray *regions;
@property NSString *name;
@property CLLocation *location;
@property int idNum;

- (id)initWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude regions:(NSArray *)regions idNumber:(int)idNum;

@end
