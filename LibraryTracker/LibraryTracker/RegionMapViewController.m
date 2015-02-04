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
    }
    else {
        NSLog(@"Map not loaded");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
