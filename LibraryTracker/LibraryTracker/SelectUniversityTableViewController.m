//
//  SelectUniversityTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "SelectUniversityTableViewController.h"
#import "ApplicationState.h"
#import "LibwhereyClient.h"

@interface SelectUniversityTableViewController ()

@property (strong, nonatomic) NSArray *universities;

@end

@implementation SelectUniversityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // setup the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingSpinner.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [loadingSpinner startAnimating];
    
    // connect to the api
    [[LibwhereyClient sharedClient] getUniversitiesWithCompletion:^(BOOL success, NSError *__autoreleasing *error, NSArray *universities) {
        // if success, set the universities accordingly
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // set the universities to be what the network returned
                self.universities = universities;
            
                // stop the spinner
                [loadingSpinner stopAnimating];
                [loadingSpinner removeFromSuperview];
            
                // reload the table data
                [self.tableView reloadData];
            });
        }
        else {
            // display an alert that there's a network connection error or something
            // for right now just output the error
            NSLog(@"There was a problem getting the universities");
        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.universities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UniversityCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.universities objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // sets the University to the ApplicationState,
    // but this Unviersity doesn't know about it's regions
    [[ApplicationState sharedInstance] setUniversity:[self.universities objectAtIndex:indexPath.row]];
    [[ApplicationState sharedInstance] saveUniversityDefaults];
    
    //when the university is selected, we need to add the University's Regions to the geofence
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
