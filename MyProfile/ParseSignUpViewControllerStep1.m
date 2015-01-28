//
//  ParseSignUpViewControllerStep1.m
//  MyProfile
//
//  Created by Vanaja Matthen on 16/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ParseSignUpViewControllerStep1.h"
#import "ParseSignUpViewControllerStep2.h"

#define kOFFSET_FOR_KEYBOARD 216.0

@interface ParseSignUpViewControllerStep1 () <UITextFieldDelegate>

@end

@implementation ParseSignUpViewControllerStep1
@synthesize nameTextField, emailTextField, usernameTextField, passwordTextField, confirmPasswordTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UILabel *stepsCountLabelA = [[UILabel alloc] initWithFrame:CGRectMake(60, 56, 140, 35)];
    stepsCountLabelA.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelA.textColor = [UIColor whiteColor];
    stepsCountLabelA.text = @"Just 5 more steps to a ";
    [stepsCountLabelA sizeToFit];
    
    UILabel *stepsCountLabelB = [[UILabel alloc] initWithFrame:CGRectMake(193, 50, 40, 35)];
    stepsCountLabelB.font = [UIFont fontWithName:@"Norican-Regular" size:25];
    stepsCountLabelB.textColor = [UIColor whiteColor];
    stepsCountLabelB.text = @"sexier";
    [stepsCountLabelB sizeToFit];
    
    UILabel *stepsCountLabelC = [[UILabel alloc] initWithFrame:CGRectMake(243, 56, 30, 35)];
    stepsCountLabelC.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelC.textColor = [UIColor whiteColor];
    stepsCountLabelC.text = @" you.";
    [stepsCountLabelC sizeToFit];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 1";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(128, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"CREATE AN ACCOUNT";
    [instructionsLabel sizeToFit];

    [self.view addSubview:stepsCountLabelA];
    [self.view addSubview:stepsCountLabelB];
    [self.view addSubview:stepsCountLabelC];
    [self.view addSubview:stepLabel];
    [self.view addSubview:instructionsLabel];
    
    [nameTextField setBackgroundColor:[UIColor clearColor]];
    nameTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    nameTextField.textColor = [UIColor whiteColor];
    
    [emailTextField setBackgroundColor:[UIColor clearColor]];
    emailTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    emailTextField.textColor = [UIColor whiteColor];
    
    [usernameTextField setBackgroundColor:[UIColor clearColor]];
    usernameTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    usernameTextField.textColor = [UIColor whiteColor];
    
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.secureTextEntry = YES;

    [confirmPasswordTextField setBackgroundColor:[UIColor clearColor]];
    confirmPasswordTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    confirmPasswordTextField.textColor = [UIColor whiteColor];
    confirmPasswordTextField.secureTextEntry = YES;
    
    nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];
    
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];
    
    usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];

    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];
    
    confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"confirm password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    nameTextField.text = @"";
    emailTextField.text = @"";
    usernameTextField.text = @"";
    passwordTextField.text = @"";
    confirmPasswordTextField.text = @"";

    [confirmPasswordTextField resignFirstResponder];
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
    [self continueButtonTouched:self];
    
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

- (IBAction)continueButtonTouched:(id)sender {
    if ((![nameTextField.text  isEqual: @""]) && (![emailTextField.text  isEqual: @""]) && (![usernameTextField.text  isEqual: @""]) && (![passwordTextField.text  isEqual: @""]) && (![confirmPasswordTextField.text  isEqual: @""])) {
        if ([passwordTextField.text isEqual:confirmPasswordTextField.text]) {
            [self performSegueWithIdentifier:@"NextStepSegue" sender:self];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password" message:@"Password and Confirm Password fields do not match" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            passwordTextField.text = @"";
            confirmPasswordTextField.text = @"";
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill out all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ParseSignUpViewControllerStep2 *nextStepController = (ParseSignUpViewControllerStep2 *) segue.destinationViewController;
    
    nextStepController.name = nameTextField.text;
    nextStepController.email = emailTextField.text;
    nextStepController.username = usernameTextField.text;
    nextStepController.password = passwordTextField.text;
}

@end
