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
@property float altitude;

- (id)initWithIdentifier:(NSString *)identifier wifiBssidValues:(NSArray *)bssids idNumber:(int)idNum currentPopulation:(int)currentPop capacity:(int)maxCapacity altitude:(float)altitude;

@end
