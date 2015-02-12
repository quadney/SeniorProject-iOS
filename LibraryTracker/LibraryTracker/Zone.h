//
//  Zone.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject

@property NSString *name;
@property NSString *wifiRouterIdentifier;   //or altitude, in that case it would be a float, still undecided
@property int currentPopulation;
@property int totalCapacity;

- (id)initWithName:(NSString *)name wifiRouter:(NSString *)wifiRouterIdentity;

@end
