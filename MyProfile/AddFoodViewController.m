//
//  AddFoodViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 29/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "AddFoodViewController.h"
#import "AddFoodViewControllerStep2.h"

@interface AddFoodViewController () <UITextFieldDelegate>

@end

@implementation AddFoodViewController
@synthesize searchTextField, trackerDate;

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"DAILY TRACKER";
    
    UILabel *instructionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(97, 97, 100, 100)];
    instructionTitleLabel.font = [UIFont fontWithName:@"Oswald" size:29];
    instructionTitleLabel.textColor = [UIColor whiteColor];
    instructionTitleLabel.text = @"ADD FOOD";
    [instructionTitleLabel sizeToFit];
    instructionTitleLabel.frame = CGRectMake((320 - instructionTitleLabel.frame.size.width)/2, instructionTitleLabel.frame.origin.y, instructionTitleLabel.frame.size.width, instructionTitleLabel.frame.size.height);
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 148, 200, 100)];
    instructionLabel.numberOfLines = 0;
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    instructionLabel.textColor = [UIColor whiteColor];
    instructionLabel.text = @"Search for a food within the app or choose from an option below.";
    [instructionLabel sizeToFit];
    instructionLabel.frame = CGRectMake((320 - instructionLabel.frame.size.width)/2, instructionLabel.frame.origin.y, instructionLabel.frame.size.width, instructionLabel.frame.size.height);
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:instructionTitleLabel];
    [self.view addSubview:instructionLabel];
    
    [searchTextField setBackgroundColor:[UIColor clearColor]];
    searchTextField.font = [UIFont fontWithName:@"Oswald" size:23];
    searchTextField.textColor = [UIColor whiteColor];
    
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Oswald" size:23]}];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchButtonPressed:self];
    
    return YES;
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddFoodViewControllerStep2 *addFoodViewControllerStep2 = (AddFoodViewControllerStep2 *) segue.destinationViewController;
    addFoodViewControllerStep2.searchText = searchTextField.text;
    addFoodViewControllerStep2.trackerDate = trackerDate;
}

- (IBAction)searchButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddFoodSegue" sender:self];
}

@end
