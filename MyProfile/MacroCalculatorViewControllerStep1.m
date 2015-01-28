//
//  MacroCalculatorViewControllerStep1.m
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MacroCalculatorViewControllerStep1.h"
#import "MacroCalculatorViewControllerStep2.h"
#import "ILTranslucentView.h"

#define kOFFSET_FOR_KEYBOARD 216.0

@interface MacroCalculatorViewControllerStep1 () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property NSArray *neatArray;
@property ILTranslucentView *translucentView;
@property UIButton *closePopUpViewButton;

@end

@implementation MacroCalculatorViewControllerStep1
@synthesize neatArray, bodyFatTextField, myPickerView, translucentView, closePopUpViewButton, date;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MACRO CALCULATOR";
    
    [self.view addSubview:titleLabel];
    
    neatArray = [NSArray new];
    neatArray = @[@"sedentary", @"lightly active", @"moderately active", @"very active", @"extremely active"];
    
    [bodyFatTextField setBackgroundColor:[UIColor clearColor]];
    bodyFatTextField.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    bodyFatTextField.textColor = [UIColor whiteColor];
    bodyFatTextField.textAlignment = NSTextAlignmentCenter;
    bodyFatTextField.keyboardType = UIKeyboardTypeNumberPad;
    bodyFatTextField.delegate = self;
    bodyFatTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"bodyfat % (optional)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:16]}];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 1";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"ENTER FITNESS LEVEL";
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [neatArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return neatArray[row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:40];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = neatArray[row];
    
    return label;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 2) ? NO : YES;
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"nextStepSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MacroCalculatorViewControllerStep2 *myMacroCalculatorViewControllerStep2 = (MacroCalculatorViewControllerStep2 *) segue.destinationViewController;
    myMacroCalculatorViewControllerStep2.neat = (int) [myPickerView selectedRowInComponent:0];
    myMacroCalculatorViewControllerStep2.bodyfatPercentage = [bodyFatTextField.text integerValue];
    myMacroCalculatorViewControllerStep2.date = date;
}

- (IBAction)popupButtonTouched:(id)sender {
    translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    translucentView.translucentAlpha = 1;
    translucentView.translucentStyle = UIBarStyleBlack;
    translucentView.translucentTintColor = [UIColor clearColor];
    translucentView.backgroundColor = [UIColor clearColor];
    
    closePopUpViewButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, 39, 38)];
    [closePopUpViewButton setImage:[UIImage imageNamed:@"x_icon@2x.png"] forState:UIControlStateNormal];
    [closePopUpViewButton addTarget:self action:@selector(closePopUpViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *popUpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 48, 150, 80)];
    popUpTitleLabel.font = [UIFont fontWithName:@"Oswald" size:26];
    popUpTitleLabel.textColor = [UIColor whiteColor];
    popUpTitleLabel.text = @"FITNESS LEVELS";
    [popUpTitleLabel sizeToFit];
    
    UILabel *sedentaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 121, 80, 80)];
    sedentaryLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    sedentaryLabel.textColor = [UIColor whiteColor];
    sedentaryLabel.text = @"Sedentary";
    [sedentaryLabel sizeToFit];
    
    UILabel *sedentaryDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 147, 80, 80)];
    sedentaryDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    sedentaryDescriptionLabel.textColor = [UIColor whiteColor];
    sedentaryDescriptionLabel.text = @"little or no exercise";
    [sedentaryDescriptionLabel sizeToFit];
    
    UIImageView *sedentaryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beginner_icon@2x.png"]];
    sedentaryImageView.frame = CGRectMake(62, 129, 52, 52);
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(67, 190, 194 , 2)];
    separatorView1.backgroundColor = [UIColor whiteColor];
    
    UILabel *lightlyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 211, 80, 80)];
    lightlyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    lightlyActiveLabel.textColor = [UIColor whiteColor];
    lightlyActiveLabel.text = @"Lightly Active";
    [lightlyActiveLabel sizeToFit];
    
    UILabel *lightlyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 237, 80, 80)];
    lightlyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    lightlyActiveDescriptionLabel.textColor = [UIColor whiteColor];
    lightlyActiveDescriptionLabel.text = @"easy exercise/sports 1-3 days/week";
    [lightlyActiveDescriptionLabel sizeToFit];
    
    UIImageView *lightlyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advanced_icon@2x.png"]];
    lightlyActiveImageView.frame = CGRectMake(62, 209, 55, 49);
    
    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(67, 280, 194 , 2)];
    separatorView2.backgroundColor = [UIColor whiteColor];
    
    UILabel *moderatelyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 299, 80, 80)];
    moderatelyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    moderatelyActiveLabel.textColor = [UIColor whiteColor];
    moderatelyActiveLabel.text = @"Moderately Active";
    [moderatelyActiveLabel sizeToFit];
    
    UILabel *moderatelyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 325, 80, 80)];
    moderatelyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    moderatelyActiveDescriptionLabel.textColor = [UIColor whiteColor];
    moderatelyActiveDescriptionLabel.text = @"moderate exercise/sports 3-5 days/week";
    [moderatelyActiveDescriptionLabel sizeToFit];
    
    UIImageView *moderatelyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hardcore_icon@2x.png"]];
    moderatelyActiveImageView.frame = CGRectMake(62, 297, 50, 52);
    
    UIView *separatorView3 = [[UIView alloc] initWithFrame:CGRectMake(67, 368, 194 , 2)];
    separatorView3.backgroundColor = [UIColor whiteColor];
    
    UILabel *veryActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 387, 80, 80)];
    veryActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    veryActiveLabel.textColor = [UIColor whiteColor];
    veryActiveLabel.text = @"Very Active";
    [veryActiveLabel sizeToFit];
    
    UILabel *veryActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 413, 80, 80)];
    veryActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    veryActiveDescriptionLabel.textColor = [UIColor whiteColor];
    veryActiveDescriptionLabel.text = @"hard exercise/sports 6-7 days/week";
    [veryActiveDescriptionLabel sizeToFit];
    
    UIImageView *veryActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fourthlevel_icon@2x.png"]];
    veryActiveImageView.frame = CGRectMake(62, 385, 50, 52);
    
    UIView *separatorView4 = [[UIView alloc] initWithFrame:CGRectMake(67, 456, 194 , 2)];
    separatorView4.backgroundColor = [UIColor whiteColor];
    
    UILabel *extremelyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 475, 80, 80)];
    extremelyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    extremelyActiveLabel.textColor = [UIColor whiteColor];
    extremelyActiveLabel.text = @"Extremely Active";
    [extremelyActiveLabel sizeToFit];
    
    UILabel *extremelyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 501, 80, 80)];
    extremelyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    extremelyActiveDescriptionLabel.textColor = [UIColor whiteColor];
    extremelyActiveDescriptionLabel.text = @"very hard exercise/sports and physical job";
    [extremelyActiveDescriptionLabel sizeToFit];
    
    UIImageView *extremelyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fifthlevel_icon@2x.png"]];
    extremelyActiveImageView.frame = CGRectMake(62, 474, 50, 52);
    
    [self.view addSubview:translucentView];
    [translucentView addSubview:closePopUpViewButton];
    [translucentView addSubview:popUpTitleLabel];
    [translucentView addSubview:sedentaryLabel];
    [translucentView addSubview:sedentaryDescriptionLabel];
    [translucentView addSubview:sedentaryImageView];
    [translucentView addSubview:separatorView1];
    [translucentView addSubview:lightlyActiveLabel];
    [translucentView addSubview:lightlyActiveDescriptionLabel];
    [translucentView addSubview:lightlyActiveImageView];
    [translucentView addSubview:separatorView2];
    [translucentView addSubview:moderatelyActiveLabel];
    [translucentView addSubview:moderatelyActiveDescriptionLabel];
    [translucentView addSubview:moderatelyActiveImageView];
    [translucentView addSubview:separatorView3];
    [translucentView addSubview:veryActiveLabel];
    [translucentView addSubview:veryActiveDescriptionLabel];
    [translucentView addSubview:veryActiveImageView];
    [translucentView addSubview:separatorView4];
    [translucentView addSubview:extremelyActiveLabel];
    [translucentView addSubview:extremelyActiveDescriptionLabel];
    [translucentView addSubview:extremelyActiveImageView];
}

-(void) closePopUpViewButtonPressed:(UIButton *)sender {
    [translucentView removeFromSuperview];
}

@end
