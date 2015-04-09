//
//  RegionIdentificationHelper.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 4/8/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionIdentificationHelper.h"
#import "ApplicationState.h"
#import "LocationMonitor.h"
#import "Region.h"
#import "Zone.h"

@interface RegionIdentificationHelper()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *bssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneLabel;

@end

@implementation RegionIdentificationHelper

- (void)viewDidLoad {
    self.locationLabel.text = [NSString stringWithFormat:@"Location: lat: %f, long: %f", [[LocationMonitor sharedLocation] getCurrentLocation].coordinate.latitude, [[LocationMonitor sharedLocation] getCurrentLocation].coordinate.longitude];
    self.regionLabel.text = [NSString stringWithFormat:@"Region: %@", [[ApplicationState sharedInstance] getUserCurrentRegion].identifier];
    self.bssidLabel.text = [NSString stringWithFormat:@"BSSID: %@", [[LocationMonitor sharedLocation] getCurrentBSSID]];
    self.zoneLabel.text = [NSString stringWithFormat:@"Zone: %@", [[ApplicationState sharedInstance] getCurrentZone].identifier];
}

@end
