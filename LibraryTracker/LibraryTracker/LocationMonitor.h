//
//  LocationMonitor.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMonitor : NSObject 

// singleton
+(id)sharedLocation;

// geofencing/region monitoring methods
- (void)setRegionsToMonitor:(NSArray *)regions;
- (void)clearRegionsMonitoring;
- (void)checkIfAlreadyInRegion;

- (NSSet *)getMonitoredRegions;
- (CLLocation *)getCurrentLocation;

- (NSString *)getCurrentBSSID;
- (NSString *)getCurrentSSID;
- (NSString *)getCurrentRegionIdentifier;


@end
