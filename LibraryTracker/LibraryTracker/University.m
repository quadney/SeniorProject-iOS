//
//  University.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "University.h"

@implementation University

- (id)initWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude idNumber:(int)idNum commonWifiName:(NSString *)wifiName {
    
    if (self = [super init]) {
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.idNum = idNum;
        self.commonWifiName = wifiName;
    }
    return self;
}

- (BOOL)saveSelfInUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:self.name forKey:@"university_name"];
    [defaults setFloat:self.latitude forKey:@"university_latitude"];
    [defaults setFloat:self.longitude forKey:@"university_longitude"];
    [defaults setInteger:self.idNum forKey:@"university_idNum"];
    [defaults setValue:self.commonWifiName forKey:@"university_commonWifiName"];
    return [defaults synchronize];
}

@end
