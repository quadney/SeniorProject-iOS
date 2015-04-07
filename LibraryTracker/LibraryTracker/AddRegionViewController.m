//
//  AddRegionViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/5/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "AddRegionViewController.h"
#import "ApplicationState.h"
#import "LocationMonitor.h"

@interface AddRegionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@end

@implementation AddRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.navigationItem.title = @"Add Region";
    
    [self updateCurrentLocationLabel];
}

- (CLLocation *)getUserLocation {
    
    return [[LocationMonitor sharedLocation] getCurrentLocation];
}

- (IBAction)checkWhichRegionsAreMonitoring:(id)sender {
    NSLog(@"Monitoring regions: %@", [[[LocationMonitor sharedLocation] locationManager] monitoredRegions]);
}

- (IBAction)addRegionWasPressed:(id)sender {
    [self updateCurrentLocationLabel];
    // add Region to the model (this should be done in the backend when ready)
//    [[ApplicationState sharedInstance] addRegionWithName:self.regionTextField.text
//                                                location:[[LocationMonitor sharedLocation] getCurrentLocation]
//                                                  radius:50];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCurrentLocationLabel {
    CLLocation *currentLocation = [self getUserLocation];
    
    self.currentLocationLabel.text = [[NSString alloc] initWithFormat:@"Latitude: %f\nLongitude: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
}

@end
