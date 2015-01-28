//
//  MacroCalculatorViewControllerStep1.h
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MacroCalculatorViewControllerStep1 : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *bodyFatTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property NSDate *date;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)continueButtonTouched:(id)sender;
- (IBAction)popupButtonTouched:(id)sender;

@end
