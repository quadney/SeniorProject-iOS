//
//  RegionDetailViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionDetailViewController.h"
#import "ApplicationState.h"
#import "Region.h"

@interface RegionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *regionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *populationLabel;

@end

@implementation RegionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Region *region = [[[ApplicationState sharedInstance] getRegions] objectAtIndex:self.regionIndex];
    
    self.regionNameLabel.text = region.identifier;
    self.populationLabel.text = [NSString stringWithFormat:@"%i/%i", region.currentPopulation, region.totalCapacity];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"REGION DETAIL VIEW CONTROLLER: region zone count: %i", [[ApplicationState sharedInstance] getUserCurrentRegion].zones.count);
}

@end
