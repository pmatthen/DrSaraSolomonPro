//
//  IntermittentFastingViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 11/10/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "IntermittentFastingViewController.h"
#import "IntermittentFastingTableViewCell.h"
#import "CoreDataStack.h"
#import "User.h"
#import "ILTranslucentView.h"
#import "ProtocolTimingViewController.h"

@interface IntermittentFastingViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property BOOL isFirstTime;
@property BOOL isFirstClick;
@property int currentSelection;
@property NSMutableArray *protocolTitleLabels;
@property NSMutableArray *protocolInformationViews;
@property int protocolTitleSelection;
@property BOOL fNotifications;
@property BOOL eNotifications;
@property CoreDataStack *coreDataStack;
@property User *user;
@property ILTranslucentView *translucentView;
@property UIButton *closePopUpViewButton;
@property BOOL is35;

@end

@implementation IntermittentFastingViewController
@synthesize protocolArray, myPickerView, isFirstTime, isFirstClick, currentSelection, protocolTitleLabels, protocolInformationViews, protocolTitleSelection, fNotifications, eNotifications, user, coreDataStack, translucentView, closePopUpViewButton, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    coreDataStack = [CoreDataStack defaultStack];
    [self fetchUser];
    fNotifications = [user.fNotifications boolValue];
    eNotifications = [user.eNotifications boolValue];
    
    protocolArray = @[@"20/4 Feeding", @"16/8 (recommended)", @"Alternate Day Diet"];
    [myPickerView selectRow:1 inComponent:0 animated:NO];
    
    protocolTitleLabels = [NSMutableArray new];
    protocolInformationViews = [NSMutableArray new];
    [self makeInformationViews];
    
    protocolTitleSelection = 0;
    
    isFirstTime = YES;
    isFirstClick = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 150, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 150, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"INTERMITTENT FASTING";
    
    UILabel *protocolPickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 65, 100, 100)];
    if (is35) {
        protocolPickerLabel.frame = CGRectMake(86, 55, 100, 85);
    }
    protocolPickerLabel.font = [UIFont fontWithName:@"Norican-Regular" size:23];
    protocolPickerLabel.textColor = [UIColor whiteColor];
    protocolPickerLabel.text = @"Current Protocol :";
    [protocolPickerLabel sizeToFit];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:protocolPickerLabel];
    
    [self drawInformationView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void) fetchUser {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"(objectId == %@)", [[PFUser currentUser] objectId]];
    [fetchRequest setPredicate:userNamePredicate];
    NSEntityDescription *userEntityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:userEntityDescription];
    NSError *error;
    NSArray *fetchRequestArray = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    user = fetchRequestArray[0];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [protocolArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return protocolArray[row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 26;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:24];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = protocolArray[row];
    
    return label;
}

-(void)drawInformationView {
    UIImageView *protocolDividerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 269, 240, 20)];
    if (is35) {
        [protocolDividerImage1 setFrame:CGRectMake(40, 227, 240, 20)];
    }
    [protocolDividerImage1 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];
    
    UIImageView *protocolDividerImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 310, 240, 20)];
    if (is35) {
        [protocolDividerImage2 setFrame:CGRectMake(40, 262, 240, 20)];
    }
    [protocolDividerImage2 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];
    
    UIButton *leftArrowTouched = [[UIButton alloc] initWithFrame:CGRectMake(40, 290, 22, 20)];
    if (is35) {
        [leftArrowTouched setFrame:CGRectMake(40, 245, 22, 17)];
    }
    leftArrowTouched.tag = 1;
    [leftArrowTouched setImage:[UIImage imageNamed:@"triangle_arrow@2x.png"] forState:UIControlStateNormal];
    [leftArrowTouched addTarget:self action:@selector(protocolArrowTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightArrowTouched = [[UIButton alloc] initWithFrame:CGRectMake(258, 290, 22, 20)];
    if (is35) {
        [rightArrowTouched setFrame:CGRectMake(258, 245, 22, 17)];
    }
    rightArrowTouched.tag = 2;
    [rightArrowTouched setImage:[UIImage imageNamed:@"triangle_arrow@2x.png"] forState:UIControlStateNormal];
    rightArrowTouched.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    [rightArrowTouched addTarget:self action:@selector(protocolArrowTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:protocolDividerImage1];
    [self.view addSubview:protocolDividerImage2];
    
    [self.view addSubview:leftArrowTouched];
    [self.view addSubview:rightArrowTouched];
    
    for (UIView *protocolTitleView in self.view.subviews) {
        if (protocolTitleView.tag == 3) {
            [protocolTitleView removeFromSuperview];
        }
    }
    
    [self.view addSubview:protocolTitleLabels[protocolTitleSelection]];
    [self.view addSubview:protocolInformationViews[protocolTitleSelection]];
}

-(void) makeInformationViews {
    UILabel *twentyByFourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 100)];
    if (is35) {
        twentyByFourLabel.frame = CGRectMake(0, 13, 100, 85);
    }
    twentyByFourLabel.font = [UIFont fontWithName:@"Norican-Regular" size:18];
    twentyByFourLabel.textColor = [UIColor whiteColor];
    twentyByFourLabel.text = @"20/4";
    [twentyByFourLabel sizeToFit];
    
    UILabel *feedingLabel = [[UILabel alloc] initWithFrame:CGRectMake(twentyByFourLabel.frame.size.width + 5, 15, 100, 100)];
    if (is35) {
        feedingLabel.frame = CGRectMake(twentyByFourLabel.frame.size.width + 5, 13, 100, 85);
    }
    feedingLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    feedingLabel.textColor = [UIColor whiteColor];
    feedingLabel.text = @"Feeding";
    [feedingLabel sizeToFit];
    
    UIView *twentyByFourView = [[UIView alloc] initWithFrame:CGRectMake((160 - ((twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5)/2)), 272, (twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5), 150)];
    if (is35) {
        [twentyByFourView setFrame:CGRectMake((160 - ((twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5)/2)), 230, (twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5), 127)];
    }
    [twentyByFourView addSubview:twentyByFourLabel];
    [twentyByFourView addSubview:feedingLabel];
    twentyByFourView.tag = 3;
    
    [protocolTitleLabels addObject:twentyByFourView];
    
    UILabel *sixteenByEightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 100)];
    if (is35) {
        sixteenByEightLabel.frame = CGRectMake(0, 13, 100, 85);
    }
    sixteenByEightLabel.font = [UIFont fontWithName:@"Norican-Regular" size:18];
    sixteenByEightLabel.textColor = [UIColor whiteColor];
    sixteenByEightLabel.text = @"16/8";
    [sixteenByEightLabel sizeToFit];
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(sixteenByEightLabel.frame.size.width + 5, 17, 100, 100)];
    if (is35) {
        protocolLabel.frame = CGRectMake(sixteenByEightLabel.frame.size.width + 5, 14, 100, 85);
    }
    protocolLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    protocolLabel.textColor = [UIColor whiteColor];
    protocolLabel.text = @"PROTOCOL";
    [protocolLabel sizeToFit];
    
    UIView *sixteenByEightView = [[UIView alloc] initWithFrame:CGRectMake(160 - ((sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5)/2), 272, (sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5), 150)];
    if (is35) {
        [sixteenByEightView setFrame:CGRectMake(160 - ((sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5)/2), 230, (sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5), 127)];
    }
    [sixteenByEightView addSubview:sixteenByEightLabel];
    [sixteenByEightView addSubview:protocolLabel];
    sixteenByEightView.tag = 3;
    
    [protocolTitleLabels addObject:sixteenByEightView];
    
    UILabel *alternateDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, 100, 100)];
    if (is35) {
        alternateDayLabel.frame = CGRectMake(0, 14, 100, 85);
    }
    alternateDayLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    alternateDayLabel.textColor = [UIColor whiteColor];
    alternateDayLabel.text = @"ALTERNATE DAY DIET";
    [alternateDayLabel sizeToFit];
    
    UIView *alternateDayView = [[UIView alloc] initWithFrame:CGRectMake(160 - (alternateDayLabel.frame.size.width/2), 272, alternateDayLabel.frame.size.width, 150)];
    if (is35) {
        [alternateDayView setFrame:CGRectMake(160 - (alternateDayLabel.frame.size.width/2), 230, alternateDayLabel.frame.size.width, 127)];
    }
    [alternateDayView addSubview:alternateDayLabel];
    alternateDayView.tag = 3;
    
    [protocolTitleLabels addObject:alternateDayView];
    
    UILabel *twentyByFourInstructionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, 237, 50)];
    if (is35) {
        twentyByFourInstructionLabel1.frame = CGRectMake(43, 0, 237, 42);
    }
    twentyByFourInstructionLabel1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    twentyByFourInstructionLabel1.textColor = [UIColor whiteColor];
    twentyByFourInstructionLabel1.text = @"Fast for 20 consecutive hours";
    
    UILabel *bulletPoint1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 20, 20)];
    if (is35) {
        bulletPoint1.frame = CGRectMake(35, 10, 20, 17);
    }
    bulletPoint1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    bulletPoint1.textColor = [UIColor whiteColor];
    bulletPoint1.text = @".";
    
    UILabel *twentyByFourInstructionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(43, 22, 237, 50)];
    if (is35) {
        twentyByFourInstructionLabel2.frame = CGRectMake(43, 19, 237, 42);
    }
    twentyByFourInstructionLabel2.numberOfLines = 0;
    NSString *twentyByFourInstructionLabel2String = @"Preferably train fasted in the morning, using Branch Chain Amino Acids (BCAAs)";
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
    [style2 setLineHeightMultiple:0.75];
    NSDictionary *attributes2 = @{NSParagraphStyleAttributeName: style2};
    twentyByFourInstructionLabel2.attributedText = [[NSAttributedString alloc] initWithString:twentyByFourInstructionLabel2String attributes:attributes2];
    twentyByFourInstructionLabel2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    twentyByFourInstructionLabel2.textColor = [UIColor whiteColor];
    
    UILabel *bulletPoint2 = [[UILabel alloc] initWithFrame:CGRectMake(35, 26, 20, 20)];
    if (is35) {
        bulletPoint2.frame = CGRectMake(35, 22, 20, 17);
    }
    bulletPoint2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    bulletPoint2.textColor = [UIColor whiteColor];
    bulletPoint2.text = @".";
    
    UILabel *twentyByFourInstructionLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(43, 47, 237, 50)];
    if (is35) {
        twentyByFourInstructionLabel3.frame = CGRectMake(43, 40, 237, 42);
    }
    twentyByFourInstructionLabel3.numberOfLines = 0;
    NSString *twentyByFourInstructionLabel3String = @"Eat for 4 consecutive hours (e.g., skip breakfast and lunch and eat from 5 p.m. until 9 p.m.)";
    NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc] init];
    [style3 setLineHeightMultiple:0.75];
    NSDictionary *attributes3 = @{NSParagraphStyleAttributeName: style3};
    twentyByFourInstructionLabel3.attributedText = [[NSAttributedString alloc] initWithString:twentyByFourInstructionLabel3String attributes:attributes3];
    twentyByFourInstructionLabel3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    twentyByFourInstructionLabel3.textColor = [UIColor whiteColor];

    UILabel *bulletPoint3 = [[UILabel alloc] initWithFrame:CGRectMake(35, 51, 20, 20)];
    if (is35) {
        bulletPoint3.frame = CGRectMake(35, 43, 20, 17);
    }
    bulletPoint3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    bulletPoint3.textColor = [UIColor whiteColor];
    bulletPoint3.text = @".";
    
    UILabel *twentyByFourInstructionLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(43, 65, 237, 50)];
    if (is35) {
        twentyByFourInstructionLabel4.frame = CGRectMake(43, 55, 237, 42);
    }
    twentyByFourInstructionLabel4.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    twentyByFourInstructionLabel4.textColor = [UIColor whiteColor];
    twentyByFourInstructionLabel4.text = @"Repeat this daily";
    
    UILabel *bulletPoint4 = [[UILabel alloc] initWithFrame:CGRectMake(35, 76, 20, 20)];
    if (is35) {
        bulletPoint4.frame = CGRectMake(35, 64, 20, 17);
    }
    bulletPoint4.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    bulletPoint4.textColor = [UIColor whiteColor];
    bulletPoint4.text = @".";
    
    UIView *twentyByFourInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, 320, 106)];
    if (is35) {
        twentyByFourInformationView.frame = CGRectMake(0, 262, 320, 90);
    }
    twentyByFourInformationView.tag = 3;
    [twentyByFourInformationView addSubview:twentyByFourInstructionLabel1];
    [twentyByFourInformationView addSubview:bulletPoint1];
    [twentyByFourInformationView addSubview:twentyByFourInstructionLabel2];
    [twentyByFourInformationView addSubview:bulletPoint2];
    [twentyByFourInformationView addSubview:twentyByFourInstructionLabel3];
    [twentyByFourInformationView addSubview:bulletPoint3];
    [twentyByFourInformationView addSubview:twentyByFourInstructionLabel4];
    [twentyByFourInformationView addSubview:bulletPoint4];
    
    [protocolInformationViews addObject:twentyByFourInformationView];
    
    UILabel *sixteenByEightInstructionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, 237, 50)];
    if (is35) {
        sixteenByEightInstructionLabel1.frame = CGRectMake(43, 0, 237, 42);
    }
    sixteenByEightInstructionLabel1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightInstructionLabel1.textColor = [UIColor whiteColor];
    sixteenByEightInstructionLabel1.text = @"Fast for 16 consecutive hours";
    
    UILabel *sixteenByEightbulletPoint1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 20, 20)];
    if (is35) {
        sixteenByEightbulletPoint1.frame = CGRectMake(35, 10, 20, 17);
    }
    sixteenByEightbulletPoint1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightbulletPoint1.textColor = [UIColor whiteColor];
    sixteenByEightbulletPoint1.text = @".";
    
    UILabel *sixteenByEightInstructionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(43, 22, 237, 50)];
    if (is35) {
        sixteenByEightInstructionLabel2.frame = CGRectMake(43, 19, 237, 42);
    }
    sixteenByEightInstructionLabel2.numberOfLines = 0;
    NSString *sixteenByEightInstructionLabel2String = @"Preferably train fasted in the morning, using Branch Chain Amino Acids (BCAAs)";
    NSMutableParagraphStyle *sixteenByEightStyle2 = [[NSMutableParagraphStyle alloc] init];
    [sixteenByEightStyle2 setLineHeightMultiple:0.75];
    NSDictionary *sixteenByEightAttributes2 = @{NSParagraphStyleAttributeName: sixteenByEightStyle2};
    sixteenByEightInstructionLabel2.attributedText = [[NSAttributedString alloc] initWithString:sixteenByEightInstructionLabel2String attributes:sixteenByEightAttributes2];
    sixteenByEightInstructionLabel2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightInstructionLabel2.textColor = [UIColor whiteColor];
    
    UILabel *sixteenByEightBulletPoint2 = [[UILabel alloc] initWithFrame:CGRectMake(35, 26, 20, 20)];
    if (is35) {
        sixteenByEightBulletPoint2.frame = CGRectMake(35, 22, 20, 17);
    }
    sixteenByEightBulletPoint2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightBulletPoint2.textColor = [UIColor whiteColor];
    sixteenByEightBulletPoint2.text = @".";
    
    UILabel *sixteenByEightInstructionLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(43, 47, 237, 50)];
    if (is35) {
        sixteenByEightInstructionLabel3.frame = CGRectMake(43, 40, 237, 42);
    }
    sixteenByEightInstructionLabel3.numberOfLines = 0;
    NSString *sixteenByEightInstructionLabel3String = @"Eat for 8 consecutive hours (e.g., skip breakfast and eat from noon until 8 p.m.)";
    NSMutableParagraphStyle *sixteenByEightStyle3 = [[NSMutableParagraphStyle alloc] init];
    [sixteenByEightStyle3 setLineHeightMultiple:0.75];
    NSDictionary *sixteenByEightAttributes3 = @{NSParagraphStyleAttributeName: sixteenByEightStyle3};
    sixteenByEightInstructionLabel3.attributedText = [[NSAttributedString alloc] initWithString:sixteenByEightInstructionLabel3String attributes:sixteenByEightAttributes3];
    sixteenByEightInstructionLabel3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightInstructionLabel3.textColor = [UIColor whiteColor];
    
    UILabel *sixteenByEightBulletPoint3 = [[UILabel alloc] initWithFrame:CGRectMake(35, 51, 20, 20)];
    if (is35) {
        sixteenByEightBulletPoint3.frame = CGRectMake(35, 43, 20, 17);
    }
    sixteenByEightBulletPoint3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightBulletPoint3.textColor = [UIColor whiteColor];
    sixteenByEightBulletPoint3.text = @".";
    
    UILabel *sixteenByEightInstructionLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(43, 65, 237, 50)];
    if (is35) {
        sixteenByEightInstructionLabel4.frame = CGRectMake(43, 55, 237, 42);
    }
    sixteenByEightInstructionLabel4.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightInstructionLabel4.textColor = [UIColor whiteColor];
    sixteenByEightInstructionLabel4.text = @"Repeat this daily";
    
    UILabel *sixteenByEightBulletPoint4 = [[UILabel alloc] initWithFrame:CGRectMake(35, 76, 20, 20)];
    if (is35) {
        sixteenByEightBulletPoint4.frame = CGRectMake(35, 64, 20, 17);
    }
    sixteenByEightBulletPoint4.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    sixteenByEightBulletPoint4.textColor = [UIColor whiteColor];
    sixteenByEightBulletPoint4.text = @".";
    
    UIView *sixteenByEightInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, 320, 106)];
    if (is35) {
        sixteenByEightInformationView.frame = CGRectMake(0, 262, 320, 90);
    }
    sixteenByEightInformationView.tag = 3;
    [sixteenByEightInformationView addSubview:sixteenByEightInstructionLabel1];
    [sixteenByEightInformationView addSubview:sixteenByEightbulletPoint1];
    [sixteenByEightInformationView addSubview:sixteenByEightInstructionLabel2];
    [sixteenByEightInformationView addSubview:sixteenByEightBulletPoint2];
    [sixteenByEightInformationView addSubview:sixteenByEightInstructionLabel3];
    [sixteenByEightInformationView addSubview:sixteenByEightBulletPoint3];
    [sixteenByEightInformationView addSubview:sixteenByEightInstructionLabel4];
    [sixteenByEightInformationView addSubview:sixteenByEightBulletPoint4];
    
    [protocolInformationViews addObject:sixteenByEightInformationView];
    
    UILabel *alternateDayInstructionLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(43, 0, 237, 50)];
    if (is35) {
        alternateDayInstructionLabel1.frame = CGRectMake(43, 0, 237, 42);
    }
    alternateDayInstructionLabel1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDayInstructionLabel1.textColor = [UIColor whiteColor];
    alternateDayInstructionLabel1.text = @"Fast for 36 consecutive hours";
    
    UILabel *alternateDaybulletPoint1 = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 20, 20)];
    if (is35) {
        alternateDaybulletPoint1.frame = CGRectMake(35, 10, 20, 17);
    }
    alternateDaybulletPoint1.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDaybulletPoint1.textColor = [UIColor whiteColor];
    alternateDaybulletPoint1.text = @".";
    
    UILabel *alternateDayInstructionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(43, 22, 237, 50)];
    if (is35) {
        alternateDayInstructionLabel2.frame = CGRectMake(43, 19, 237, 42);
    }
    alternateDayInstructionLabel2.numberOfLines = 0;
    NSString *alternateDayInstructionLabel2String = @"Preferably train fasted in the morning, using Branch Chain Amino Acids (BCAAs)";
    NSMutableParagraphStyle *alternateDayStyle2 = [[NSMutableParagraphStyle alloc] init];
    [alternateDayStyle2 setLineHeightMultiple:0.75];
    NSDictionary *alternateDayAttributes2 = @{NSParagraphStyleAttributeName: alternateDayStyle2};
    alternateDayInstructionLabel2.attributedText = [[NSAttributedString alloc] initWithString:alternateDayInstructionLabel2String attributes:alternateDayAttributes2];
    alternateDayInstructionLabel2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDayInstructionLabel2.textColor = [UIColor whiteColor];
    
    UILabel *alternateDayBulletPoint2 = [[UILabel alloc] initWithFrame:CGRectMake(35, 26, 20, 20)];
    if (is35) {
        alternateDayBulletPoint2.frame = CGRectMake(35, 22, 20, 17);
    }
    alternateDayBulletPoint2.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDayBulletPoint2.textColor = [UIColor whiteColor];
    alternateDayBulletPoint2.text = @".";
    
    UILabel *alternateDayInstructionLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(43, 40, 237, 50)];
    if (is35) {
        alternateDayInstructionLabel3.frame = CGRectMake(43, 34, 237, 42);
    }
    alternateDayInstructionLabel3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDayInstructionLabel3.textColor = [UIColor whiteColor];
    alternateDayInstructionLabel3.text = @"Eat on alternating days ";
    
    UILabel *alternateDaybulletPoint3 = [[UILabel alloc] initWithFrame:CGRectMake(35, 51, 20, 20)];
    if (is35) {
        alternateDaybulletPoint3.frame = CGRectMake(35, 43, 20, 17);
    }
    alternateDaybulletPoint3.font = [UIFont fontWithName:@"Oswald-Light" size:10];
    alternateDaybulletPoint3.textColor = [UIColor whiteColor];
    alternateDaybulletPoint3.text = @".";
    
    UIView *alternateDayInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 310, 320, 106)];
    if (is35) {
        alternateDayInformationView.frame = CGRectMake(0, 262, 320, 90);
    }
    alternateDayInformationView.tag = 3;
    [alternateDayInformationView addSubview:alternateDayInstructionLabel1];
    [alternateDayInformationView addSubview:alternateDaybulletPoint1];
    [alternateDayInformationView addSubview:alternateDayInstructionLabel2];
    [alternateDayInformationView addSubview:alternateDayBulletPoint2];
    [alternateDayInformationView addSubview:alternateDayInstructionLabel3];
    [alternateDayInformationView addSubview:alternateDaybulletPoint3];
    
    [protocolInformationViews addObject:alternateDayInformationView];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)protocolHelpButtonTouched:(id)sender {
    translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    if (is35) {
        [translucentView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    translucentView.translucentAlpha = 1;
    translucentView.translucentStyle = UIBarStyleBlack;
    translucentView.translucentTintColor = [UIColor clearColor];
    translucentView.backgroundColor = [UIColor clearColor];
    
    closePopUpViewButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 18, 39, 38)];
    if (is35) {
        [closePopUpViewButton setFrame:CGRectMake(21, 15, 33, 32)];
    }
    [closePopUpViewButton setImage:[UIImage imageNamed:@"x_icon@2x.png"] forState:UIControlStateNormal];
    [closePopUpViewButton addTarget:self action:@selector(closePopUpViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *welcomeToLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 102, 150, 150)];
    if (is35) {
        welcomeToLabel.frame = CGRectMake(101, 86, 127, 127);
    }
    welcomeToLabel.font = [UIFont fontWithName:@"Norican-Regular" size:22];
    welcomeToLabel.textColor = [UIColor whiteColor];
    welcomeToLabel.text = @"Welcome to";
    [welcomeToLabel sizeToFit];
    welcomeToLabel.frame = CGRectMake(160 - welcomeToLabel.frame.size.width/2, welcomeToLabel.frame.origin.y, welcomeToLabel.frame.size.width, welcomeToLabel.frame.size.height);
    
    UILabel *intermittentFastingLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 128, 150, 150)];
    if (is35) {
        intermittentFastingLabel.frame = CGRectMake(80, 108, 150, 127);
    }
    intermittentFastingLabel.font = [UIFont fontWithName:@"Oswald" size:25];
    intermittentFastingLabel.textColor = [UIColor whiteColor];
    intermittentFastingLabel.text = @"INTERMITTENT FASTING";
    [intermittentFastingLabel sizeToFit];
    intermittentFastingLabel.frame = CGRectMake(160 - intermittentFastingLabel.frame.size.width/2, intermittentFastingLabel.frame.origin.y, intermittentFastingLabel.frame.size.width, intermittentFastingLabel.frame.size.height);
    
    UILabel *hereYouCanLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 207, 150, 150)];
    if (is35) {
        hereYouCanLabel.frame = CGRectMake(80, 175, 150, 127);
    }
    hereYouCanLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    hereYouCanLabel.textColor = [UIColor whiteColor];
    hereYouCanLabel.text = @"HERE YOU CAN...";
    [hereYouCanLabel sizeToFit];
    hereYouCanLabel.frame = CGRectMake(160 - hereYouCanLabel.frame.size.width/2, hereYouCanLabel.frame.origin.y, hereYouCanLabel.frame.size.width, hereYouCanLabel.frame.size.height);
    
    UIImageView *protocolDividerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(47, 187, 229, 20)];
    if (is35) {
        [protocolDividerImage1 setFrame:CGRectMake(47, 158, 229, 20)];
    }
    [protocolDividerImage1 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];
    
    UIImageView *protocolDividerImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(47, 228, 229, 20)];
    if (is35) {
        [protocolDividerImage2 setFrame:CGRectMake(47, 193, 229, 20)];
    }
    [protocolDividerImage2 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];

    UILabel *bulletPoint1 = [[UILabel alloc] initWithFrame:CGRectMake(36, 254, 20, 20)];
    if (is35) {
        bulletPoint1.frame = CGRectMake(36, 215, 20, 17);
    }
    bulletPoint1.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    bulletPoint1.textColor = [UIColor whiteColor];
    bulletPoint1.text = @".";

    UILabel *bulletPoint2 = [[UILabel alloc] initWithFrame:CGRectMake(36, 321.5, 20, 20)];
    if (is35) {
        bulletPoint2.frame = CGRectMake(36, 272, 20, 17);
    }
    bulletPoint2.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    bulletPoint2.textColor = [UIColor whiteColor];
    bulletPoint2.text = @".";
    
    UILabel *bulletPoint3 = [[UILabel alloc] initWithFrame:CGRectMake(36, 352, 20, 20)];
    if (is35) {
        bulletPoint3.frame = CGRectMake(36, 297, 20, 17);
    }
    bulletPoint3.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    bulletPoint3.textColor = [UIColor whiteColor];
    bulletPoint3.text = @".";
    
    UILabel *bulletPoint4 = [[UILabel alloc] initWithFrame:CGRectMake(36, 419.5, 20, 20)];
    if (is35) {
        bulletPoint4.frame = CGRectMake(36, 355, 20, 17);
    }
    bulletPoint4.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    bulletPoint4.textColor = [UIColor whiteColor];
    bulletPoint4.text = @".";
    
    UILabel *bulletPoint1Text = [[UILabel alloc] initWithFrame:CGRectMake(46, 262, 228, 100)];
    if (is35) {
        bulletPoint1Text.frame = CGRectMake(46, 221, 228, 85);
    }
    bulletPoint1Text.lineBreakMode = NSLineBreakByWordWrapping;
    bulletPoint1Text.numberOfLines = 0;
    bulletPoint1Text.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    bulletPoint1Text.textColor = [UIColor whiteColor];
    bulletPoint1Text.text = @"Start your recommended fasting protocol or change it to another one that you feel suits your needs";
    [bulletPoint1Text sizeToFit];
    
    UILabel *bulletPoint2Text = [[UILabel alloc] initWithFrame:CGRectMake(46, (bulletPoint1Text.frame.origin.y + bulletPoint1Text.frame.size.height + 12), 228, 100)];
    if (is35) {
        CGRectMake(46, (bulletPoint1Text.frame.origin.y + bulletPoint1Text.frame.size.height + 12), 228, 85);
    }
    bulletPoint2Text.lineBreakMode = NSLineBreakByWordWrapping;
    bulletPoint2Text.numberOfLines = 0;
    bulletPoint2Text.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    bulletPoint2Text.textColor = [UIColor whiteColor];
    bulletPoint2Text.text = @"Get information about each fasting protocol";
    [bulletPoint2Text sizeToFit];
    
    UILabel *bulletPoint3Text = [[UILabel alloc] initWithFrame:CGRectMake(46, (bulletPoint2Text.frame.origin.y + bulletPoint2Text.frame.size.height + 12), 228, 100)];
    if (is35) {
        bulletPoint3Text.frame = CGRectMake(46, (bulletPoint2Text.frame.origin.y + bulletPoint2Text.frame.size.height + 12), 228, 85);
    }
    bulletPoint3Text.lineBreakMode = NSLineBreakByWordWrapping;
    bulletPoint3Text.numberOfLines = 0;
    bulletPoint3Text.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    bulletPoint3Text.textColor = [UIColor whiteColor];
    bulletPoint3Text.text = @"Keep track of your FASTING and EATING times via the timer feature that tells you how much time you have to FAST or EAT";
    [bulletPoint3Text sizeToFit];
    
    UILabel *bulletPoint4Text = [[UILabel alloc] initWithFrame:CGRectMake(46, (bulletPoint3Text.frame.origin.y + bulletPoint3Text.frame.size.height + 12), 228, 100)];
    if (is35) {
        bulletPoint4Text.frame = CGRectMake(46, (bulletPoint3Text.frame.origin.y + bulletPoint3Text.frame.size.height + 12), 228, 85);
    }
    bulletPoint4Text.lineBreakMode = NSLineBreakByWordWrapping;
    bulletPoint4Text.numberOfLines = 0;
    bulletPoint4Text.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    bulletPoint4Text.textColor = [UIColor whiteColor];
    bulletPoint4Text.text = @"Enable push notifications for FASTING and EATING so you are reminded every hour of how much time you have left to eat or fast";
    [bulletPoint4Text sizeToFit];
    
    NSLog(@"YY = %f", bulletPoint4Text.frame.origin.y);
    
    [self.view addSubview:translucentView];
    [translucentView addSubview:closePopUpViewButton];
    [translucentView addSubview:intermittentFastingLabel];
    [translucentView addSubview:hereYouCanLabel];
    [translucentView addSubview:protocolDividerImage1];
    [translucentView addSubview:protocolDividerImage2];
    [translucentView addSubview:welcomeToLabel];
    [translucentView addSubview:bulletPoint1];
    [translucentView addSubview:bulletPoint2];
    [translucentView addSubview:bulletPoint3];
    [translucentView addSubview:bulletPoint4];
    [translucentView addSubview:bulletPoint1Text];
    [translucentView addSubview:bulletPoint2Text];
    [translucentView addSubview:bulletPoint3Text];
    [translucentView addSubview:bulletPoint4Text];
}

-(void) closePopUpViewButtonPressed:(UIButton *)sender {
    [translucentView removeFromSuperview];
}

-(void) protocolArrowTouched:(UIButton *)sender {
    if (sender.tag == 1 && protocolTitleSelection > 0) {
        protocolTitleSelection -= 1;
        [self drawInformationView];
    }
    
    if (sender.tag == 2 && protocolTitleSelection < 2) {
        protocolTitleSelection += 1;
        [self drawInformationView];
    }
}

-(void) notificationSelectionButtonTouched:(UIButton *)sender {
    if (sender.tag == 4) {
        fNotifications = !fNotifications;
    }
    if (sender.tag == 5) {
        eNotifications = !eNotifications;
    }
}

-(void) updateButtonTouched {
    NSLog(@"user.fNotifications = %@", user.fNotifications);
    NSLog(@"user.eNotifications = %@", user.eNotifications);
    
    user.fNotifications = [NSNumber numberWithBool:fNotifications];
    user.eNotifications = [NSNumber numberWithBool:eNotifications];
    
    [coreDataStack saveContext];
    
    NSLog(@"user.fNotifications = %@", user.fNotifications);
    NSLog(@"user.eNotifications = %@", user.eNotifications);
}

- (IBAction)startButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"ProtocolSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ProtocolTimingViewController *myProtocolTimingViewController = (ProtocolTimingViewController *) segue.destinationViewController;
    
    myProtocolTimingViewController.protocolSelection = (int)[myPickerView selectedRowInComponent:0] + 1;
}

@end
