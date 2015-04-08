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

@interface ApplicationState()

@property (nonatomic, strong) LocationState *state;
@property (nonatomic, strong) University *university;
@property (nonatomic, strong) NSArray *regions;
@property int currentRegionInt;

@end

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

- (University *)getUniversity {
    return self.university;
}


- (int)getUniversityId {
    return [self.university idNum];
}

- (void)setRegions:(NSArray *)regions {
    // when new regions are set, need to also change what is being monitored
    _regions = regions;
    
    // when the regions that the app is tracking is updated, we need to also refresh the RegionTableView and RegionMapView Controller's
    [self setRegionsInLocationMonitorWithRegions:regions];
}

- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions {
    NSLog(@"Setting the Regions to monitor");
    [[LocationMonitor sharedLocation] setRegionsToMonitor:regions];
}

- (void)updateRegions:(NSArray *)updatedRegions {
    NSLog(@"TODO update regions method");
}

- (NSArray *)getRegions {
    return self.regions;
}

- (Region *)getUserCurrentRegion {
    NSLog(@"TODO make sure this is correct, ApplicationState, Get User Current Region");
    return [self.state getRegion];
}

- (void)userEnteredRegion:(CLCircularRegion *)region {
    NSLog(@"TODO make sure this is correct, ApplicatonState, userEnteredLocation");
    
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
