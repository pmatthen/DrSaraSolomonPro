//
//  ParseSignUpViewControllerStep2.h
//  MyProfile
//
//  Created by Vanaja Matthen on 16/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface ParseSignUpViewControllerStep3 : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@property NSMutableArray *weightArray;
@property NSString *name;
@property NSString *email;
@property NSString *username;
@property NSString *password;
@property int age;

- (IBAction)startOverButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;

@end
