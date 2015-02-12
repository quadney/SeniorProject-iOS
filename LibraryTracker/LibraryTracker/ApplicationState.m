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
    [[LocationMonitor sharedLocation] addRegions:[[NSArray alloc] initWithArray:[self.university regions]]];
}

- (NSMutableArray *)getRegions {
    return [[self.university regions] copy];
}

- (Region *)getUserCurrentRegion {
    return [self.state getRegion];
}

- (void)addRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius {
    // add the region to the university
    [self.university addRegion:[[ModelFactory modelStore] createRegionWithName:name
                                                                          location:location
                                                                            radius:radius
                                                                             zones:nil]];
    
    // update the Location Monitor with the new region
    // this needs to be looked at or redesigned - I have a feeling it's convoluted. or redesign the whole thing
    // don't want this be an evil god object :(
    [[LocationMonitor sharedLocation] addRegions:[[NSArray alloc] initWithArray:[self getRegions]]];
}

- (void)addZoneWithName:(NSString *)name wifiIdentifier:(NSString *)wifiInfo {
    if ([self.state getRegion] != nil) {
        [[self.state getRegion] addZone:[[ModelFactory modelStore] createZoneWithName:name
                                                                 wifiRouterIdentifier:wifiInfo]];
    }
    else {
        NSLog(@"User not in Region, can't add zone");
    }
}

- (void)userEnteredRegion:(CLCircularRegion *)region {
    NSLog(@"Applicaton State: UserEnteredLocation");
    //convert CLCircularRegion to Region? make sure that it is in fact a Region
    if (![region isKindOfClass:Region.class]) {
        NSLog(@"regions is not Region.class, %@", region.identifier);
    }
    self.state = [[Roaming alloc] initWithRegion:[[Region alloc] initWithCLCircularRegion:region]];
    // when user enters region, their state becomes "Roaming"
    // if after a while the user stays in a particular location, then they become Stationary
}

- (void)userExitedRegion:(CLCircularRegion *)region {
    // when user exits a region, then state goes to NotInRegion
    self.state = [[NotInRegionLS alloc] init];
}

@end
