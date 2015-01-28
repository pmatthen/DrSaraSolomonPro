//
//  AddFoodViewControllerStep2.h
//  MyProfile
//
//  Created by Poulose Matthen on 15/09/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "CoreDataStack.h"

@interface AddFoodViewControllerStep2 : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSDate *trackerDate;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)searchButtonTouched:(id)sender;
- (IBAction)doneButtonTouched:(id)sender;
- (IBAction)indexChanged:(id)sender;
- (IBAction)selectionButtonClicked:(id)sender;

@end
