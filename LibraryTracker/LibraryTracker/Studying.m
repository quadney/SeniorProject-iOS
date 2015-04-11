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

- (id)initWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
    self = [super initWithRegion:region BSSID:bssid andSSID:ssid];
    
    [[LibwhereyClient sharedClient] userEntersZoneWithId:self.currentZone.idNumber];

    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    self.userState = [[Roaming alloc] initWithRegion:region BSSID:bssid andSSID:ssid];
}

- (void)exitedRegion {
    // call the network to remove the person from the Zone
    [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
    
    //set the user state to NotInRegion
    self.userState = [[NotInRegionLS alloc] init];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING // "];
}

@end
