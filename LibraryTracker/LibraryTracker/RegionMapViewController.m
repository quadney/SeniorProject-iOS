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
#import "ApplicationState.h"
#import "LibwhereyClient.h"

@interface RegionMapViewController () <GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@end

@implementation RegionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    University *university = [[ApplicationState sharedInstance] getUniversity];
    
    if (university) {
        [self configureGoogleMapsWithLatitude:[university latitude]
                                    longitude:[university longitude]
                                    zoomLevel:15
                                         name:[university name]];
        [self refreshRegions];
        self.navigationItem.title = [university name];
    }
    else {
        NSLog(@"No Associated University");
    }

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
        circle.fillColor = [[ApplicationState sharedInstance] convertRegionPopulationToColorWithCurrentPop:[region calculateCurrentPopulation] andMaxCapacity:region.totalCapacity];
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
    if ([[[ApplicationState sharedInstance] getRegions] count] == 0) {
        // need to refresh the regions
        
        // setup the loading spinner
        UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //[self.view addSubview:loadingSpinner];
        loadingSpinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [loadingSpinner startAnimating];
        
        [[LibwhereyClient sharedClient] getRegionsFromUniversityWithId:[[ApplicationState sharedInstance] getUniversityId] completion:^(BOOL success, NSError *__autoreleasing *error, NSArray *regions) {
            
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //update the regions
                    [[ApplicationState sharedInstance] updateRegions:regions];
                    
                    // stop the spinner
                    [loadingSpinner stopAnimating];
                    [loadingSpinner removeFromSuperview];
                    
                    //update the view
                    [self placeGoogleMapMarkers:[[ApplicationState sharedInstance] getRegions]];
                });
            }
        }];
    }
    else {
        [self placeGoogleMapMarkers:[[ApplicationState sharedInstance] getRegions]];
    }
}

@end
