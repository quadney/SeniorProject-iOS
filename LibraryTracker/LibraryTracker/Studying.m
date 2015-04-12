//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "NotInRegionLS.h"
#import "Roaming.h"
#import "LibwhereyClient.h"

@implementation Studying

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
    self = [super initWithContext:context region:region BSSID:bssid andSSID:ssid];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"user_studying"]) {
        // if Studying is init'd and the user was not already studying
        [self userStartedStudying];
    }
    
    return self;
}

- (void)userStartedStudying {
    // tell the database to
    [[LibwhereyClient sharedClient] userEntersZoneWithId:self.currentZone.idNumber];
    
    [self setUserDefaultsWithBool:YES];
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    [self setUserDefaultsWithBool:NO];
}

- (void)exitedRegion {
    // call the network to remove the person from the Zone
    [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
}

- (void)setUserDefaultsWithBool:(BOOL)studying {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:studying forKey:@"user_studying"];
    [defaults synchronize];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING // "];
}

@end
