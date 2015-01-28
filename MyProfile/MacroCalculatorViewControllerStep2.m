//
//  MacroCalculatorViewControllerStep2.m
//  MyProfile
//
//  Created by Apple on 20/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MacroCalculatorViewControllerStep2.h"
#import "MacroCalculatorViewControllerStep3.h"

@interface MacroCalculatorViewControllerStep2 () <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSArray *resultsArray;

@end

@implementation MacroCalculatorViewControllerStep2
@synthesize resultsArray, myPickerView, neat, bodyfatPercentage, date;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MACRO CALCULATOR";
    
    [self.view addSubview:titleLabel];
    
    resultsArray = [NSArray new];
    resultsArray = @[@"TDEE (Maintenance level of calories)", @"20% of TDEE (for ADF)", @"25% of TDEE (for ADF)", @"30% of TDEE (for ADF)", @"35% of TDEE (for ADF)", @"40% of TDEE (for ADF)", @"45% of TDEE (for ADF)", @"50% of TDEE (for ADF)", @"TDEE -10% (Fat Loss for Daily Fasting)", @"TDEE -15% (Fat Loss for Daily Fasting)"];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 2";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"ENTER RESULTS FORMAT";
    [instructionsLabel sizeToFit];
    
    [self.view addSubview:stepLabel];
    [self.view addSubview:instructionsLabel];
    
    [myPickerView selectRow:3 inComponent:0 animated:NO];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [resultsArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return resultsArray[row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = resultsArray[row];
    
    return label;
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"nextStepSegue" sender:self];
    NSLog(@"touched!!");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MacroCalculatorViewControllerStep3 *myMacroCalculatorViewControllerStep3 = (MacroCalculatorViewControllerStep3 *) segue.destinationViewController;
    myMacroCalculatorViewControllerStep3.neat = neat;
    myMacroCalculatorViewControllerStep3.bodyfatPercentage = bodyfatPercentage;
    myMacroCalculatorViewControllerStep3.results = [myPickerView selectedRowInComponent:0];
    myMacroCalculatorViewControllerStep3.date = date;
}

@end
