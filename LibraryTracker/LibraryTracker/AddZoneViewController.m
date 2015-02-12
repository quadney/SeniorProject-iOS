//
//  AddZoneViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/12/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "AddZoneViewController.h"
#import "ApplicationState.h"
#import "Region.h"

@interface AddZoneViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *zoneNameTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *regionsPickerView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableArray *regions;

@end

@implementation AddZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.regions = [[ApplicationState sharedInstance] getRegions];

    self.regionsPickerView.delegate = self;
    self.regionsPickerView.dataSource = self;

    [self.regionsPickerView reloadAllComponents];
    // figure out which region the user is in
    @try {
        NSLog(@"Try block");
        Region *currentRegion = [[ApplicationState sharedInstance] getUserCurrentRegion];
        if (currentRegion != nil) {
            NSLog(@"Current Region is not null");
            [self.regionsPickerView selectRow:[self.regions indexOfObject:currentRegion]
                                  inComponent:0
                                     animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"User is not in a region");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not in Region"
                                                        message:@"You must be in a Region to add a Zone"
                                                       delegate:self
                                              cancelButtonTitle:@"Welp"
                                              otherButtonTitles:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [alert show];
    }
    
    //now configure what the TextView should say
    // like wifi information
    // altitude information
}

- (IBAction)addZoneToRegion:(id)sender {
    [[ApplicationState sharedInstance] addZoneWithName:self.zoneNameTextField.text
                                        wifiIdentifier:self.textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIPickerViewDelegate methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.regions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[self.regions objectAtIndex:row] identifier];
}

@end
