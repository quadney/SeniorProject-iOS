//
//  LocationMonitor.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationMonitor : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
// singleton
+(id)sharedLocation;

// geofencing/region monitoring methods
- (void)addRegions:(NSArray *)regions;
- (void)clearRegionsMonitoring;

- (CLLocation *)getCurrentLocation;

@end
