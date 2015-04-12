//
//  NotInRegionLS.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "NotInRegionLS.h"
#import "Roaming.h"

@implementation NotInRegionLS

- (id)initWithContext:(LocationStateContext *)context {
    self = [super initWithContext:context];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"user_studying"];
    [defaults synchronize];
    
    return self;
}

- (void)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
}

- (void)exitedRegion {
    // invalid state
    @throw [NSException exceptionWithName:@"IllegalState"
                                   reason:@"User cannot exit a region if they are not in a region"
                                 userInfo:nil];
}

- (Region *)getRegion {
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"NOT IN REGION // "];
}
@end
