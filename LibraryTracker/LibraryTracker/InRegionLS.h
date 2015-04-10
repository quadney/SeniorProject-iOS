//
//  InRegionLS.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LocationState.h"

@interface InRegionLS : LocationState

@property (strong, nonatomic) Region *userCurrentRegion;
@property (strong, nonatomic) Zone *userCurrentZone;
@property (strong, nonatomic) NSString *currentBSSID;

- (id)initWithRegion:(Region *)region withZone:(Zone *)zone andBSSID:(NSString *)bssid;

- (void)updateZone:(Zone *)zone;
- (void)updateBSSID:(NSString *)bssid;

@end
