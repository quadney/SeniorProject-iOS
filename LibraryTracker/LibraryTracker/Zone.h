//
//  Zone.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject

@property int idNumber;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSArray *bssidWifiData;
@property int currentPopulation;
@property int maxCapacity;

- (id)initWithIdentifier:(NSString *)identifier wifiBssidValues:(NSArray *)bssids idNumber:(int)idNum currentPopulation:(int)currentPop capacity:(int)maxCapacity;

- (BOOL)bssidIsInZone:(NSString *)bssid;

@end
