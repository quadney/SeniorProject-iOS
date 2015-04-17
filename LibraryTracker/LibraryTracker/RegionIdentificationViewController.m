//
//  RegionIdentificationHelper.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/8/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionIdentificationViewController.h"
#import "ApplicationState.h"
#import "LocationMonitor.h"
#import "Region.h"
#import "Zone.h"
#import "LocationState.h"

@interface RegionIdentificationViewController()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *bssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userState;

@end

@implementation RegionIdentificationViewController

- (void)viewDidLoad {
    [self updateLocationStateLabel:nil];
}

- (IBAction)updateLocationStateLabel:(id)sender {
    Region *region = [[ApplicationState sharedInstance] getUserCurrentRegion];
    NSString *BSSID = [[LocationMonitor sharedLocation] getCurrentBSSID];
    Zone *zone = [[ApplicationState sharedInstance] getUserCurrentZone];
    self.locationLabel.text = [NSString stringWithFormat:@"Location: lat: %f, long: %f", [[LocationMonitor sharedLocation] getCurrentLocation].coordinate.latitude, [[LocationMonitor sharedLocation] getCurrentLocation].coordinate.longitude];
    self.regionLabel.text = [NSString stringWithFormat:@"Region: %@", region.identifier];
    self.bssidLabel.text = [NSString stringWithFormat:@"BSSID: %@", BSSID];
    self.zoneLabel.text = [NSString stringWithFormat:@"Zone: %@", zone.identifier];
    
    self.locationStateLabel.text = [[ApplicationState sharedInstance] getLocationState];
    
    self.userState.text = [NSString stringWithFormat:@"Region id: %i, Zone id: %i", [[ApplicationState sharedInstance] getUserCurrentRegion].idNum, [[ApplicationState sharedInstance] getUserCurrentZone].idNumber];
}


@end
