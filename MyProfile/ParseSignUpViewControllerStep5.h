//
//  ParseSignUpViewControllerStep4.h
//  MyProfile
//
//  Created by Vanaja Matthen on 16/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseSignUpViewControllerStep5 : UIViewController

- (IBAction)startOverButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

@property NSArray *genderArray;
@property NSString *name;
@property NSString *email;
@property NSString *username;
@property NSString *password;
@property int age;
@property int weight;
@property int inchesHeight;

@end
