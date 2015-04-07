//
//  RegionViewController.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationState.h"

@interface RegionViewController : UIViewController

- (UIColor *)convertRegionPopulationToColorWithCurrentPop:(int)currentPopulation andMaxCapacity:(int)maxCapacity;

@end
