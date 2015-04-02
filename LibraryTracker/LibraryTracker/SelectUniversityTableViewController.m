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

@property (strong, nonatomic) NSMutableArray *universities;

@end

@implementation SelectUniversityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    // start a spinner loading
    // todo
    
    // connect to the api
    NSLog(@"calling Libwherey client to get the unviersities");
    [[LibwhereyClient sharedClient] getUniversitiesWithCompletion:^(BOOL success, NSError *__autoreleasing *error, NSArray *universities) {
        // if success, set the universities accordingly
        if (success) {
            // set the universities to be what the network returned
            self.universities = [[NSMutableArray alloc] initWithArray:universities];
            
            // stop the spinner
            // todo
            
            // reload the table data
            [self.tableView reloadData];
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
    [[ApplicationState sharedInstance] setUniversity:[self.universities objectAtIndex:indexPath.row]];
    
    // now need to query the database for the regions of that selected university
    
    //when the university is selected, we need to add the University's Regions to the geofence
    [self dismissViewControllerAnimated:YES completion:nil];
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
