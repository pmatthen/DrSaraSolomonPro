//
//  DailyTrackerViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 29/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"
#import "Parse/Parse.h"

@interface DailyTrackerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *calculateMacrosButton;

- (IBAction)dateButtonPrevious:(id)sender;
- (IBAction)dateButtonNext:(id)sender;

- (IBAction)calculateMacroButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end