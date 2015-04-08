//
//  University.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "University.h"

@implementation University

- (id)initWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude idNumber:(int)idNum {
    
    if (self = [super init]) {
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.idNum = idNum;
    }
    return self;
}

@end
