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
    
    cell.textLabel.text = [[[[ApplicationState sharedInstance] getRegions] objectAtIndex:indexPath.row] identifier];
    
    //TODO set the color for the view indicator
    cell.contentView.backgroundColor =  [UIColor colorWithRed:1.0 green:0 blue:0 alpha:.5];
    cell.textLabel.backgroundColor =    [UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.0];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"RegionDetailSegue"]) {
        RegionDetailViewController *detail = (RegionDetailViewController *)[segue destinationViewController];
        detail.regionIndex = [[self.tableView indexPathForSelectedRow] row];
    }
    
}

@end
