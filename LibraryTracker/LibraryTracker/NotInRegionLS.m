//
//  NotInRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "NotInRegionLS.h"
#import "Roaming.h"

@implementation NotInRegionLS

- (id)initWithContext:(LocationStateContext *)context {
    self = [super initWithContext:context];
    
    self.userState = UserStateNotInRegion;
    
    [self saveUserState];
    
    return self;
}

- (Roaming *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"NOT IN REGION enteredRegion");
    
    return [[Roaming alloc] initWithContext:self.context region:region BSSID:bssid andSSID:ssid];
}

- (NotInRegionLS *)exitedRegion {
    NSLog(@"NOT IN REGION enteredRegion");
    
    // invalid state, nothing should change, so return self
    return self;
}

- (Region *)getRegion {
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NOT IN REGION // "];
}

- (void)saveUserState {
    [super saveUserState];
    [[NSUserDefaults standardUserDefaults] setObject:@"none" forKey:@"user_region"];
    [[NSUserDefaults standardUserDefaults] setObject:@"none" forKey:@"user_zone"];
    [[NSUserDefaults standardUserDefaults] setObject:@"none" forKey:@"user_bssid"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
