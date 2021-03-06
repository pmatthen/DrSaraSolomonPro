//
//  ParseSignUpViewController.h
//  MyProfile
//
//  Created by Vanaja Matthen on 15/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseSignUpViewControllerStep4 : UIViewController

- (IBAction)startOverButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@property NSMutableArray *feetHeightArray;
@property NSMutableArray *inchesHeightArray;
@property NSString *name;
@property NSString *email;
@property NSString *username;
@property NSString *password;
@property int weight;
@property int age;

@end
