//
//  NewsletterViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 01/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsletterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UISwitch *iFSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *recipeSwitch;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)joinButtonTouched:(id)sender;

@end
