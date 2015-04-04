//
//  RegionMapViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface RegionMapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation RegionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[ApplicationState sharedInstance] university]) {
        
        [self configureGoogleMapsWithLocation:[[[ApplicationState sharedInstance] university] location]
                                    zoomLevel:15
                                         name:[[[ApplicationState sharedInstance] university] name]];
        [self refreshRegions];
    }
    else {
        NSLog(@"No Associated University");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];     // let's try this out, I don't think this is good practice though
}

- (void)configureGoogleMapsWithLocation:(CLLocation *)location zoomLevel:(int)zoom name:(NSString *)name {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:zoom];
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
}

- (void)placeGoogleMapMarkers:(NSMutableArray *)markerLocations {
    //remove the markers that were there before
    [self.mapView clear];
    int i = 0;
    for (Region *region in markerLocations) {
        GMSCircle *circle = [GMSCircle circleWithPosition:region.center radius:region.radius];
        circle.fillColor = [self convertRegionPopulationToColorWithCurrentPop:region.currentPopulation andMaxCapacity:region.totalCapacity];
        circle.map = self.mapView;
        i++;
    }
}

- (void)refreshRegions {
    [self placeGoogleMapMarkers:[[ApplicationState sharedInstance] getRegions]];
}

@end
