//
//  MacroCalculatorViewControllerStep3.m
//  MyProfile
//
//  Created by Apple on 20/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MacroCalculatorViewControllerStep3.h"
#import "MacroCalculatorViewControllerStep4.h"

@interface MacroCalculatorViewControllerStep3 () <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSArray *proteinArray;

@end

@implementation MacroCalculatorViewControllerStep3
@synthesize myPickerView, proteinArray, neat, bodyfatPercentage, results, date;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MACRO CALCULATOR";
    
    [self.view addSubview:titleLabel];
    
    proteinArray = [NSArray new];
    proteinArray = @[@1, @1.1, @1.2, @1.3, @1.4];

    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 3";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"ENTER PROTEIN CALCULATION";
    [instructionsLabel sizeToFit];
    
    [self.view addSubview:stepLabel];
    [self.view addSubview:instructionsLabel];
    
    [myPickerView selectRow:2 inComponent:0 animated:NO];
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
    return [proteinArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [proteinArray[row] description];
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
    label.text = [proteinArray[row] description];
    
    return label;
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"nextStepSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MacroCalculatorViewControllerStep4 *myMacroCalculatorViewControllerStep4 = (MacroCalculatorViewControllerStep4 *) segue.destinationViewController;
    myMacroCalculatorViewControllerStep4.neat = neat;
    myMacroCalculatorViewControllerStep4.bodyfatPercentage = bodyfatPercentage;
    myMacroCalculatorViewControllerStep4.results = results;
    myMacroCalculatorViewControllerStep4.proteinCalculations = [myPickerView selectedRowInComponent:0];
    myMacroCalculatorViewControllerStep4.date = date;
}

@end
