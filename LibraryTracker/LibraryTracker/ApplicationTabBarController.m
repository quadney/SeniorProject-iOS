//
//  ApplicationViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationTabBarController.h"

#import "ApplicationState.h"
#import "SelectUniversityTableViewController.h"
#import "LibwhereyClient.h"

@interface ApplicationTabBarController ()

@end

@implementation ApplicationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[ApplicationState sharedInstance] getUniversity] && ![[ApplicationState sharedInstance] getRegions]) {
        [self getRegionsFromLibwhereyClient];
    }
    
}

- (void)viewDidAppear:(BOOL)animated  {
    // if university is not selected or saved
    
    if ( ![[ApplicationState sharedInstance] getUniversity] ) {
        //load the University selection controller
        SelectUniversityTableViewController *univ = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectUniversityVC"];
        
        // SUPER HACK-Y WAY OF DOIGN THIS
        univ.returningViewController = self.viewControllers[0];
        
        [self presentViewController:univ animated:NO completion:nil];
    }
    else if (![[ApplicationState sharedInstance] getRegions]) {
        [self getRegionsFromLibwhereyClient];
    }
}

- (void)getRegionsFromLibwhereyClient {
    NSLog(@"ApplicationTabBarController getRegionsFromLibwhereyClient");
    
    // if regions do not exist, but the university does, then need to refresh the regions from the database
    
    [[LibwhereyClient sharedClient] getRegionsFromUniversityWithId:[[ApplicationState sharedInstance] getUniversityId] completion:^(BOOL success, NSError *__autoreleasing *error, NSArray *regions) {
        
        if (success) {
            [[ApplicationState sharedInstance] setNewRegionsToTrack:regions];
        }
    }];
}

@end
