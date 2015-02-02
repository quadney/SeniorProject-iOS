//
//  ApplicationState.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationState.h"

//import LocationState classes
#import "NotInRegionLS.h"
#import "Stationary.h"
#import "Roaming.h"

//import University information
#import "University.h"

@interface ApplicationState()

@property (nonatomic, strong) LocationState *state;
@property (nonatomic, strong) University *university;

@end

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
        
    }
    return self;
}

@end
