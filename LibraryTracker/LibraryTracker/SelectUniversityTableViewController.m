//
//  SelectUniversityTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "SelectUniversityTableViewController.h"
#import "University.h"
#import "ApplicationState.h"

@interface SelectUniversityTableViewController ()

@property (strong, nonatomic) NSMutableArray *universities;

@end

@implementation SelectUniversityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    University *uf = [[University alloc] initWithName:@"University of Florida"
                                             location:[[CLLocation alloc] initWithLatitude:29.64363
                                                                                 longitude:-82.35493]
                                              regions:nil];
    self.universities = [[NSMutableArray alloc] initWithObjects:uf, nil];
        
    [self.tableView reloadData];
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
