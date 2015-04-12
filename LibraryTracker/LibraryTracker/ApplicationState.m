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


@property (nonatomic, strong) University *university;
@property (nonatomic, strong) NSArray *regions;

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
        self.locationState = [[NotInRegionLS alloc] init];
        
        //check if there is a university in the NSUserDefaults
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"university_existence"]) {
            [self loadUniversityFromUserDefaults];
        }
        
        // initialize the location monitor to start getting location updates
        [LocationMonitor sharedLocation];
        
    }
    return self;
}

- (BOOL)saveUniversityDefaults {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"university_existence"];
    
    return [self.university saveSelfInUserDefaults];
}

- (void)loadUniversityFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.university = [[ModelFactory modelStore] createUniversityWithName:[defaults valueForKey:@"university_name"]
                                                                 latitude:[defaults floatForKey:@"university_latitude"]
                                                                longitude:[defaults floatForKey:@"university_longitude"]
                                                                 idNumber:(int)[defaults integerForKey:@"university_idNum"]
                                                           commonWifiName:[defaults valueForKey:@"university_commonWifiName"]];
}

- (University *)getUniversity {
    return self.university;
}

- (int)getUniversityId {
    return [self.university idNum];
}

- (NSString *)getUniversityCommonWifiName {
    return self.university.commonWifiName;
}

- (void)updateRegions:(NSArray *)updatedRegions {
    if ([self.regions count] != [updatedRegions count]) {
        // the count is different, so need to track those new ones
        [self setNewRegionsToTrack:updatedRegions];
    }
    else {
        self.regions = updatedRegions;
    }
    
    [[LocationMonitor sharedLocation] checkIfAlreadyInRegion];
}

- (void)setNewRegionsToTrack:(NSArray *)regions {
    NSLog(@"Setting new regions to track");
    // when new regions are set, need to also change what is being monitored
    self.regions = regions;
    
    // when the regions that the app is tracking is updated, we need to also refresh the RegionTableView and RegionMapView Controller's
    [self setRegionsInLocationMonitorWithRegions:regions];
}

- (void)setRegionsInLocationMonitorWithRegions:(NSArray *)regions {
    [[LocationMonitor sharedLocation] setRegionsToMonitor:regions];
}

- (NSArray *)getRegions {
    return self.regions;
}

- (Region *)getUserCurrentRegion {
    return [self.locationState getRegion];
}

- (void)userEnteredRegion:(CLCircularRegion *)region {
    // This will probably be done in the background
    // The Roaming functionality takes in a Region, this method has access to the CLCircularRegion
            // aka I need to find the region that it is associated with
    
    // get the Region with the same identifier as the one we have access to
    // go through the list and find it
    for (Region *enteredRegion in [self getRegions]) {
        if ([enteredRegion.identifier isEqualToString:region.identifier]) {
            
//            [self.locationState enteredRegion:enteredRegion
//                            withBSSID:[[LocationMonitor sharedLocation] getCurrentBSSID]
//                              andSSID:[[LocationMonitor sharedLocation] getCurrentSSID]];

            
            self.locationState = [[Roaming alloc] initWithRegion:enteredRegion
                                                   BSSID:[[LocationMonitor sharedLocation] getCurrentBSSID]
                                                 andSSID:[[LocationMonitor sharedLocation] getCurrentSSID]];
            
            NSLog(@"LocationState: %@", self.locationState);
        }
    }
    
}

- (void)userExitedRegion:(CLCircularRegion *)region {
    // when user exits a region, then state goes to NotInRegion
    //self.locationState = [[NotInRegionLS alloc] init];
    [self.locationState exitedRegion];
    NSLog(@"LocationState: %@", self.locationState);
    // if the user was in a region, then call the database and call the method
    
    self.locationState = [[NotInRegionLS alloc] init];
}

// region has been confirmed
- (void)regionConfirmed{
    self.locationState = [[Studying alloc] initWithRegion:[self getUserCurrentRegion]
                                            BSSID:[[LocationMonitor sharedLocation] getCurrentBSSID]
                                          andSSID:[[LocationMonitor sharedLocation] getCurrentSSID]];
}

- (UIColor *)convertRegionPopulationToColorWithCurrentPop:(int)currentPopulation andMaxCapacity:(int)maxCapacity {
    // hue of 0.0 == RED hue of .33 = GREEN
    // so the color needs to be between that, divide the color
    if (maxCapacity == 0) {
        // if the max capacity is 0, then we would be diving by a zero number. which is no bueno
        // if that's the case, then return black
        return [UIColor blackColor];
    }
    
    //so this is mapped from [0.0, 1.0], need to constrain this to [0.0, 0.33]
    // subtract 1.0 from what the value is to invert it, then constrain it to [0.0, 0.33] by dividing by 3.0
    float color = (1.0f - ((float)currentPopulation/maxCapacity)) / 3.0f;
    return [UIColor colorWithHue:color saturation:0.75f brightness:0.9f alpha:0.7f];
}

#pragma mark - Local Notification Methods

- (void)createLocalNotificationWithAlertBody:(NSString *)alert {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alert;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
