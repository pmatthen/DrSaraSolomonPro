//
//  ParseSignUpViewControllerStep5.m
//  MyProfile
//
//  Created by Vanaja Matthen on 16/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ParseSignUpViewControllerStep6.h"
#import "ParseSignUpViewControllerStep7.h"
#import "ILTranslucentView.h"

@interface ParseSignUpViewControllerStep6 () <UIPickerViewDelegate, UIPickerViewDataSource> {
    ILTranslucentView *translucentView;
    UIButton *closePopUpViewButton;
    UIColor *myFontColor;
    BOOL is35;
}

@end

@implementation ParseSignUpViewControllerStep6
@synthesize myPickerView, neatArray;

- (void)viewDidLoad
{
    myFontColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    neatArray = [NSArray new];
    neatArray = @[@"sedentary", @"lightly active", @"moderately active", @"very active", @"extremely active"];
    
    UILabel *stepsCountLabelA = [[UILabel alloc] initWithFrame:CGRectMake(89, 56, 140, 35)];
    stepsCountLabelA.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelA.textColor = myFontColor;
    stepsCountLabelA.text = @"Last Step to a ";
    [stepsCountLabelA sizeToFit];
    
    UILabel *stepsCountLabelB = [[UILabel alloc] initWithFrame:CGRectMake(174, 50, 40, 35)];
    stepsCountLabelB.font = [UIFont fontWithName:@"Norican-Regular" size:25];
    stepsCountLabelB.textColor = myFontColor;
    stepsCountLabelB.text = @"sexier";
    [stepsCountLabelB sizeToFit];
    
    UILabel *stepsCountLabelC = [[UILabel alloc] initWithFrame:CGRectMake(224, 56, 30, 35)];
    stepsCountLabelC.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    stepsCountLabelC.textColor = myFontColor;
    stepsCountLabelC.text = @" you.";
    [stepsCountLabelC sizeToFit];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = myFontColor;
    stepLabel.text = @"Step 6";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(134, 163, 60, 40)];
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = myFontColor;
    instructionsLabel.text = @"ENTER FITNESS LEVEL";
    [instructionsLabel sizeToFit];
    
    if (is35) {
        stepsCountLabelA.frame = CGRectMake(89, 47, 140, 30);
        [stepsCountLabelA sizeToFit];
        stepsCountLabelB.frame = CGRectMake(174, 42, 40, 30);
        [stepsCountLabelB sizeToFit];
        stepsCountLabelC.frame = CGRectMake(224, 47, 30, 30);
        [stepsCountLabelC sizeToFit];
        stepLabel.frame = CGRectMake(55, 126, 60, 34);
        [stepLabel sizeToFit];
        instructionsLabel.frame = CGRectMake(134, 138, 60, 34);
        [instructionsLabel sizeToFit];
    }
    
    [self.view addSubview:stepsCountLabelA];
    [self.view addSubview:stepsCountLabelB];
    [self.view addSubview:stepsCountLabelC];
    [self.view addSubview:stepLabel];
    [self.view addSubview:instructionsLabel];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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

- (IBAction)startOverButtonTouched:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)continueButtonTouched:(id)sender {
}

- (IBAction)popUpButtonTouched:(id)sender {
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
    popUpTitleLabel.textColor = myFontColor;
    popUpTitleLabel.text = @"FITNESS LEVELS";
    [popUpTitleLabel sizeToFit];
    
    UILabel *sedentaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 121, 80, 80)];
    sedentaryLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    sedentaryLabel.textColor = myFontColor;
    sedentaryLabel.text = @"Sedentary";
    [sedentaryLabel sizeToFit];
    
    UILabel *sedentaryDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 147, 80, 80)];
    sedentaryDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    sedentaryDescriptionLabel.textColor = myFontColor;
    sedentaryDescriptionLabel.text = @"little or no exercise";
    [sedentaryDescriptionLabel sizeToFit];
    
    UIImageView *sedentaryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beginner_icon@2x.png"]];
    sedentaryImageView.frame = CGRectMake(62, 129, 52, 52);
    
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(67, 190, 194 , 2)];
    separatorView1.backgroundColor = myFontColor;
    
    UILabel *lightlyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 211, 80, 80)];
    lightlyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    lightlyActiveLabel.textColor = myFontColor;
    lightlyActiveLabel.text = @"Lightly Active";
    [lightlyActiveLabel sizeToFit];
    
    UILabel *lightlyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 237, 80, 80)];
    lightlyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    lightlyActiveDescriptionLabel.textColor = myFontColor;
    lightlyActiveDescriptionLabel.text = @"easy exercise/sports 1-3 days/week";
    [lightlyActiveDescriptionLabel sizeToFit];
    
    UIImageView *lightlyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"advanced_icon@2x.png"]];
    lightlyActiveImageView.frame = CGRectMake(62, 209, 55, 49);
    
    UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(67, 280, 194 , 2)];
    separatorView2.backgroundColor = myFontColor;
    
    UILabel *moderatelyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 299, 80, 80)];
    moderatelyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    moderatelyActiveLabel.textColor = myFontColor;
    moderatelyActiveLabel.text = @"Moderately Active";
    [moderatelyActiveLabel sizeToFit];
    
    UILabel *moderatelyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 325, 80, 80)];
    moderatelyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    moderatelyActiveDescriptionLabel.textColor = myFontColor;
    moderatelyActiveDescriptionLabel.text = @"moderate exercise/sports 3-5 days/week";
    [moderatelyActiveDescriptionLabel sizeToFit];
    
    UIImageView *moderatelyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hardcore_icon@2x.png"]];
    moderatelyActiveImageView.frame = CGRectMake(62, 297, 50, 52);
    
    UIView *separatorView3 = [[UIView alloc] initWithFrame:CGRectMake(67, 368, 194 , 2)];
    separatorView3.backgroundColor = myFontColor;
    
    UILabel *veryActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 387, 80, 80)];
    veryActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    veryActiveLabel.textColor = myFontColor;
    veryActiveLabel.text = @"Very Active";
    [veryActiveLabel sizeToFit];
    
    UILabel *veryActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 413, 80, 80)];
    veryActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    veryActiveDescriptionLabel.textColor = myFontColor;
    veryActiveDescriptionLabel.text = @"hard exercise/sports 6-7 days/week";
    [veryActiveDescriptionLabel sizeToFit];
    
    UIImageView *veryActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fourthlevel_icon@2x.png"]];
    veryActiveImageView.frame = CGRectMake(62, 385, 50, 52);
    
    UIView *separatorView4 = [[UIView alloc] initWithFrame:CGRectMake(67, 456, 194 , 2)];
    separatorView4.backgroundColor = myFontColor;
    
    UILabel *extremelyActiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 475, 80, 80)];
    extremelyActiveLabel.font = [UIFont fontWithName:@"Norican-Regular" size:20];
    extremelyActiveLabel.textColor = myFontColor;
    extremelyActiveLabel.text = @"Extremely Active";
    [extremelyActiveLabel sizeToFit];
    
    UILabel *extremelyActiveDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 501, 80, 80)];
    extremelyActiveDescriptionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:11];
    extremelyActiveDescriptionLabel.textColor = myFontColor;
    extremelyActiveDescriptionLabel.text = @"very hard exercise/sports and physical job";
    [extremelyActiveDescriptionLabel sizeToFit];
    
    UIImageView *extremelyActiveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fifthlevel_icon@2x.png"]];
    extremelyActiveImageView.frame = CGRectMake(62, 474, 50, 52);
    
    if (is35) {
        translucentView.frame = CGRectMake(0, 0, 320, 480);
        closePopUpViewButton.frame = CGRectMake(15, 15, 39, 32);
        popUpTitleLabel.frame = CGRectMake(80, 41, 150, 68);
        [popUpTitleLabel sizeToFit];
        sedentaryLabel.frame = CGRectMake(127, 102, 80, 68);
        [sedentaryLabel sizeToFit];
        sedentaryDescriptionLabel.frame = CGRectMake(127, 124, 80, 68);
        [sedentaryDescriptionLabel sizeToFit];
        sedentaryImageView.frame = CGRectMake(62, 109, 52, 44);
        separatorView1.frame = CGRectMake(67, 161, 194 , 2);
        lightlyActiveLabel.frame = CGRectMake(127, 178, 80, 68);
        [lightlyActiveLabel sizeToFit];
        lightlyActiveDescriptionLabel.frame = CGRectMake(127, 200, 80, 68);
        [lightlyActiveDescriptionLabel sizeToFit];
        lightlyActiveImageView.frame = CGRectMake(62, 177, 55, 41);
        separatorView2.frame = CGRectMake(67, 237, 194 , 2);
        moderatelyActiveLabel.frame = CGRectMake(127, 253, 80, 68);
        [moderatelyActiveLabel sizeToFit];
        moderatelyActiveDescriptionLabel.frame = CGRectMake(127, 275, 80, 68);
        [moderatelyActiveDescriptionLabel sizeToFit];
        moderatelyActiveImageView.frame = CGRectMake(62, 251, 50, 44);
        separatorView3.frame = CGRectMake(67, 311, 194 , 2);
        veryActiveLabel.frame = CGRectMake(127, 327, 80, 68);
        [veryActiveLabel sizeToFit];
        veryActiveDescriptionLabel.frame = CGRectMake(127, 349, 80, 68);
        [veryActiveDescriptionLabel sizeToFit];
        veryActiveImageView.frame = CGRectMake(62, 325, 50, 44);
        separatorView4.frame = CGRectMake(67, 385, 194 , 2);
        extremelyActiveLabel.frame = CGRectMake(127, 401, 80, 68);
        [extremelyActiveLabel sizeToFit];
        extremelyActiveDescriptionLabel.frame = CGRectMake(127, 423, 80, 68);
        [extremelyActiveDescriptionLabel sizeToFit];
        extremelyActiveImageView.frame = CGRectMake(62, 401, 50, 44);
    }
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ParseSignUpViewControllerStep7 *nextStepController = (ParseSignUpViewControllerStep7 *) segue.destinationViewController;
    
    nextStepController.name = self.name;
    nextStepController.email = self.email;
    nextStepController.username = self.username;
    nextStepController.password = self.password;
    nextStepController.weight = self.weight;
    nextStepController.age = self.age;
    nextStepController.inchesHeight = self.inchesHeight;
    nextStepController.gender = self.gender;
    nextStepController.neat = (int)[myPickerView selectedRowInComponent:0];
}

@end
