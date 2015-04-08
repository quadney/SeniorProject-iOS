//
//  RegionDetailViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "RegionDetailViewController.h"
#import "Zone.h"

@interface RegionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *populationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RegionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.region.identifier;
    self.populationLabel.text = [NSString stringWithFormat:@"%i/%i", [self.region calculateCurrentPopulation], self.region.totalCapacity];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.region zones] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZoneCell"];
    
    Zone *zone = [[self.region zones] objectAtIndex:indexPath.row];
    cell.textLabel.text = zone.identifier;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i/%i", zone.currentPopulation, zone.maxCapacity];
    cell.contentView.backgroundColor =  [self convertRegionPopulationToColorWithCurrentPop:zone.currentPopulation
                                                                            andMaxCapacity:zone.maxCapacity];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
