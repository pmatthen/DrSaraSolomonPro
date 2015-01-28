//
//  ParseSignUpViewControllerStep6.h
//  MyProfile
//
//  Created by Poulose Matthen on 30/07/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseSignUpViewControllerStep7 : UIViewController

- (IBAction)startGettingSexyButtonTouched:(id)sender;

@property NSString *name;
@property NSString *email;
@property NSString *username;
@property NSString *password;
@property int weight;
@property int age;
@property int inchesHeight;
@property int gender;
@property int neat;

- (IBAction)startOverButtonTouched:(id)sender;

@end
