//
//  SelectUniversityTableViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "SelectUniversityTableViewController.h"
#import "ApplicationState.h"
#import "Region.h"

@interface SelectUniversityTableViewController ()

@property (strong, nonatomic) NSMutableArray *universities;

@end

@implementation SelectUniversityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    Region *libraryWest = [[Region alloc] initWithIdentifier:@"Library West"
                                                      center:[[CLLocation alloc] initWithLatitude:29.651339
                                                                                        longitude:-82.342832]
                                                      radius:50.0
                                                    idNumber:0];
    Region *marstonLibrary = [[Region alloc] initWithIdentifier:@"Marston Library"
                                                         center:[[CLLocation alloc] initWithLatitude:29.647996
                                                                                           longitude:-82.343905]
                                                         radius:50.0
                                                       idNumber:1];
    Region *archLibrary = [[Region alloc] initWithIdentifier:@"Architecture and Fine Arts Library"
                                                      center:[[CLLocation alloc] initWithLatitude:29.648167
                                                                                        longitude:-82.340596]
                                                      radius:50.0
                                                    idNumber:2];
    
    Region *educationLibrary = [[Region alloc] initWithIdentifier:@"Education Library"
                                                           center:[[CLLocation alloc] initWithLatitude:29.646653
                                                                                             longitude:-82.337705]
                                                           radius:50.0
                                                         idNumber:3];
    Region *lawLibrary = [[Region alloc] initWithIdentifier:@"Law Library"
                                                     center:[[CLLocation alloc] initWithLatitude:29.649803
                                                                                       longitude:-82.359152]
                                                     radius:50.0
                                                   idNumber:4];
    
    Region *smathers = [[Region alloc] initWithIdentifier:@"Smather's Library"
                                                   center:[[CLLocation alloc] initWithLatitude:29.650825
                                                                                     longitude:-82.341754]
                                                   radius:50.0
                                                 idNumber:5];
    
    University *uf = [[University alloc] initWithName:@"University of Florida"
                                             location:[[CLLocation alloc] initWithLatitude:29.64363
                                                                                 longitude:-82.35493]
                                              regions:@[libraryWest, marstonLibrary, archLibrary, educationLibrary, lawLibrary, smathers]
                                             idNumber:0];
    
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
