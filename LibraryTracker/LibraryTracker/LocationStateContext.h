//
//  LocationStateHolder.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/12/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"

@interface LocationStateContext : NSObject

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid;
- (void)exitedRegion;
- (void)regionConfirmedWithRegion:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid;
- (Region *)getRegion;

@end
