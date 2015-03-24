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
{
    BOOL is35;
}

@end

@implementation AddFoodViewController
@synthesize searchTextField, trackerDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"DAILY TRACKER";
    
    UILabel *instructionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(97, 97, 100, 100)];
    if (is35) {
        instructionTitleLabel.frame = CGRectMake(97, 82, 100, 85);
    }
    instructionTitleLabel.font = [UIFont fontWithName:@"Oswald" size:29];
    instructionTitleLabel.textColor = [UIColor whiteColor];
    instructionTitleLabel.text = @"ADD FOOD";
    [instructionTitleLabel sizeToFit];
    instructionTitleLabel.frame = CGRectMake((320 - instructionTitleLabel.frame.size.width)/2, instructionTitleLabel.frame.origin.y, instructionTitleLabel.frame.size.width, instructionTitleLabel.frame.size.height);
    
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 148, 200, 100)];
    if (is35) {
        instructionLabel.frame = CGRectMake(100, 125, 200, 85);
    }
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
    if ([segue.identifier isEqualToString:@"AddFoodSegue"]) {
        AddFoodViewControllerStep2 *addFoodViewControllerStep2 = (AddFoodViewControllerStep2 *) segue.destinationViewController;
        addFoodViewControllerStep2.searchText = searchTextField.text;
        addFoodViewControllerStep2.trackerDate = trackerDate;
    }
}

- (IBAction)searchButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddFoodSegue" sender:self];
}

- (IBAction)scanBarcodeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"BarcodeSegue" sender:self];
}

@end
