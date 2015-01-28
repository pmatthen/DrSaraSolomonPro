//
//  ParseSignUpViewControllerStep6.m
//  MyProfile
//
//  Created by Poulose Matthen on 30/07/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ParseSignUpViewControllerStep7.h"
#import "MenuViewController.h"

@interface ParseSignUpViewControllerStep7 ()

@end

@implementation ParseSignUpViewControllerStep7
@synthesize inchesHeight, weight, age, gender, neat, username, password, name, email;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *congratsLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, 190, 150, 150)];
    congratsLabel.font = [UIFont fontWithName:@"Norican-Regular" size:37];
    congratsLabel.textColor = [UIColor whiteColor];
    congratsLabel.text = @"Congratulations!";
    [congratsLabel sizeToFit];
    
    UILabel *getReadyLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 143, 250, 300)];
    getReadyLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    getReadyLabel.textColor = [UIColor whiteColor];
    getReadyLabel.textAlignment = NSTextAlignmentCenter;
    getReadyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    getReadyLabel.numberOfLines = 0;
    getReadyLabel.text = @"You are now a member of the Sara Solomon Intermittent Fasting and Calorie Tracking app! Get ready to look and feel sexier than you ever have before!";
    
    [self.view addSubview:congratsLabel];
    [self.view addSubview:getReadyLabel];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)startGettingSexyButtonTouched:(id)sender {
    PFUser *user = [PFUser user];
    
    user.username = username;
    user.password = password;
    user.email = email;
    user[@"name"] = name;
    user[@"height"] = [NSNumber numberWithInt:inchesHeight];
    user[@"weight"] = [NSNumber numberWithInt:weight];
    user[@"age"] = [NSNumber numberWithInt:age];
    user[@"gender"] = [NSNumber numberWithInt:gender];
    user[@"neat"] = [NSNumber numberWithInt:neat];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (!error) {
                if (user) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                    MenuViewController *myMenuViewController = [MenuViewController new];
                    myMenuViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewNavigationController"];
                    [self presentViewController:myMenuViewController animated:NO completion:nil];
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            } else {
                NSString *errorString = [error userInfo][@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }];
}

- (IBAction)startOverButtonTouched:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
@end
