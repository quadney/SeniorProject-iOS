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

// update the regions that the unviersity has
- (void)setUniversityRegions:(NSArray *)regions;

// returns the University id in the database
- (int)getUniversityId;

// returns the Regions that are associated with the Unviersity
- (NSMutableArray *)getRegions;

// returns the Region that the User is currently in, if any
- (Region *)getUserCurrentRegion;

// sets the Regions that the phone should be tracking
- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions;

// reacts when the user enters a region
- (void)userEnteredRegion:(CLCircularRegion *)region;

// reacts when the user exits a region
- (void)userExitedRegion:(CLCircularRegion *)region;

@end
