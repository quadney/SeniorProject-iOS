//
//  LocationState.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"
#import "Zone.h"

@interface LocationState : NSObject

@property LocationState *userState;

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid;
- (void)exitedRegion;
- (Region *)getRegion;

@end
