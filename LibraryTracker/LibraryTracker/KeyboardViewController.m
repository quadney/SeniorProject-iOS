//
//  KeyboardViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/12/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@end

@implementation KeyboardViewController
// used as a parent view so I don't have to rewrite the same code to dismiss a Keyboard

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableBackgroundTapToDismissKeyboard];
}

#pragma mark - TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Dismiss Keyboard Methods

- (void)enableBackgroundTapToDismissKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(backgroundWasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backgroundWasTapped:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

@end
