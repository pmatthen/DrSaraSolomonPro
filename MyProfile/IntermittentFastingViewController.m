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
#import <math.h>

@import EventKit;

@interface IntermittentFastingViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
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
@property NSArray *reminders;

@property NSDictionary *nextReminderDictionary;
@property NSTimeInterval secondsBetween;

// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@property (strong, nonatomic) EKCalendar *calendar;

@end

@implementation IntermittentFastingViewController
@synthesize categoryArray, protocolArray, myPickerView, isFirstTime, isFirstClick, currentSelection, protocolTitleLabels, protocolInformationViews, protocolTitleSelection, fNotifications, eNotifications, user, coreDataStack, translucentView, closePopUpViewButton, is35, nextReminderDictionary, myTableView, secondsBetween;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateAuthorizationStatusToAccessEventStore];
    
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
    
    categoryArray = @[@"TIMER", @"INFORMATION"];
    
    isFirstTime = YES;
    isFirstClick = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];

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
    
    [self fetchReminders];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntermittentFastingTableViewCell *cell = (IntermittentFastingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"IFCell"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    cell.myTitleLabel.textColor = [UIColor whiteColor];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    
    for (UIView *tempView in cell.cellContentView.subviews) {
        [tempView removeFromSuperview];
    }
    
    switch (indexPath.row) {
        {case 0:
            NSLog(@"");
            
            NSString *timerMessage;
            if ([[nextReminderDictionary objectForKey:@"type"] isEqualToString:@"eating"]) {
                timerMessage = @"TIME REMAINING TO FAST";
            } else {
                timerMessage = @"TIME REMAINING TO EAT";
            }
            
            UILabel *timerMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
            timerMessageLabel.font = [UIFont fontWithName:@"Oswald" size:15];
            timerMessageLabel.textColor = [UIColor whiteColor];
            timerMessageLabel.text = timerMessage;
            [timerMessageLabel sizeToFit];
            timerMessageLabel.frame = CGRectMake((320 - timerMessageLabel.frame.size.width)/2, 35, timerMessageLabel.frame.size.width, timerMessageLabel.frame.size.height);
            if (is35) {
                timerMessageLabel.frame = CGRectMake((320 - timerMessageLabel.frame.size.width)/2, 30, timerMessageLabel.frame.size.width, timerMessageLabel.frame.size.height);
            }
            
            [cell.cellContentView addSubview:timerMessageLabel];
            
            if (secondsBetween < 0) {
                [self fetchReminders];
            }

            int hoursBetween = (int)(secondsBetween/(60 * 60));
            int minutesBetween = (int)(secondsBetween - (hoursBetween * (60 * 60)))/(60);
            int secsBetween = (int)(secondsBetween - (hoursBetween * (60 * 60)) - (minutesBetween * 60));
            
            UILabel *hoursLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 58, 60, 100)];
            if (is35) {
                hoursLeftLabel.frame = CGRectMake(45, 49, 60, 100);
            }
            hoursLeftLabel.font = [UIFont fontWithName:@"Oswald" size:52];
            hoursLeftLabel.textColor = [UIColor whiteColor];
            hoursLeftLabel.text = [NSString stringWithFormat:@"%02d", hoursBetween];
            hoursLeftLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *minutesLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 58, 60, 100)];
            if (is35) {
                minutesLeftLabel.frame = CGRectMake(127, 49, 60, 100);
            }
            minutesLeftLabel.font = [UIFont fontWithName:@"Oswald" size:52];
            minutesLeftLabel.textColor = [UIColor whiteColor];
            minutesLeftLabel.text = [NSString stringWithFormat:@"%02d", minutesBetween];
            minutesLeftLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *secondsLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(212, 58, 60, 100)];
            if (is35) {
                secondsLeftLabel.frame = CGRectMake(212, 49, 60, 100);
            }
            secondsLeftLabel.font = [UIFont fontWithName:@"Oswald" size:52];
            secondsLeftLabel.textColor = [UIColor whiteColor];
            secondsLeftLabel.text = [NSString stringWithFormat:@"%02d", secsBetween];
            secondsLeftLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *colonLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(108, 58, 100, 100)];
            if (is35) {
                colonLabel1.frame = CGRectMake(108, 49, 100, 100);
            }
            colonLabel1.font = [UIFont fontWithName:@"Oswald" size:52];
            colonLabel1.textColor = [UIColor whiteColor];
            colonLabel1.text = @":";
            
            UILabel *colonLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(192, 58, 100, 100)];
            if (is35) {
                colonLabel2.frame = CGRectMake(192, 49, 100, 100);
            }
            colonLabel2.font = [UIFont fontWithName:@"Oswald" size:52];
            colonLabel2.textColor = [UIColor whiteColor];
            colonLabel2.text = @":";
            
            UILabel *hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 106, 100, 100)];
            if (is35) {
                hoursLabel.frame = CGRectMake(56, 90, 100, 100);
            }
            hoursLabel.font = [UIFont fontWithName:@"Oswald" size:15];
            hoursLabel.textColor = [UIColor whiteColor];
            hoursLabel.text = @"HOURS";
            
            UILabel *minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(128, 106, 100, 100)];
            if (is35) {
                minutesLabel.frame = CGRectMake(128, 90, 100, 100);
            }
            minutesLabel.font = [UIFont fontWithName:@"Oswald" size:15];
            minutesLabel.textColor = [UIColor whiteColor];
            minutesLabel.text = @"MINUTES";
            
            UILabel *secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(213, 106, 100, 100)];
            if (is35) {
                secondsLabel.frame = CGRectMake(213, 90, 100, 100);
            }
            secondsLabel.font = [UIFont fontWithName:@"Oswald" size:15];
            secondsLabel.textColor = [UIColor whiteColor];
            secondsLabel.text = @"SECONDS";
            
            [cell.cellContentView addSubview:hoursLeftLabel];
            [cell.cellContentView addSubview:minutesLeftLabel];
            [cell.cellContentView addSubview:secondsLeftLabel];
            [cell.cellContentView addSubview:colonLabel1];
            [cell.cellContentView addSubview:colonLabel2];
            [cell.cellContentView addSubview:hoursLabel];
            [cell.cellContentView addSubview:minutesLabel];
            [cell.cellContentView addSubview:secondsLabel];
            
            break;}
        {case 1:
            NSLog(@"");
            UIImageView *protocolDividerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 240, 20)];
            [protocolDividerImage1 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];
            
            UIImageView *protocolDividerImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, 41, 240, 20)];
            [protocolDividerImage2 setImage:[UIImage imageNamed:@"protocoldividers_thin.png"]];
            
            UIButton *leftArrowTouched = [[UIButton alloc] initWithFrame:CGRectMake(40, 24, 22, 20)];
            leftArrowTouched.tag = 1;
            [leftArrowTouched setImage:[UIImage imageNamed:@"triangle_arrow@2x.png"] forState:UIControlStateNormal];
            [leftArrowTouched addTarget:self action:@selector(protocolArrowTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *rightArrowTouched = [[UIButton alloc] initWithFrame:CGRectMake(258, 24, 22, 20)];
            rightArrowTouched.tag = 2;
            [rightArrowTouched setImage:[UIImage imageNamed:@"triangle_arrow@2x.png"] forState:UIControlStateNormal];
            rightArrowTouched.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
            [rightArrowTouched addTarget:self action:@selector(protocolArrowTouched:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.cellContentView addSubview:protocolDividerImage1];
            [cell.cellContentView addSubview:protocolDividerImage2];
            
            [cell.cellContentView addSubview:leftArrowTouched];
            [cell.cellContentView addSubview:rightArrowTouched];
            
            for (UIView *protocolTitleView in cell.cellContentView.subviews) {
                if (protocolTitleView.tag == 3) {
                    [protocolTitleView removeFromSuperview];
                }
            }
            
            [cell.cellContentView addSubview:protocolTitleLabels[protocolTitleSelection]];
            [cell.cellContentView addSubview:protocolInformationViews[protocolTitleSelection]];
            break;}
        {default:
            break;}
    }
    
    if (isFirstTime) {
        cell.myImageView.image = [UIImage imageNamed:@"upArrow@2x.png"];
        isFirstTime = NO;
    } else {
        cell.myImageView.image = [UIImage imageNamed:@"downArrow@2x.png"];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (isFirstClick) {
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        IntermittentFastingTableViewCell *cell = (IntermittentFastingTableViewCell *)[tableView cellForRowAtIndexPath:myIndexPath];
        cell.myImageView.image = [UIImage imageNamed:@"downArrow@2x.png"];
        isFirstClick = NO;
    }
    
    int row = (int)[indexPath row];
    currentSelection = row;
    
    
    IntermittentFastingTableViewCell* cell = (IntermittentFastingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"upArrow@2x.png"];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    IntermittentFastingTableViewCell *cell = (IntermittentFastingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"downArrow@2x.png"];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == currentSelection) {
        if (is35) {
            return 237;
        } else {
            return 281;
        }
    }
    else {
        if (is35) {
            return 46;
        } else {
            return 55;
        }
    }
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
    
    UIView *twentyByFourView = [[UIView alloc] initWithFrame:CGRectMake((160 - ((twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5)/2)), 6, (twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5), 150)];
    if (is35) {
        [twentyByFourView setFrame:CGRectMake((160 - ((twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5)/2)), 5, (twentyByFourLabel.frame.size.width + feedingLabel.frame.size.width + 5), 127)];
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
    
    UIView *sixteenByEightView = [[UIView alloc] initWithFrame:CGRectMake(160 - ((sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5)/2), 6, (sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5), 150)];
    if (is35) {
        [sixteenByEightView setFrame:CGRectMake(160 - ((sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5)/2), 5, (sixteenByEightLabel.frame.size.width + protocolLabel.frame.size.width + 5), 127)];
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
    
    UIView *alternateDayView = [[UIView alloc] initWithFrame:CGRectMake(160 - (alternateDayLabel.frame.size.width/2), 6, alternateDayLabel.frame.size.width, 150)];
    if (is35) {
        [alternateDayView setFrame:CGRectMake(160 - (alternateDayLabel.frame.size.width/2), 5, alternateDayLabel.frame.size.width, 127)];
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
    
    UIView *twentyByFourInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 106)];
    if (is35) {
        twentyByFourInformationView.frame = CGRectMake(0, 37, 320, 90);
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
    
    UIView *sixteenByEightInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 106)];
    if (is35) {
        sixteenByEightInformationView.frame = CGRectMake(0, 37, 320, 90);
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
    
    UIView *alternateDayInformationView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 106)];
    if (is35) {
        alternateDayInformationView.frame = CGRectMake(0, 37, 320, 90);
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
        [myTableView reloadData];
    }
    
    if (sender.tag == 2 && protocolTitleSelection < 2) {
        protocolTitleSelection += 1;
        [myTableView reloadData];
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

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak IntermittentFastingViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                });
                                            }];
            break;
        }
    }
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = @"IFCalendar";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"IFCalendar";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (void)fetchReminders {
    if (self.isAccessToEventStoreGranted) {
        // 1
        NSPredicate *predicate =
        [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
        
        // 2
        [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            // 3
            dispatch_async(dispatch_get_main_queue(), ^{
                self.reminders = [self sortReminders:reminders];
                nextReminderDictionary = [self determineTimeandTypeOfNextReminder:self.reminders];
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                
                NSLog(@"The time of the next reminder is %@", [gregorianCalendar dateFromComponents:[nextReminderDictionary objectForKey:@"dateComponents"]]);
                NSLog(@"The type of the next reminder is %@", [nextReminderDictionary objectForKey:@"type"]);

                [myTableView beginUpdates];
                [myTableView endUpdates];
            });
        }];
    }
}

-(NSArray *) sortReminders:(NSArray *)reminderArray {
    NSArray *sortedArray;
    
    sortedArray = [reminderArray sortedArrayUsingComparator:^NSComparisonResult(EKReminder *a, EKReminder *b) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *firstDateComponent = a.dueDateComponents;
        NSDateComponents *secondDateComponent = b.dueDateComponents;
        
        NSDate *first = [gregorianCalendar dateFromComponents:firstDateComponent];
        NSDate *second = [gregorianCalendar dateFromComponents:secondDateComponent];
        return [first compare:second];
    }];
    
    return sortedArray;
}

-(NSDictionary *) determineTimeandTypeOfNextReminder:(NSArray *)reminderArray {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentMoment = [NSDate date];

    EKReminder *nextReminder = [[EKReminder alloc] init];
    nextReminder = nil;
    
    for (int i = 0; i < [reminderArray count]; i++) {
        EKReminder *tempReminder = reminderArray[i];
        NSDate *tempReminderDate = [gregorianCalendar dateFromComponents:tempReminder.dueDateComponents];
        NSDate *nextReminderDate = [gregorianCalendar dateFromComponents:nextReminder.dueDateComponents];
        
        if ([currentMoment compare:tempReminderDate] == NSOrderedAscending) {
            if (nextReminder == nil) {
                nextReminder = tempReminder;
            } else if ([nextReminderDate compare:tempReminderDate] == NSOrderedDescending) {
                nextReminder = tempReminder;
            }
        }
    }
    
    NSDateComponents *reminderDueDateComponents = [[NSDateComponents alloc] init];
    if (nextReminder) {
        reminderDueDateComponents = nextReminder.dueDateComponents;
    }

    NSString *reminderType = [[NSString alloc] init];
    reminderType = nil;
    if (nextReminder) {
        if ([nextReminder.title isEqualToString:@"Time to start eating"]) {
            reminderType = @"eating";
        } else if ([nextReminder.title isEqualToString:@"Time to start fasting"]) {
            reminderType = @"fasting";
        }
    }
    
    NSDictionary *reminderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:reminderType, @"type", reminderDueDateComponents, @"dateComponents", nil];
    
    return reminderDictionary;
}

-(void)targetMethod:(id)sender {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *tempReminderDate = [gregorianCalendar dateFromComponents:[nextReminderDictionary objectForKey:@"dateComponents"]];
    NSDate *currentDate = [NSDate date];
    
    secondsBetween = [tempReminderDate timeIntervalSinceDate:currentDate];
    
    [myTableView reloadData];
}

@end
