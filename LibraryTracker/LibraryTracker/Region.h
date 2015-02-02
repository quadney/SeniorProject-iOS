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

@property NSString *regionName;
@property NSMutableArray *zones;
@property long *currentPopulation;

@end
