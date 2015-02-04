//
//  ApplicationViewController.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/1/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ApplicationViewController.h"
#import "RegionMapViewController.h"
#import "RegionTableViewController.h"
#import "ApplicationState.h"
#import "SelectUniversityTableViewController.h"

@interface ApplicationViewController ()
// this view controller controls the UISegmentedControl thing, and based on the state of the UISegmentControl,
// changes which {Map or Table} View Controller to use.

@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSegmentControl;
@property (copy, nonatomic) NSArray *viewControllers;   // view controllers to switch between
@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( ![[ApplicationState sharedInstance] university] ) {
        NSLog(@"presenting select university view controller");
        //load the University selection controller
        SelectUniversityTableViewController *univ = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectUniversityVC"];
        
        [self.parentViewController presentViewController:univ animated:YES completion:^{
            NSLog(@"university selection was completed");
        }];
        //I think I need to use the completion block?
    }

    
    RegionMapViewController *mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegionMapViewController"];
    RegionTableViewController *tableView = [self.storyboard instantiateViewControllerWithIdentifier:@"RegionTableViewController"];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:mapView, tableView, nil];
    
    self.viewSegmentControl.selectedSegmentIndex = 0;   //start on the Map view
    
}

- (void)cycleFromViewController:(UIViewController *)oldVC toViewController:(UIViewController *)newVC {
    if (oldVC == newVC) return;
    
    if (newVC) {
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            // Add the new view controller view to the ciew hierarchy
            [self.view addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (IBAction)changedView:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.viewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }

}

@end
