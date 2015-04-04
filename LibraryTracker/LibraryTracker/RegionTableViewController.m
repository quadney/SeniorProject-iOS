//
//  RegionTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionTableViewController.h"

@interface RegionTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation RegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Regions: %@", [[ApplicationState sharedInstance] getRegions]);
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
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
    cell.contentView.backgroundColor =  [self convertRegionPopulationToColorWithCurrentPop:[region currentPopulation]
                                                                            andMaxCapacity:[region totalCapacity]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"RegionDetailSegue"]) {
        RegionDetailViewController *detail = (RegionDetailViewController *)[segue destinationViewController];
        detail.regionIndex = (int)[[self.tableView indexPathForSelectedRow] row];
    }
    
}

@end
