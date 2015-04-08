//
//  RegionTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionTableViewController.h"
#import "RegionDetailViewController.h"
#import "LibwhereyClient.h"
#import "ApplicationState.h"

@implementation RegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshRegions:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)refreshRegions:(id)sender {
    NSLog(@"Refreshing regions");
    
    
    if(self.refreshControl)
        [self.refreshControl endRefreshing];
    
//    [LibwhereyClient sharedClient] 
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[[ApplicationState sharedInstance] getRegions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegionCell" forIndexPath:indexPath];
    
    Region *region = [[[ApplicationState sharedInstance] getRegions] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [region identifier];
    cell.contentView.backgroundColor =  [[ApplicationState sharedInstance] convertRegionPopulationToColorWithCurrentPop:[region calculateCurrentPopulation]
                                                                            andMaxCapacity:[region totalCapacity]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"RegionDetailSegue"]) {
        RegionDetailViewController *detail = (RegionDetailViewController *)[segue destinationViewController];
        
        Region *region = [[[ApplicationState sharedInstance] getRegions] objectAtIndex:(int)[[self.tableView indexPathForSelectedRow] row]];
        detail.region = region;
    }
    
}

@end
