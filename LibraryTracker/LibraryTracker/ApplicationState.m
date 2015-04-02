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

- (void)setUniversity:(University *)university {
    // don't forget to do this
    _university = university;
    
    // when the university is set, we want to start the region monitoring of the associated Regions
    [self setRegionsInLocationMonitorWithRegions:[self getRegions]];
}

- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions {
    [[LocationMonitor sharedLocation] addRegions:regions];
}

- (NSMutableArray *)getRegions {
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
