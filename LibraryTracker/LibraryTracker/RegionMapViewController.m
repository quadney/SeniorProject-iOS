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
    for (Region *region in markerLocations) {
        GMSCircle *circle = [GMSCircle circleWithPosition:region.center radius:region.radius];
        circle.fillColor = [self convertRegionPopulationToColorWithCurrentPop:[region calculateCurrentPopulation] andMaxCapacity:region.totalCapacity];
        circle.map = self.mapView;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    // query the circular regions to see if the tapped location corresponds to a Region
    // this can actually be accomplished with the CLRegion interface
    for (Region *region in [[ApplicationState sharedInstance] getRegions]) {
        if ([region containsCoordinate:coordinate]) {
            NSLog(@"Tapped region with identifier: %@", region.identifier);
            // now that we tapped a region, let's display the RegionDetailViewController
            
            RegionDetailViewController *detail = (RegionDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RegionDetailViewController"];

            detail.region = region;
            
            [self.parentViewController showViewController:detail sender:self];
            
        }
    }
}

- (void)refreshRegions {
    [self placeGoogleMapMarkers:[[ApplicationState sharedInstance] getRegions]];
}

@end
