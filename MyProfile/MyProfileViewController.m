//
//  MyProfileViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 06/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileTableViewCell.h"
#import "CoreDataStack.h"
#import "User.h"
#import "RecordedWeight.h"
#import "SaveImageNSValueTransformer.h"
#import <QuartzCore/QuartzCore.h>
#import "BEMSimpleLineGraphView.h"

@interface MyProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property int currentSelection;
@property BOOL isFirstTime;
@property BOOL isFirstClick;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property UIImageView *cameraIconImageView;
@property UILabel *imageInstructionLabel;
@property(nonatomic, retain) UIImage *coreDataUserImage;
@property CoreDataStack *coreDataStack;
@property User *user;
@property NSArray *recordedWeights;
@property UILabel *gainedOrLostLabel;
@property UILabel *motivationLabel;
@property UILabel *amountLabel;
@property UILabel *lbsLabel;
@property UIView *messageView;
@property BEMSimpleLineGraphView *myGraph;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property UIView *pickerViewView;
@property BOOL is35;

@end

@implementation MyProfileViewController
@synthesize categoryArray, currentSelection, myTableView, isFirstTime, isFirstClick, myPickerView, weightArray, fetchedResultsController, myCameraButton, cameraIconImageView, imageInstructionLabel, coreDataUserImage, coreDataStack, user, recordedWeights, gainedOrLostLabel, motivationLabel, amountLabel, lbsLabel, messageView, myGraph, arrayOfValues, arrayOfDates, pickerViewView, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    recordedWeights = [NSArray new];
    coreDataStack = [CoreDataStack defaultStack];
    [self fetchUser];
    
    myCameraButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    myCameraButton.imageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    myCameraButton.imageView.layer.cornerRadius = myCameraButton.frame.size.height/2;
    myCameraButton.imageView.clipsToBounds = YES;
    [myCameraButton.imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [myCameraButton.imageView.layer setBorderWidth:2.0];
    
    categoryArray = @[@"STATUS", @"PROGRESS", @"RECORD WEIGHT"];
    
    weightArray = [NSMutableArray new];
    for (int i = 0; i < 500; i++) {
        [weightArray addObject:[NSNumber numberWithInt:i]];
    }
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(-15, -39, 320, 215)];
    myPickerView.showsSelectionIndicator = NO;
    myPickerView.hidden = NO;
    myPickerView.delegate = self;
    
    pickerViewView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, 320, 102)];
    pickerViewView.clipsToBounds = YES;
    
    if (is35) {
        [myPickerView setFrame:CGRectMake(-15, -33, 320, 182)];
        [pickerViewView setFrame:CGRectMake(0, 52, 320, 86)];
    }
    
    [pickerViewView addSubview:myPickerView];

    [self fillRecordedWeightsArray];
    
    // Checks whether there are any recorded weights, and if so it sets the pickerView column to the latest record. If not, it set's the pickerView column to the users initial weight.
    if ([recordedWeights count] > 0) {
        RecordedWeight *latestRecordedWeight = [recordedWeights firstObject];
        
        for (RecordedWeight *tempRecordedWeight in recordedWeights) {
            NSLog(@"tempRecordedWeight = %@", tempRecordedWeight.weight);
            if ([latestRecordedWeight.date compare:tempRecordedWeight.date] == NSOrderedAscending) {
                latestRecordedWeight = tempRecordedWeight;
            }
        }
        [myPickerView selectRow:[latestRecordedWeight.weight intValue] inComponent:0 animated:NO];
    } else {
        [myPickerView selectRow:[user.initialWeight intValue] inComponent:0 animated:NO];
        RecordedWeight *latestRecordedWeight = [[RecordedWeight alloc] initWithEntity:[NSEntityDescription entityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
        [latestRecordedWeight setDate:user.dateCreated];
        [latestRecordedWeight setWeight:user.initialWeight];
    }
    
    arrayOfDates = [[NSMutableArray alloc] initWithArray:@[@"", @"", @"", @""]];
    arrayOfValues = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0, @0]];
    
    [self calculateWeeklyWeightMeans:[NSNumber numberWithInt:4]];
    
    myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(10, 78, 290, 180)];
    myGraph.dataSource = self;
    myGraph.delegate = self;
    
    if (is35) {
        [myGraph setFrame:CGRectMake(10, 66, 290, 152)];
    }
    
    myGraph.colorTop = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.0];
    myGraph.colorBottom = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.0];
    myGraph.colorLine = [UIColor whiteColor];
    myGraph.colorXaxisLabel = [UIColor whiteColor];
    myGraph.colorYaxisLabel = [UIColor whiteColor];
    myGraph.widthLine = 2.0;
    myGraph.enableTouchReport = YES;
    myGraph.enablePopUpReport = YES;
    myGraph.enableBezierCurve = NO;
    myGraph.enableYAxisLabel = YES;
    myGraph.autoScaleYAxis = YES;
    myGraph.alwaysDisplayDots = NO;
    myGraph.enableReferenceAxisLines = YES;
    myGraph.enableReferenceAxisFrame = YES;
    myGraph.animationGraphStyle = BEMLineAnimationNone;
    
    isFirstTime = YES;
    isFirstClick = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MY PROFILE";
    
    imageInstructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 131, 39, 30)];
    imageInstructionLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    imageInstructionLabel.textColor = [UIColor whiteColor];
    imageInstructionLabel.text = @"ADD PROFILE PHOTO";
    [imageInstructionLabel sizeToFit];
    
    cameraIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_icon@2x.png"]];
    cameraIconImageView.frame = CGRectMake(138, 94, 39, 30);

    [myCameraButton setImage:[[UIImage alloc]initWithData:user.userPhoto] forState:UIControlStateNormal];
    [myCameraButton setImage:[[UIImage alloc]initWithData:user.userPhoto] forState:UIControlStateHighlighted];
    
    if ([[UIImage alloc]initWithData:user.userPhoto]) {
        cameraIconImageView.hidden = YES;
        imageInstructionLabel.hidden = YES;
    } else {
        [myCameraButton setImage:[UIImage imageNamed:@"deafult_profilepic.png"] forState:UIControlStateNormal];
    }
    
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
        imageInstructionLabel.frame = CGRectMake(112, 111, 39, 25);
        [imageInstructionLabel sizeToFit];
        [cameraIconImageView setFrame:CGRectMake(144, 79, 33, 25)];
    }
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:imageInstructionLabel];
    [self.view addSubview:cameraIconImageView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self calculateWeeklyWeightMeans:[NSNumber numberWithInt:4]];
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
    
    user = [fetchRequestArray firstObject];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyProfileCell"];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    cell.myTitleLabel.textColor = [UIColor whiteColor];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];

    switch (indexPath.row) {
        {case 0:
            NSLog(@"");
            [self fillRecordedWeightsArray];

            RecordedWeight *latestWeight = nil;
            
            if ([recordedWeights count] > 0) {
                latestWeight = recordedWeights[0];
                for (RecordedWeight *recordedWeight in recordedWeights) {
                    if ([latestWeight.date compare:recordedWeight.date] == NSOrderedAscending) {
                        latestWeight = recordedWeight;
                    }
                }
            }
            
            [messageView removeFromSuperview];
            [motivationLabel removeFromSuperview];
            
            gainedOrLostLabel = [[UILabel alloc] init];
            motivationLabel = [[UILabel alloc] init];
            
            int weightDifference = [latestWeight.weight intValue] - [user.initialWeight intValue];

            if (latestWeight == nil) {
                gainedOrLostLabel.text = @"YOU'RE ";
                motivationLabel.text = @"Gotta try hard, gotta get sexy!";
            } else if (weightDifference > 0) {
                gainedOrLostLabel.text = @"YOU'VE GAINED ";
                motivationLabel.text = @"Gotta try harder, gotta get sexy!";
            } else if (weightDifference < 0) {
                gainedOrLostLabel.text = @"YOU'VE LOST ";
                motivationLabel.text = @"Keep going. You're kicking ass!";
            } else if (weightDifference == 0) {
                gainedOrLostLabel.text = @"YOU'VE GAINED ";
                motivationLabel.text = @"Keep on it, the results are coming!";
            }
            
            gainedOrLostLabel.font = [UIFont fontWithName:@"Oswald" size:30];
            gainedOrLostLabel.textColor = [UIColor whiteColor];
            gainedOrLostLabel.frame = CGRectMake(0, 103, 100, 100);
            if (is35) {
                gainedOrLostLabel.frame = CGRectMake(0, 87, 100, 85);
            }
            [gainedOrLostLabel sizeToFit];
            
            motivationLabel.font = [UIFont fontWithName:@"Norican-Regular" size:22];
            motivationLabel.textColor = [UIColor whiteColor];
            motivationLabel.frame = CGRectMake(0, 150, 100, 100);
            if (is35) {
                motivationLabel.frame = CGRectMake(0, 127, 100, 85);
            }
            [motivationLabel sizeToFit];
            motivationLabel.frame = CGRectMake(160 - motivationLabel.frame.size.width/2, motivationLabel.frame.origin.y, motivationLabel.frame.size.width, motivationLabel.frame.size.height);
            
            amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(gainedOrLostLabel.frame.origin.x + gainedOrLostLabel.frame.size.width, gainedOrLostLabel.frame.origin.y - 3, 50, 50)];
            if (is35) {
                amountLabel.frame = CGRectMake(gainedOrLostLabel.frame.origin.x + gainedOrLostLabel.frame.size.width, gainedOrLostLabel.frame.origin.y - 3, 50, 42);
            }
            amountLabel.font = [UIFont fontWithName:@"Norican-Regular" size:38];
            amountLabel.textColor = [UIColor whiteColor];
            amountLabel.text = [NSString stringWithFormat:@"%i", abs(weightDifference)];
            [amountLabel sizeToFit];
            
            lbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(amountLabel.frame.origin.x + amountLabel.frame.size.width, amountLabel.frame.origin.y + 3, 50, 50)];
            if (is35) {
                lbsLabel.frame = CGRectMake(amountLabel.frame.origin.x + amountLabel.frame.size.width, amountLabel.frame.origin.y + 3, 50, 42);
            }
            lbsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:26];
            lbsLabel.textColor = [UIColor whiteColor];
            lbsLabel.text = @"lbs";
            [amountLabel sizeToFit];
            
            messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gainedOrLostLabel.frame.size.width + amountLabel.frame.size.width + lbsLabel.frame.size.width, 50)];
            if (is35) {
                messageView.frame = CGRectMake(0, 0, gainedOrLostLabel.frame.size.width + amountLabel.frame.size.width + lbsLabel.frame.size.width, 42);
            }
            [messageView addSubview:gainedOrLostLabel];
            [messageView addSubview:amountLabel];
            [messageView addSubview:lbsLabel];
            [messageView sizeToFit];
            messageView.frame = CGRectMake((160 - messageView.frame.size.width/2) + 15, 0, messageView.frame.size.width, messageView.frame.size.height);
            
            [cell.contentView addSubview:messageView];
            [cell.contentView addSubview:motivationLabel];
            break;}
        {case 1:
            NSLog(@"");
            [cell.contentView addSubview:myGraph];
            break;}
        {case 2:
            NSLog(@"");
            UIButton *updateButton = [[UIButton alloc] init];
            [updateButton setImage:[UIImage imageNamed:@"update_button.png"] forState:UIControlStateNormal];
            [updateButton setFrame:CGRectMake(66, 168, 190, 85)];
            if (is35) {
                [updateButton setFrame:CGRectMake(66, 142, 190, 72)];
            }
            [updateButton addTarget:self
                       action:@selector(updateButtonTouched:)
             forControlEvents:UIControlEventTouchUpInside];
            
            lbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(212, 118, 50, 50)];
            if (is35) {
                lbsLabel.frame = CGRectMake(212, 100, 50, 42);
            }
            lbsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:25];
            lbsLabel.textColor = [UIColor whiteColor];
            lbsLabel.text = @"lbs";
            [lbsLabel sizeToFit];
            
            [cell.contentView addSubview:updateButton];
            [cell.contentView addSubview:pickerViewView];
            [cell.contentView addSubview:lbsLabel];
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
        MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[tableView cellForRowAtIndexPath:myIndexPath];
        cell.myImageView.image = [UIImage imageNamed:@"downArrow@2x.png"];
        isFirstClick = NO;
    }
    
    int row = (int)[indexPath row];
    currentSelection = row;
    
    
    MyProfileTableViewCell* cell = (MyProfileTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"upArrow@2x.png"];

    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyProfileTableViewCell* cell = (MyProfileTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"downArrow@2x.png"];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == currentSelection) {
        if (is35) {
            return 227;
        } else {
            return 269;
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
    return [weightArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", [[weightArray objectAtIndex:row] description]];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 100;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:80];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@", weightArray[row]];
    
    return label;
}

-(void)calculateWeeklyWeightMeans:(NSNumber *)numberOfWeeks {
    
    // 1. Using the date the user created his account, generate the precedingSunday and followingSaturday variables.
    NSDate *createdAtDate = user.dateCreated;
    
        // Find out what day of the week it is
    int whichDay = (int)[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:createdAtDate] weekday];
    
        // Find out how days away from Sunday it is
    int numberOfDaysPassedSunday = (1 - whichDay) * -1;
    
        // Create an NSDate object that is the Sunday 00:00:00 preceding the earliest recorded weight, and use that to create an NSDate object that is the Saturday 23:59:59 following the earliest recorded weight.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[createdAtDate dateByAddingTimeInterval:((numberOfDaysPassedSunday * (60 * 60 * 24)) * -1)]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setSecond:0];
    [comps setMinute:0];
    [comps setHour:0];
    [comps setDay:[components day]];
    [comps setMonth:[components month]];
    [comps setYear:[components year]];
    
    NSDate *firstPrecedingSunday = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSDate *firstFollowingSaturday = [firstPrecedingSunday dateByAddingTimeInterval:((60 * 60 * 24 * 7) + ((60 * 60 * 24) - 1))];
    
    // 1. END
    
    // 2. Find the latest RecordedWeight record, and generate precedingSunday and followingSaturday variables.
    
    NSMutableArray *initialRecordedWeightsMutableArray = [[NSMutableArray alloc] initWithArray:recordedWeights];
    
    RecordedWeight *latestRecordedWeight = [[RecordedWeight alloc] initWithEntity:[NSEntityDescription entityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
    [latestRecordedWeight setDate:user.dateCreated];
    [latestRecordedWeight setWeight:user.initialWeight];
    
    for (RecordedWeight *tempRecordedWeight in initialRecordedWeightsMutableArray) {
        if ([latestRecordedWeight.date compare:tempRecordedWeight.date] == NSOrderedAscending) {
            latestRecordedWeight = tempRecordedWeight;
        }
    }
    
    NSLog(@"latestRecordedWeight = %@", latestRecordedWeight);
    
        // Find out what day of the week it is
    whichDay = (int)[[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:latestRecordedWeight.date] weekday];
    
        // Find out how days away from Sunday it is
    numberOfDaysPassedSunday = (1 - whichDay) * -1;
    
        // Create an NSDate object that is the Sunday 00:00:00 preceding the earliest recorded weight, and use that to create an NSDate object that is the Saturday 23:59:59 following the latest recorded weight.
    NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[latestRecordedWeight.date dateByAddingTimeInterval:((numberOfDaysPassedSunday * (60 * 60 * 24)) * -1)]];
    
    NSDateComponents *lastComps = [[NSDateComponents alloc] init];
    
    [lastComps setSecond:0];
    [lastComps setMinute:0];
    [lastComps setHour:0];
    [lastComps setDay:[lastComponents day]];
    [lastComps setMonth:[lastComponents month]];
    [lastComps setYear:[lastComponents year]];
    
    NSDate *lastPrecedingSunday = [[NSCalendar currentCalendar] dateFromComponents:lastComps];
    NSDate *lastFollowingSaturday = [lastPrecedingSunday dateByAddingTimeInterval:((60 * 60 * 24 * 7) + ((60 * 60 * 24) - 1))];
    
    // 2. END
    
    // 3. Calculate weekly weight averages, starting from the first week, and ending on the last week.
    
    NSDate *tempPrecedingSunday = firstPrecedingSunday;
    NSDate *tempFollowingSaturday = firstFollowingSaturday;
    NSMutableArray *weeklyWeightAverageArray = [NSMutableArray new];
    NSMutableArray *weeklyDateArray = [NSMutableArray new];
    
    int index = 0;
    while ([[tempPrecedingSunday dateByAddingTimeInterval:-(60 * 60 * 24 * 7)] compare:lastPrecedingSunday] != NSOrderedSame) {
        int count = 0;
        int totalWeight = 0;
        for (RecordedWeight *tempRecordedWeight in initialRecordedWeightsMutableArray) {
            if ([self checkIfBetweenDate:tempPrecedingSunday andDate:tempFollowingSaturday date:tempRecordedWeight.date] == YES) {
                count += 1;
                totalWeight += [tempRecordedWeight.weight intValue];
            }
        }
        
        float averageForWeek = 0;
        if (count == 0) {
            averageForWeek = 0;
        } else {
            averageForWeek = (float)totalWeight / (float)count;
        }
        
        NSLog(@"averageForWeek #%i = %f", index, averageForWeek);
        
        [weeklyWeightAverageArray addObject:[NSNumber numberWithFloat:averageForWeek]];
        [weeklyDateArray addObject:tempPrecedingSunday];
        
        tempPrecedingSunday = [tempPrecedingSunday dateByAddingTimeInterval:(60 * 60 * 24 * 7)];
        tempFollowingSaturday = [tempFollowingSaturday dateByAddingTimeInterval:(60 * 60 * 24 * 7)];
        index += 1;
    }
    
    // 3. END
    
    // 4. Store latest average value from weeklyWeightAverageArray in the 4th position of the arrayOfValues. If the average is 0 (records didn't exist that week), use the value from the previous week. Repeat if necessary untill beginning of array is reached. In this case use the value of the users initialWeight.
    int backwardCount = 0;
    if ([weeklyWeightAverageArray count] > 0) {
        backwardCount = (int)[weeklyWeightAverageArray count] - 1;
    }

    for (int i = 4 - 1; i >= 0; i--) {
        BOOL isSet = NO;
        while (isSet == NO && backwardCount >= 0) {
            if (weeklyWeightAverageArray[backwardCount] > 0) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMM d"];
                NSString *dateString = [dateFormatter stringFromDate:weeklyDateArray[backwardCount]];
                
                [arrayOfDates setObject:dateString atIndexedSubscript:i];
                [arrayOfValues setObject:weeklyWeightAverageArray[backwardCount] atIndexedSubscript:i];
                isSet = YES;
            }
            backwardCount -= 1;
        }
    }
    
    for (int i = 0; i < 4; i++) {
        NSLog(@"arrayOfValue[%i] = %@", i, arrayOfValues[i]);
        if ([[arrayOfValues objectAtIndex:i] integerValue] == 0) {
            [arrayOfValues setObject:user.initialWeight atIndexedSubscript:i];
            NSLog(@"user.initialWeight = %@", user.initialWeight);
        }
    }
    
    // 4. END
    
    [myGraph reloadGraph];
}

- (BOOL)checkIfBetweenDate:(NSDate *)earlierDate andDate:(NSDate *)laterDate date:(NSDate *)date
{
    // first check that we are later than the earlierDate.
    if ([date compare:earlierDate] == NSOrderedDescending) {
        
        // next check that we are earlier than the laterData
        if ( [date compare:laterDate] == NSOrderedAscending ) {
            return YES;
        }
    }
    
    // otherwise we are not
    return NO;
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[arrayOfValues objectAtIndex:index] floatValue];
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [arrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

-(IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cameraButtonTouched:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
    {
        // cancelled, nothing happen
        return;
    }
    
    // obtain a human-readable option string
    NSString *option = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([option isEqualToString:@"Take Photo"]) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
        }
    } else if ([option isEqualToString:@"Select Photo"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    cameraIconImageView.hidden = YES;
    imageInstructionLabel.hidden = YES;

    [myCameraButton setImage:chosenImage forState:UIControlStateNormal];
    [myCameraButton setImage:chosenImage forState:UIControlStateHighlighted];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    [user setValue:imageData forKey:@"userPhoto"];
    [coreDataStack saveContext];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)updateButtonTouched:(id)sender {
    // Check whether the users weight has already been recorded that day, and if so it deletes that record. Then it records a new weight and date recorded.
    
    [self fillRecordedWeightsArray];
    
    int i = 0;
    for (RecordedWeight *recordedWeight in recordedWeights) {
        i += 1;
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:recordedWeight.date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            [coreDataStack.managedObjectContext deleteObject:recordedWeight];
        }
    }
    
    RecordedWeight *weight = [NSEntityDescription insertNewObjectForEntityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext];
    weight.weight = [NSNumber numberWithInt:(int)[myPickerView selectedRowInComponent:0]];
    weight.date = [NSDate date];
    
    [coreDataStack saveContext];
    [self fillRecordedWeightsArray];
    [self calculateWeeklyWeightMeans:[NSNumber numberWithInt:4]];
    [myGraph reloadGraph];
    [myTableView reloadData];
}

- (void) fillRecordedWeightsArray {
    recordedWeights = [coreDataStack.managedObjectContext executeFetchRequest:[self recordedWeightFetchRequest] error:nil];
}

- (NSFetchRequest *)recordedWeightFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RecordedWeight"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

@end