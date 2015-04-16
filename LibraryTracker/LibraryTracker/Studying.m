//
//  Stationary.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "Studying.h"
#import "NotInRegionLS.h"
#import "Roaming.h"
#import "LibwhereyClient.h"

@implementation Studying

- (id)initWithContext:(LocationStateContext *)context region:(Region *)region BSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    
    self = [super initWithContext:context region:region BSSID:bssid andSSID:ssid];
    
    // the user is now studying
    [self userStartedStudying];
    
    return self;
}

- (void)userStartedStudying {
    NSLog(@"STUDYING userStartedStudying");
    
    // tell the database to
    [[LibwhereyClient sharedClient] userEntersZoneWithId:self.currentZone.idNumber];
    
    [self createLocalNotificationWithAlertBody:[NSString stringWithFormat:@"User is now studying, region: %@, zone: %@", self.currentRegion, self.currentZone]];
}

- (InRegionLS *)enteredRegion:(Region *)region withBSSID:(NSString *)bssid andSSID:(NSString *)ssid {
    NSLog(@"STUDYING enteredRegion");
    
    if (![self.currentRegion.identifier isEqualToString:region.identifier]) {
        // call the network to remove the person from the Zone
        [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
    
        return [[Roaming alloc] initWithContext:self.context region:region BSSID:bssid andSSID:ssid];
    }
    
    return self;
}

- (NotInRegionLS *)exitedRegion {
    NSLog(@"STUDYING exitedRegion");
    
    // call the network to remove the person from the Zone
    [[LibwhereyClient sharedClient] userExitsZoneWithId:self.currentZone.idNumber];
    
    return [[NotInRegionLS alloc] initWithContext:self.context];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"STUDYING // "];
}

#pragma mark - Local Notification Methods

- (void)createLocalNotificationWithAlertBody:(NSString *)alert {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alert;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    notification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
