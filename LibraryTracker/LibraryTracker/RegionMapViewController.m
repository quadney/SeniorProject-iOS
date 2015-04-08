//
//  RegionMapViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RegionDetailViewController.h"

@interface RegionMapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation RegionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    University *university = [[ApplicationState sharedInstance] getUniversity];
    
    if (university) {
        [self configureGoogleMapsWithLatitude:[university latitude]
                                    longitude:[university longitude]
                                    zoomLevel:15
                                         name:[university name]];
        [self refreshRegions];
    }
    else {
        NSLog(@"No Associated University");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];     // let's try this out, I don't think this is good practice though
    //[self refreshRegions];
}

- (void)configureGoogleMapsWithLatitude:(float)latitude longitude:(float)longitude zoomLevel:(int)zoom name:(NSString *)name {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.delegate = self;
}

- (void)placeGoogleMapMarkers:(NSArray *)markerLocations {
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
