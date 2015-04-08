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
#import "LibwhereyClient.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if university is not selected or saved
    if ( ![[ApplicationState sharedInstance] getUniversity] ) {
        //load the University selection controller
        SelectUniversityTableViewController *univ = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectUniversityVC"];
        
        [self.parentViewController presentViewController:univ animated:YES completion:nil];
    }
    else if (![[ApplicationState sharedInstance] getRegions]) {
        // if regions do not exist, but the university does, then need to refresh the regions from the database
        NSLog(@"Fetching Region data from database");
        
        [[LibwhereyClient sharedClient] getRegionsFromUniversityWithId:[[ApplicationState sharedInstance] getUniversityId] completion:^(BOOL success, NSError *__autoreleasing *error, NSArray *regions) {
            
            if (success) {
                [[ApplicationState sharedInstance] setNewRegionsToTrack:regions];
            }
        }];
    }
    
    self.navigationItem.title = [[[ApplicationState sharedInstance] getUniversity] name];
}

@end
