//
//  RegionDetailViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionDetailViewController.h"

@interface RegionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *regionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *populationLabel;

@end

@implementation RegionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.regionNameLabel.text = self.region.identifier;
    self.populationLabel.text = [NSString stringWithFormat:@"%i/%i", [self.region calculateCurrentPopulation], self.region.totalCapacity];
}

@end
