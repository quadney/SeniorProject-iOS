//
//  ApplicationViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationViewController.h"

#import "ApplicationState.h"
#import "SelectUniversityTableViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if university is not selected
    if ( ![[ApplicationState sharedInstance] getUniversity] ) {
        //load the University selection controller
        SelectUniversityTableViewController *univ = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectUniversityVC"];
        
        [self.parentViewController presentViewController:univ animated:YES completion:^{
            
        }];
    }
    
    self.navigationItem.title = [[[ApplicationState sharedInstance] getUniversity] name];
}

@end
