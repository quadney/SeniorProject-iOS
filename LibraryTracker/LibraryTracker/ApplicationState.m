//
//  ApplicationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationState.h"
#import "ModelFactory.h"
#import "LocationMonitor.h"

@implementation ApplicationState

+ (id)sharedInstance {
    static ApplicationState *applicationStateInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        applicationStateInstance = [[self alloc] initPrivate];
    });
    return applicationStateInstance;
}

- (id)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use: [ApplicationState sharedState]"
                                 userInfo:nil];
    return nil;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        // set the LocationState to be the default
        self.state = [[NotInRegionLS alloc] init];
    }
    return self;
}

- (void)setUniversityRegions:(NSArray *)regions {
    NSLog(@"Appears that fetched Regions was completed, setting the regions for the University");
    // if we set the University's regions, we need to then set the regions that the app is tracking
    [self.university setRegions:regions];
    
    // when the regions that the app is tracking is updated, we need to also refresh the RegionTableView and RegionMapView Controller's
    [self setRegionsInLocationMonitorWithRegions:regions];
}

- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions {
    NSLog(@"Setting the Regions to monitor");
    [[LocationMonitor sharedLocation] addRegions:regions];
}

- (int)getUniversityId {
    return [self.university idNum];
}

- (NSArray *)getRegions {
    return [self.university regions];
}

- (Region *)getUserCurrentRegion {
//    Region *stateRegion = [self.state getRegion];
//    Region *reg = [self.university regions];
    return [self.state getRegion];
}

- (void)userEnteredRegion:(CLCircularRegion *)region {
    NSLog(@"Applicaton State: UserEnteredLocation");
    
    // The Roaming functionality takes in a Region, this method has access to the CLCircularRegion
            // aka I need to find the region that it is associated with
    
    // get the Region with the same identifier as the one we have access to
    // go through the list and find it
    Region *enteredRegion;
    for (Region *r in [self getRegions]) {
        if ([r.identifier isEqualToString:region.identifier]) {
            enteredRegion = r;
            // need to make sure that this is passing the actual Region and not like a copy or something
        }
    }
    
    if (enteredRegion) {
        // when user enters region, their state becomes "Roaming"
        self.state = [[Roaming alloc] initWithRegion:enteredRegion];
    }
    
}

- (void)userExitedRegion:(CLCircularRegion *)region {
    // when user exits a region, then state goes to NotInRegion
    self.state = [[NotInRegionLS alloc] init];
}

@end
