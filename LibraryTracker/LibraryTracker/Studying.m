//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "Roaming.h"
#import "NotInRegionLS.h"

@implementation Studying

- (id)initWithRegion:(Region *)region withZone:(Zone *)zone BSSID:(NSString *)bssid andIPAddress:(NSString *)ipAddress {
    
    self = [super initWithRegion:region withZone:zone BSSID:bssid andIPAddress:ipAddress];

    return self;
}

//- (void)enteredRegion:(Region *)region withZone:(Zone *)zone andBssid:(NSString *)bssid {
//    // reigons may be next to each other, so entering another region is valid
//    self.userState = [[Roaming alloc] initWithRegion:region withZone:zone andBSSID:bssid];
//}
//
//- (void)exitedRegion {
//    self.userState = [[NotInRegionLS alloc] init];
//    NSLog(@"Studying - exited region: %@", self.userState);
//}

- (BOOL)updatedZone:(Zone *)zone {
    self.userCurrentZone = zone;
    return YES;
}

- (BOOL)updatedBSSID:(NSString *)bssid {
    self.currentBSSID = bssid;
    return YES;
}

- (BOOL)updatedIpAddress:(NSString *)ipAddress {
    self.currentIpAddress = ipAddress;
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING - userState: %@, region: %@", self.userState, self.userCurrentRegion.identifier];
}

@end
