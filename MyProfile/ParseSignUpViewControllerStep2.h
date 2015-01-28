//
//  ParseSignUpViewControllerStep2.h
//  MyProfile
//
//  Created by Poulose Matthen on 26/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseSignUpViewControllerStep2 : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property NSMutableArray *ageArray;
@property NSString *name;
@property NSString *email;
@property NSString *username;
@property NSString *password;

- (IBAction)startOverButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;

@end
