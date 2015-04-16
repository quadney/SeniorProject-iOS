//
//  University.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "University.h"

#define kName       @"name"
#define kLatitude   @"latitude"
#define kLongitude  @"longitude"
#define kIdNumber   @"idNumer"
#define kWifiName   @"wifiName"

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithName:[aDecoder decodeObjectForKey:kName]
                     latitude:[aDecoder decodeFloatForKey:kLatitude]
                    longitude:[aDecoder decodeFloatForKey:kLongitude]
                     idNumber:(int)[aDecoder decodeIntegerForKey:kIdNumber]
               commonWifiName:[aDecoder decodeObjectForKey:kWifiName]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:kName];
    [aCoder encodeFloat:self.latitude forKey:kLatitude];
    [aCoder encodeFloat:self.longitude forKey:kLongitude];
    [aCoder encodeInteger:self.idNum forKey:kIdNumber];
    [aCoder encodeObject:self.commonWifiName forKey:kWifiName];
}

@end
