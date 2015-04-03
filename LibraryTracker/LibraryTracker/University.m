//
//  University.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "University.h"

@implementation University

- (id)initWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude regions:(NSArray *)regions idNumber:(int)idNum {
    // I think I should make this class a singleton...?
    
    if (self = [super init]) {
        self.name = name;
        self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        self.regions = regions;
        self.idNum = idNum;
    }
    return self;
}

@end
