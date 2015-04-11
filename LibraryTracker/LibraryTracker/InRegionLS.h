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
@property (strong, nonatomic) NSString *universityCommonIPAddress;

- (id)initWithRegion:(Region *)region BSSID:(NSString *)bssid andIPAddress:(NSString *)ipAddress;

@end
