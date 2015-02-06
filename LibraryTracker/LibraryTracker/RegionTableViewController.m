//
//  RegionTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionTableViewController.h"
#import "RegionTableViewCell.h"
#import "ApplicationState.h"

@interface RegionTableViewController ()

@property (strong, nonatomic) NSArray *regions;

@end

@implementation RegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.regions = [[NSArray alloc] init];
    if ([[ApplicationState sharedInstance] university]) {
        self.regions = [[ApplicationState sharedInstance] getRegions];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.regions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegionCell" forIndexPath:indexPath];
    
    cell.regionLabel.text = [[self.regions objectAtIndex:indexPath.row] identifier];
    //TODO set the color for the view indicator
    
    return cell;
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
