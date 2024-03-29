//
//  InRegionLS.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationState.h"

@interface InRegionLS : LocationState

@property (strong, nonatomic) Region *currentRegion;
@property (strong, nonatomic) Zone *currentZone;
@property (strong, nonatomic) NSString *currentBSSID;
@property (strong, nonatomic) NSString *universityCommonSSID;

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region zone:(Zone *)zone BSSID:(NSString *)bssid andSSID:(NSString *)ssid;

@end
