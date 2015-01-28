//
//  ForgotPasswordViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 17/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ForgotPasswordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)resetPasswordButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
