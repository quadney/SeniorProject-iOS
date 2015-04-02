//
//  Region.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Region.h"

@implementation Region

- (id)initWithIdentifier:(NSString *)name centerLatitude:(float)latitude centerLongitude:(float)longitude radius:(CLLocationDistance)radius idNumber:(int)idNum {
    
    CLLocation *center = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self = [super initWithCenter:center.coordinate radius:radius identifier:name];
    self.idNum = idNum;
    return self;
}

//- (id)initWithCLCircularRegion:(CLCircularRegion *)circle {
//    self = [self initWithIdentifier:circle.identifier
//                             center:[[CLLocation alloc] initWithLatitude:circle.center.latitude
//                                                               longitude:circle.center.longitude]
//                             radius:circle.radius
//                           idNumber:nil];
//    return self;
//}

@end
