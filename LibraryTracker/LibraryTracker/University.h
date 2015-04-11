//
//  University.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface University : NSObject

@property (nonatomic, strong) NSString *name;
@property float latitude;
@property float longitude;
@property int idNum;
@property (nonatomic, strong) NSString *commonWifiName;

- (id)initWithName:(NSString *)name latitude:(float)latitude longitude:(float)longitude idNumber:(int)idNum commonWifiName:(NSString *)wifiName;
- (BOOL)saveSelfInUserDefaults;

@end
