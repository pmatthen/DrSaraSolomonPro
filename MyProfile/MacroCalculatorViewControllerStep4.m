//
//  MacroCalculatorViewControllerStep2.m
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MacroCalculatorViewControllerStep4.h"
#import "MacroCalculatorDetails.h"
#import "CoreDataStack.h"

@interface MacroCalculatorViewControllerStep4 ()

@property NSArray *fatsArray;
@property CoreDataStack *coreDataStack;

@end

@implementation MacroCalculatorViewControllerStep4
@synthesize myPickerView, fatsArray, neat, bodyfatPercentage, results, proteinCalculations, coreDataStack, date;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    coreDataStack = [CoreDataStack defaultStack];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MACRO CALCULATOR";
    
    [self.view addSubview:titleLabel];
    
    fatsArray = [NSArray new];
    fatsArray = @[@15, @20, @25, @30, @35, @40];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 4";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"ENTER FAT CALCULATION";
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
    return [fatsArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@%%", [fatsArray[row] description]];
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
    label.text = [NSString stringWithFormat:@"%@%%", [fatsArray[row] description]];
    
    return label;
}

- (IBAction)calculateMacroButtonTouched:(id)sender {
    MacroCalculatorDetails *details = [NSEntityDescription insertNewObjectForEntityForName:@"MacroCalculatorDetails" inManagedObjectContext:coreDataStack.managedObjectContext];
    details.activityLevel = [NSNumber numberWithInt:neat];
    details.bodyfat = [NSNumber numberWithInt:bodyfatPercentage];
    details.results = [NSNumber numberWithInt:results];
    details.proteinCalculation = [NSNumber numberWithFloat:proteinCalculations];
    details.fats = [NSNumber numberWithInt:(int) [myPickerView selectedRowInComponent:0]];
    details.date = date;
    
    [coreDataStack saveContext];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
