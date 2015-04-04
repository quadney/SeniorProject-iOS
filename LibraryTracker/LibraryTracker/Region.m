//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum currentPopulation:(int)currentPopulation capacity:(int)totalCapacity {
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.idNum = idNum;
    self.currentPopulation = currentPopulation;
    self.totalCapacity = totalCapacity;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Region Id Num: %i, %@", self.idNum, [super description]];
}

@end
