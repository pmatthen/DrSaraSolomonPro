//
//  MacroCalculatorViewControllerStep2.h
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MacroCalculatorViewControllerStep4 : UIViewController

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property int neat;
@property int bodyfatPercentage;
@property int results;
@property float proteinCalculations;
@property NSDate *date;

- (IBAction)calculateMacroButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
