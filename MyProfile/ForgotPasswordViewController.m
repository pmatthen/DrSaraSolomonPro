//
//  ForgotPasswordViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 17/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize emailTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)resetPasswordButtonPressed:(id)sender {
    if ([emailTextField.text length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter an email address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        [PFUser requestPasswordResetForEmailInBackground:emailTextField.text];
        emailTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset Mail Sent" message:@"An email with instructions on how to reset your password has been sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
