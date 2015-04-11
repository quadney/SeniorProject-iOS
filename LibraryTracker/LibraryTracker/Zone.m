//
//  Zone.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Zone.h"

@implementation Zone

- (id)initWithIdentifier:(NSString *)identifier wifiBssidValues:(NSArray *)bssids idNumber:(int)idNum currentPopulation:(int)currentPop capacity:(int)maxCapacity{
    if (self = [super init]) {
        self.idNumber = idNum;
        self.identifier = identifier;
        self.bssidWifiData = bssids;
        self.currentPopulation = currentPop;
        self.maxCapacity = maxCapacity;
    }
    return self;
}

- (BOOL)bssidIsInZone:(NSString *)currentBSSID {
    for (NSString *bssid in self.bssidWifiData) {
        if ([bssid isEqualToString:currentBSSID]) {
            // found it
            return YES;
        }
    }
    return NO;
}

@end
