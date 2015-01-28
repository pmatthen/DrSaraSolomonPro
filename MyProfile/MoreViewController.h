//
//  MoreViewController.h
//  MyProfile
//
//  Created by Vanaja Matthen on 12/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "CoreDataStack.h"

@interface MoreViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)logoutButtonTouched:(id)sender;
- (IBAction)resetDataButtonTouched:(id)sender;

@end
