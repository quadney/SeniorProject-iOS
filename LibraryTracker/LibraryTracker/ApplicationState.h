//
//  ApplicationState.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

//import University information
#import "University.h"
#import "Region.h"

@interface ApplicationState : NSObject

+ (id)sharedInstance;

//sets the university
- (void)setUniversity:(University *)university;

- (void)saveUniversityDefaults;

// gets the university
- (University *)getUniversity;

// returns the University id in the database
- (int)getUniversityId;

// returns the university's common wifi name,
// important because the BSSID's depend on it
- (NSString *)getUniversityCommonWifiName;

// update the regions that the unviersity has
- (void)setNewRegionsToTrack:(NSArray *)regions;

// returns the Regions
- (NSArray *)getRegions;

- (void)updateRegions:(NSArray *)updatedRegions;

// returns the Region that the User is currently in, if any
- (Region *)getUserCurrentRegion;

- (Region *)findRegionWithIdentifier:(NSString *)identifier;

// sets the Regions that the phone should be tracking
- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions;

// reacts when the user enters a region
- (void)userEnteredRegion:(CLCircularRegion *)region;

// reacts when the user exits a region
- (void)userExitedRegion:(CLCircularRegion *)region;

// get location state
- (NSString *)getLocationState;

// don't hate me for puttin this here even though it doesn't belong...
- (UIColor *)convertRegionPopulationToColorWithCurrentPop:(int)currentPopulation andMaxCapacity:(int)maxCapacity;

@end
