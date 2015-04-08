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
    self.zoneLabel.text = [NSString stringWithFormat:@"Zone: %@", [self getCurrentZone].identifier];
}

- (Zone *)getCurrentZone {
    Region *currentRegion = [[ApplicationState sharedInstance] getUserCurrentRegion];
    NSString *currentBssid = [[LocationMonitor sharedLocation] getCurrentBSSID];
    
    NSLog(@"Querying the zones of the region");
    for (Zone *zone in [currentRegion zones]) {
        // go through each zone to see if BSSID matches
        if ([zone.identifier isEqualToString:@"Unknown Floor"]) {
            return zone;
        }
        for (NSString *bssid in [zone bssidWifiData]) {
            if ([bssid isEqualToString:currentBssid]) {
                // found it
                return zone;
            }
        }
    }
    // if the wifi is not on, then return unknown zone
    return nil;
}

@end
