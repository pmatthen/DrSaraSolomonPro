//
//  ParseSignUpViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 15/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ParseSignUpViewControllerStep4.h"
#import "ParseSignUpViewControllerStep5.h"

@interface ParseSignUpViewControllerStep4 () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation ParseSignUpViewControllerStep4
@synthesize myPickerView, feetHeightArray, inchesHeightArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *myFontColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    
    feetHeightArray = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        [feetHeightArray addObject:[NSNumber numberWithInt:i]];
    }
    
    inchesHeightArray = [NSMutableArray new];
    for (int i = 0; i < 12; i++) {
        [inchesHeightArray addObject:[NSNumber numberWithInt:i]];
    }
    
    [myPickerView selectRow:5 inComponent:0 animated:NO];
    [myPickerView selectRow:5 inComponent:1 animated:NO];
    
    UILabel *stepsCountLabelA = [[UILabel alloc] initWithFrame:CGRectMake(60, 56, 140, 35)];
    stepsCountLabelA.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelA.textColor = myFontColor;
    stepsCountLabelA.text = @"Just 2 more steps to a ";
    [stepsCountLabelA sizeToFit];
    
    UILabel *stepsCountLabelB = [[UILabel alloc] initWithFrame:CGRectMake(193, 50, 40, 35)];
    stepsCountLabelB.font = [UIFont fontWithName:@"Norican-Regular" size:25];
    stepsCountLabelB.textColor = myFontColor;
    stepsCountLabelB.text = @"sexier";
    [stepsCountLabelB sizeToFit];
    
    UILabel *stepsCountLabelC = [[UILabel alloc] initWithFrame:CGRectMake(243, 56, 30, 35)];
    stepsCountLabelC.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelC.textColor = myFontColor;
    stepsCountLabelC.text = @" you.";
    [stepsCountLabelC sizeToFit];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = myFontColor;
    stepLabel.text = @"Step 4";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = myFontColor;
    instructionsLabel.text = @"ENTER HEIGHT";
    [instructionsLabel sizeToFit];
    
    UILabel *ftLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 350, 60, 40)];
    ftLabel.font = [UIFont fontWithName:@"Oswald-Light" size:30];
    ftLabel.textColor = myFontColor;
    ftLabel.text = @"ft";
    [ftLabel sizeToFit];
    
    UILabel *inLabel = [[UILabel alloc] initWithFrame:CGRectMake(273, 350, 60, 40)];
    inLabel.font = [UIFont fontWithName:@"Oswald-Light" size:30];
    inLabel.textColor = myFontColor;
    inLabel.text = @"in";
    [inLabel sizeToFit];
    
    [self.view addSubview:stepsCountLabelA];
    [self.view addSubview:stepsCountLabelB];
    [self.view addSubview:stepsCountLabelC];
    [self.view addSubview:stepLabel];
    [self.view addSubview:instructionsLabel];
    [self.view addSubview:ftLabel];
    [self.view addSubview:inLabel];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [feetHeightArray count];
    } else {
        return [inchesHeightArray count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@", [[feetHeightArray objectAtIndex:row] description]];
    } else {
        return [NSString stringWithFormat:@"%@", [[inchesHeightArray objectAtIndex:row] description]];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 100;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    
    if (component == 0) {
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Oswald" size:110];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"  %@", feetHeightArray[row]];
    } else {
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Oswald" size:110];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@" %@", inchesHeightArray[row]];
    }
    
    return label;
}

- (IBAction)startOverButtonTouched:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)continueButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"NextStepSegue" sender:self];    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ParseSignUpViewControllerStep5 *nextStepController = (ParseSignUpViewControllerStep5 *) segue.destinationViewController;
    
    nextStepController.name = self.name;
    nextStepController.email = self.email;
    nextStepController.username = self.username;
    nextStepController.password = self.password;
    nextStepController.weight = self.weight;
    nextStepController.age = self.age;
    nextStepController.inchesHeight = (int)(([myPickerView selectedRowInComponent:0] * 12) + [myPickerView selectedRowInComponent:1]);
}

@end
