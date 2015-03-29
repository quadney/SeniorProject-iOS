//
//  Region.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Region : CLCircularRegion

@property int currentPopulation;
@property int totalCapacity;
@property int idNum;

- (id)initWithIdentifier:(NSString *)name center:(CLLocation *)center radius:(CLLocationDistance)radius idNumber:(int)idNum;
- (id)initWithCLCircularRegion:(CLCircularRegion *)circle;

@end
