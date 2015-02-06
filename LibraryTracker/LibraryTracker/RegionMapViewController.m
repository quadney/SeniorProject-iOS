//
//  RegionMapViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionMapViewController.h"
#import "ApplicationState.h"
#import <MapKit/MapKit.h>
#import "LocationMonitor.h"

@interface RegionMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;


@end

@implementation RegionMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[ApplicationState sharedInstance] university]) {
        CLLocation *univLoc = [[[ApplicationState sharedInstance] university] location];
        
        // need to make a span in order to have proper zoomed-in area
        MKCoordinateSpan span;
        span.latitudeDelta=.05;
        span.longitudeDelta=.05;
        
        //set Region to be display on MKMapView
        MKCoordinateRegion coordinateRegion;
        coordinateRegion.center = univLoc.coordinate;
        coordinateRegion.span = span;

        [self.map setCenterCoordinate:univLoc.coordinate animated:YES];
        [self.map setRegion:coordinateRegion animated:YES];
        
        //[LocationMonitor sharedLocation]
        [self.map setShowsUserLocation:YES];
    }
    else {
        NSLog(@"Map not loaded");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Regions monitoring: %@", [[[LocationMonitor sharedLocation] locationManager] monitoredRegions]);
}

@end
