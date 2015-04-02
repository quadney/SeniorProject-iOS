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
#import <GoogleMaps/GoogleMaps.h>

@interface AddRegionViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation AddRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.navigationItem.title = @"Add Region";
    self.currentLocationLabel.text = @"";
    
    [self configureGoogleMapsWithLocation:[self getUserLocation] zoomLevel:6];
}

- (CLLocationCoordinate2D)getUserLocation {
    
    return [[LocationMonitor sharedLocation] getCurrentLocation].coordinate;
}

- (void)configureGoogleMapsWithLocation:(CLLocationCoordinate2D)location zoomLevel:(int)zoom {
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.delegate = self;
    
    self.currentLocationLabel.text = [[NSString alloc] initWithFormat:@"Latitude: %f\nLongitude: %f", location.latitude, location.longitude];
}

- (IBAction)addRegionWasPressed:(id)sender {
    // add Region to the model (this should be done in the backend when ready)
//    [[ApplicationState sharedInstance] addRegionWithName:self.regionTextField.text
//                                                location:[[LocationMonitor sharedLocation] getCurrentLocation]
//                                                  radius:50];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
