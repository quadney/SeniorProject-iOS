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
}

@end
