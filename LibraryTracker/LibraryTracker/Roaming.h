//
//  Roaming.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "InRegionLS.h"

@interface Roaming : InRegionLS

@property (strong, nonatomic) NSMutableArray *pastZones;
@property (strong, nonatomic) NSMutableArray *pastBssids;   //might not need these

@end
