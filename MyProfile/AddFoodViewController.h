//
//  AddFoodViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 29/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFoodViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSDate *trackerDate;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

@end
