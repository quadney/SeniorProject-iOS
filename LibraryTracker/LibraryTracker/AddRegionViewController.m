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
    
    [self configureGoogleMapsWithLocation:[[LocationMonitor sharedLocation] getCurrentLocation] zoomLevel:6];
}


- (void)configureGoogleMapsWithLocation:(CLLocation *)location zoomLevel:(int)zoom {
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.delegate = self;
    
    self.currentLocationLabel.text = [[NSString alloc] initWithFormat:@"Latitude: %f\nLongitude: %f\nAltitude: %f", location.coordinate.latitude, location.coordinate.longitude, location.altitude];
}

- (IBAction)addRegionWasPressed:(id)sender {
    CLLocation *location = [[LocationMonitor sharedLocation] getCurrentLocation];
    self.currentLocationLabel.text = [[NSString alloc] initWithFormat:@"Latitude: %f\nLongitude: %f\nAltitude: %f", location.coordinate.latitude, location.coordinate.longitude, location.altitude];
}

@end
