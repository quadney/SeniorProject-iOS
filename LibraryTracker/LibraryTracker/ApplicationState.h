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
#import "Stationary.h"
#import "Roaming.h"

//import University information
#import "University.h"

@interface ApplicationState : NSObject

+ (id)sharedInstance;
@property (nonatomic, strong) LocationState *state; //TODO double check that this is proper
@property (nonatomic, strong) University *university;

- (NSMutableArray *)getRegions;
- (void)addRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius;
- (void)userEnteredRegion:(CLCircularRegion *)region;
- (void)userExitedRegion:(CLCircularRegion *)region;

@end
