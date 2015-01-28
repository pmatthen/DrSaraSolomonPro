//
//  ParseLogInViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 15/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ParseLogInViewController.h"
#import "MenuViewController.h"

#define kOFFSET_FOR_KEYBOARD 216.0

@interface ParseLogInViewController () <UITextFieldDelegate>

@end

@implementation ParseLogInViewController
@synthesize usernameTextField, passwordTextField, loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UILabel *stepsCountLabelA = [[UILabel alloc] initWithFrame:CGRectMake(86, 64, 140, 35)];
    stepsCountLabelA.font = [UIFont fontWithName:@"Oswald-Light" size:19];
    stepsCountLabelA.textColor = [UIColor whiteColor];
    stepsCountLabelA.text = @"Log in to a ";
    [stepsCountLabelA sizeToFit];
    
    UILabel *stepsCountLabelB = [[UILabel alloc] initWithFrame:CGRectMake(155, 58, 40, 35)];
    stepsCountLabelB.font = [UIFont fontWithName:@"Norican-Regular" size:26];
    stepsCountLabelB.textColor = [UIColor whiteColor];
    stepsCountLabelB.text = @"sexier";
    [stepsCountLabelB sizeToFit];
    
    UILabel *stepsCountLabelC = [[UILabel alloc] initWithFrame:CGRectMake(207, 64, 30, 35)];
    stepsCountLabelC.font = [UIFont fontWithName:@"Oswald-Light" size:19];
    stepsCountLabelC.textColor = [UIColor whiteColor];
    stepsCountLabelC.text = @" you.";
    [stepsCountLabelC sizeToFit];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_avatar@2x.png"]];
    avatarImageView.frame = CGRectMake(64, 138, 192, 203);
    
    UIButton *forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(62, 455, 80, 20)];
    [forgotPasswordButton addTarget:self action:@selector(forgotPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    forgotPasswordButton.titleLabel.font = [UIFont fontWithName:@"Oswald-light" size:11];
    [forgotPasswordButton setTitle:@"forgot password?" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    loginButton.titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:17];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 15, 25, 24)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_small_right@2x.png"];
    [loginButton addSubview:arrowImageView];
    
    [self.view addSubview:stepsCountLabelA];
    [self.view addSubview:stepsCountLabelB];
    [self.view addSubview:stepsCountLabelC];
    [self.view addSubview:avatarImageView];
    [self.view addSubview:forgotPasswordButton];
    
    [usernameTextField setBackgroundColor:[UIColor clearColor]];
    usernameTextField.font = [UIFont fontWithName:@"Oswald-Light" size:17];
    usernameTextField.textColor = [UIColor whiteColor];
    
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.font = [UIFont fontWithName:@"Oswald-Light" size:17];
    passwordTextField.textColor = [UIColor whiteColor];
    
    usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:15]}];
    
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:15]}];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self loginButtonTouched:self];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setViewMovedUp:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setViewMovedUp:NO];
}

-(void)dismissKeyboard {
    for (UITextField *myTextField in self.view.subviews) {
        [myTextField resignFirstResponder];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)loginButtonTouched:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [PFUser logInWithUsernameInBackground:usernameTextField.text password:passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            MenuViewController *myMenuViewController = [MenuViewController new];
            myMenuViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuViewNavigationController"];
            [self presentViewController:myMenuViewController animated:NO completion:nil];
        } else {
            NSLog(@"error = %@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The Username or Password has been entered incorrectly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void) forgotPasswordButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ForgotPasswordSegue" sender:self];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end