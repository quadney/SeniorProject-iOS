//
//  ApplicationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationState.h"

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

@end
