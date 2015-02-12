//
//  LocationState.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"

@interface LocationState : NSObject

@property LocationState *userState;
- (void)enteredRegion:(Region *)region;
- (void)regionConfirmed;
- (void)exitedRegion;

@end
