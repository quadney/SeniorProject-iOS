//
//  InRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@implementation InRegionLS

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    self = [super initWithContext:context];
    
    if (self) {
        self.currentRegion = region;
        self.currentZone = [region findZoneInRegionWithBssid:bssid];
        self.currentBSSID = bssid;
        self.universityCommonSSID = ssid;
    }
    return self;
}

- (id)initToRestoreState:(UserState)state withContext:(LocationStateContext *)context {
    NSLog(@"initToRestoreState, state: %lu", state);
    self = [super initWithContext:context];
    // now need to set the Region based on what the identifier is, and find the appropriate zone
    
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *regionData = [defaults objectForKey:@"user_region"];
        
        self.userState = state;
        self.currentRegion = [NSKeyedUnarchiver unarchiveObjectWithData:regionData];
        NSLog(@"Current Region from unarchived data: %@", self.currentRegion);
        
        
        self.currentZone = [self.currentRegion findZoneWithIdentifier:[defaults objectForKey:@"user_zone"]];
        self.currentBSSID = [defaults objectForKey:@"user_bssid"];
        self.universityCommonSSID = [defaults objectForKey:@"university_commonWifiName"];
    }
    
    return self;
}

- (Region *)getRegion {
    return self.currentRegion;
}

- (void)saveUserState {
    [super saveUserState];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.currentRegion] forKey:@"user_region"];
    //[[NSUserDefaults standardUserDefaults] setObject:self.currentRegion.identifier forKey:@"user_region"];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentZone.identifier forKey:@"user_zone"];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentBSSID forKey:@"user_bssid"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
