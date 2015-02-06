//
//  ApplicationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationState.h"
#import "ModelFactory.h"

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

- (NSMutableArray *)getRegions {
    return [self.university regions];
}

- (void)addRegionWithName:(NSString *)name location:(CLLocation *)location radius:(CLLocationDistance)radius {
    [self.university addRegion:[[ModelFactory sharedInstance] createRegionWithName:name
                                                                          location:location
                                                                            radius:radius
                                                                             zones:nil]];
}

@end
