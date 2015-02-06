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
        applicationStateInstance = [[self alloc] init];
    });
    return applicationStateInstance;
}

- (id)init {
    if (self = [super init]) {
        // set the LocationState to be the default
        self.state = [[NotInRegionLS alloc] init];
    }
    return self;
}

- (void)setUniversity:(University *)university {
    // don't forget to do this
    _university = university;
    
    // when the university is set, we want to start the region monitoring of the associated Regions
    [[LocationMonitor sharedLocation] addRegions:[[NSArray alloc] initWithArray:[self.university regions]]];
}

- (NSMutableArray *)getRegions {
    return [self.university regions];
}

- (void)addRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius {
    // add the region to the university
    [self.university addRegion:[[ModelFactory sharedInstance] createRegionWithName:name
                                                                          location:location
                                                                            radius:radius
                                                                             zones:nil]];
    
    // update the Location Monitor with the new region
    // this needs to be looked at or redesigned - I have a feeling it's convoluted. or redesign the whole thing
    // don't want this be an evil god object :(
    [[LocationMonitor sharedLocation] addRegions:[[NSArray alloc] initWithArray:[self getRegions]]];
}

- (void)userEnteredRegion:(CLCircularRegion *)region {
    //[self.state userEnteredRegion:region];
}

- (void)userExitedRegion:(CLCircularRegion *)region {
    
}

@end
