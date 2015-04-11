//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "LibwhereyClient.h"
#import "ApplicationState.h"

@implementation Studying

- (id)initWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
    self = [super initWithRegion:region BSSID:bssid andSSID:ssid];
    
    [[ApplicationState sharedInstance] regionConfirmed];

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING - region: %@, Zone: %@", self.currentRegion.identifier, self.currentZone.identifier];
}

@end
