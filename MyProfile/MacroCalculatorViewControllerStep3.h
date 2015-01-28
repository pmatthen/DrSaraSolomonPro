//
//  MacroCalculatorViewControllerStep3.h
//  MyProfile
//
//  Created by Apple on 20/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MacroCalculatorViewControllerStep3 : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

@property int neat;
@property int bodyfatPercentage;
@property int results;
@property NSDate *date;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;

@end
