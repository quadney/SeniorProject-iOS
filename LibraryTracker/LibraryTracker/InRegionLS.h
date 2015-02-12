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

- (id)initWithRegion:(Region *)region;

@end
