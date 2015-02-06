//
//  AddRegionViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/5/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "AddRegionViewController.h"
#import "ApplicationState.h"
#import "LocationMonitor.h"

@interface AddRegionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *regionTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;

@end

@implementation AddRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parentViewController.title = @"Add Region";
    self.currentLocationLabel.text = @"";
    [self enableBackgroundTapToDismissKeyboard];
}

- (IBAction)getCurrentLocationWasPressed:(id)sender {
    CLLocationCoordinate2D loc = [[LocationMonitor sharedLocation] getCurrentLocation].coordinate;
    
    self.currentLocationLabel.text = [[NSString alloc] initWithFormat:@"Latitude: %f\nLongitude: %f", loc.latitude, loc.longitude];
}

- (IBAction)addRegionWasPressed:(id)sender {
    // add Region to the model (this should be done in the backend when ready)
    [[ApplicationState sharedInstance] addRegionWithName:self.regionTextField.text
                                                location:[[LocationMonitor sharedLocation] getCurrentLocation]
                                                  radius:50];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enableBackgroundTapToDismissKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(backgroundWasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backgroundWasTapped:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

@end
