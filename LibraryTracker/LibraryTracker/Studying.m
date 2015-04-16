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

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region zone:(Zone *)zone BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
    self = [super initWithContext:context region:region zone:zone BSSID:bssid andSSID:ssid];
    
    // the user is now studying
    [self userStartedStudying];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
}

- (void)userStartedStudying {
    NSLog(@"STUDYING userStartedStudying ZONE BEFORE: %i", self.currentZone.currentPopulation);
    
    // tell the database to
    [[LibwhereyClient sharedClient] userEntersZoneWithId:self.currentZone.idNumber];
}

- (InRegionLS *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"STUDYING enteredRegion");
    
    if (![self.currentRegion.identifier isEqualToString:region.identifier]) {
        
        NSLog(@"STUDYING userEnteringAntoherRegion ZONE BEFORE: %i", self.currentZone.currentPopulation);
        // call the network to remove the person from the Zone
        [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
        
    
        return [[Roaming alloc] initWithContext:self.context
                                         region:region
                                           zone:[region findZoneInRegionWithBssid:bssid]
                                          BSSID:bssid
                                        andSSID:ssid];
    }
    
    return self;
}

- (NotInRegionLS *)exitedRegion {
    NSLog(@"STUDYING exitedRegion ZONE BEFORE: %i", self.currentZone.currentPopulation);
    
    // call the network to remove the person from the Zone
    [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
    
    return [[NotInRegionLS alloc] initWithContext:self.context];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING // "];
}

@end
