//
//  ApplicationState.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

//import LocationState classes
#import "NotInRegionLS.h"
#import "Studying.h"
#import "Roaming.h"

//import University information
#import "University.h"

@interface ApplicationState : NSObject

+ (id)sharedInstance;
@property (nonatomic, strong) LocationState *state; 
@property (nonatomic, strong) University *university;

- (NSMutableArray *)getRegions;
- (Region *)getUserCurrentRegion;
    //review to make sure this is good OOP, this functionality is also only for developer purposes so maybe it's okay
- (void)addRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius idNumber:(int)idNum;
- (void)userEnteredRegion:(CLCircularRegion *)region;
- (void)userExitedRegion:(CLCircularRegion *)region;

@end
