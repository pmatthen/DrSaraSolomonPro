//
//  DailyTrackerViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 29/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "DailyTrackerViewController.h"
#import "DailyTrackerTableViewCell.h"
#import "AddFoodViewController.h"
#import "FoodTrackerItem.h"
#import "MacroCalculatorDetails.h"
#import "User.h"
#import "CoreDataStack.h"
#import "RecordedWeight.h"
#import "MacroCalculatorViewControllerStep1.h"
#import <FatSecretKit/FSServing.h>
#import <FatSecretKit/FSRecipeServings.h>

@interface DailyTrackerViewController () <UITableViewDataSource, UITableViewDelegate>

@property UIButton *addFoodButton;
@property UILabel *dateLabel;
@property float dateInterval;
@property NSMutableArray *foodTrackerItems;
@property NSDictionary *dataSource;
@property NSDate *selectedDate;
@property float caloriesConsumed;
@property float proteinsConsumed;
@property float fatsConsumed;
@property float carbsConsumed;
@property UILabel *caloriesConsumedLabel;
@property UILabel *proteinsConsumedLabel;
@property UILabel *fatsConsumedLabel;
@property UILabel *carbsConsumedLabel;
@property UILabel *caloriesAllowedLabel;
@property UILabel *proteinsAllowedLabel;
@property UILabel *fatsAllowedLabel;
@property UILabel *carbsAllowedLabel;
@property User *user;
@property CoreDataStack *coreDataStack;
@property NSArray *recordedMacroCalculatorDetails;
@property NSArray *recordedWeights;
@property BOOL isADF;
@property BOOL is35;
@property NSMutableArray *foodTrackerItemMutableArray;

@end

@implementation DailyTrackerViewController
@synthesize addFoodButton, rightArrowImageView, dateLabel, dateInterval, foodTrackerItems, dataSource, selectedDate, caloriesConsumed, proteinsConsumed, fatsConsumed, carbsConsumed, caloriesConsumedLabel, proteinsConsumedLabel, fatsConsumedLabel, carbsConsumedLabel, caloriesAllowedLabel, proteinsAllowedLabel, fatsAllowedLabel, carbsAllowedLabel, myTableView, user, coreDataStack, recordedMacroCalculatorDetails, calculateMacrosButton, recordedWeights, isADF, is35, foodTrackerItemMutableArray, recalculateMacrosButton;

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
    
    selectedDate = [NSDate date];
    isADF = FALSE;
    
    rightArrowImageView.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    dateInterval = 0;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"FEAST TRACKER";
    
    [self.view addSubview:titleLabel];
    
    UILabel *calorieLabel = [[UILabel alloc] init];
    calorieLabel.font = [UIFont fontWithName:@"Oswald" size:14];
    calorieLabel.textColor = [UIColor whiteColor];
    calorieLabel.text = @"PROTEIN (g)";
    [calorieLabel sizeToFit];
    calorieLabel.frame = CGRectMake(10, 185, calorieLabel.frame.size.width, calorieLabel.frame.size.height);
    if (is35) {
        calorieLabel.frame = CGRectMake(10, 156, calorieLabel.frame.size.width, calorieLabel.frame.size.height);
    }
    
    
    UILabel *proteinLabel = [[UILabel alloc] init];
    proteinLabel.font = [UIFont fontWithName:@"Oswald" size:14];
    proteinLabel.textColor = [UIColor whiteColor];
    proteinLabel.text = @"FAT (g)";
    [proteinLabel sizeToFit];
    proteinLabel.frame = CGRectMake(90, 185, proteinLabel.frame.size.width, proteinLabel.frame.size.height);
    if (is35) {
        proteinLabel.frame = CGRectMake(90, 156, proteinLabel.frame.size.width, proteinLabel.frame.size.height);
    }

    UILabel *fatLabel = [[UILabel alloc] init];
    fatLabel.font = [UIFont fontWithName:@"Oswald" size:14];
    fatLabel.textColor = [UIColor whiteColor];
    fatLabel.text = @"CARBS (g)";
    [fatLabel sizeToFit];
    fatLabel.frame = CGRectMake(170, 185, fatLabel.frame.size.width, fatLabel.frame.size.height);
    if (is35) {
        fatLabel.frame = CGRectMake(170, 156, fatLabel.frame.size.width, fatLabel.frame.size.height);
    }
    
    UILabel *carbsLabel = [[UILabel alloc] init];
    carbsLabel.font = [UIFont fontWithName:@"Oswald" size:14];
    carbsLabel.textColor = [UIColor whiteColor];
    carbsLabel.text = @"CALORIES";
    [carbsLabel sizeToFit];
    carbsLabel.frame = CGRectMake(250, 185, carbsLabel.frame.size.width, carbsLabel.frame.size.height);
    if (is35) {
        carbsLabel.frame = CGRectMake(250, 156, carbsLabel.frame.size.width, carbsLabel.frame.size.height);
    }
    
    caloriesConsumedLabel = [[UILabel alloc] init];
    caloriesConsumedLabel.font = [UIFont fontWithName:@"Oswald" size:28];
    caloriesConsumedLabel.textColor = [UIColor whiteColor];
    caloriesConsumedLabel.text = @"0";
    caloriesConsumedLabel.hidden = YES;
    caloriesConsumedLabel.userInteractionEnabled = NO;
    [caloriesConsumedLabel sizeToFit];
    
    proteinsConsumedLabel = [[UILabel alloc] init];
    proteinsConsumedLabel.font = [UIFont fontWithName:@"Oswald" size:28];
    proteinsConsumedLabel.textColor = [UIColor whiteColor];
    proteinsConsumedLabel.text = @"0";
    proteinsConsumedLabel.hidden = YES;
    proteinsConsumedLabel.userInteractionEnabled = NO;
    [proteinsConsumedLabel sizeToFit];
    
    fatsConsumedLabel = [[UILabel alloc] init];
    fatsConsumedLabel.font = [UIFont fontWithName:@"Oswald" size:28];
    fatsConsumedLabel.textColor = [UIColor whiteColor];
    fatsConsumedLabel.text = @"0";
    fatsConsumedLabel.hidden = YES;
    fatsConsumedLabel.userInteractionEnabled = NO;
    [fatsConsumedLabel sizeToFit];
    
    carbsConsumedLabel = [[UILabel alloc] init];
    carbsConsumedLabel.font = [UIFont fontWithName:@"Oswald" size:28];
    carbsConsumedLabel.textColor = [UIColor whiteColor];
    carbsConsumedLabel.text = @"0";
    carbsConsumedLabel.hidden = YES;
    carbsConsumedLabel.userInteractionEnabled = NO;
    [carbsConsumedLabel sizeToFit];
    
    addFoodButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 497, 320, 71)];
    if (is35) {
        [addFoodButton setFrame:CGRectMake(0, 420, 320, 60)];
    }
    [addFoodButton setImage:[UIImage imageNamed:@"Add_Food_Button@2x.png"] forState:UIControlStateNormal];
    [addFoodButton addTarget:self action:@selector(addFoodButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:calorieLabel];
    [self.view addSubview:proteinLabel];
    [self.view addSubview:fatLabel];
    [self.view addSubview:carbsLabel];
    [self.view addSubview:caloriesConsumedLabel];
    [self.view addSubview:proteinsConsumedLabel];
    [self.view addSubview:fatsConsumedLabel];
    [self.view addSubview:carbsConsumedLabel];
    [self.view addSubview:addFoodButton];
    
    caloriesAllowedLabel = [[UILabel alloc] init];
    caloriesAllowedLabel.font = [UIFont fontWithName:@"Oswald" size:30];
    caloriesAllowedLabel.textColor = [UIColor grayColor];
    caloriesAllowedLabel.text = @"0";
    caloriesAllowedLabel.hidden = YES;
    caloriesAllowedLabel.userInteractionEnabled = NO;
    [caloriesAllowedLabel sizeToFit];
    
    proteinsAllowedLabel = [[UILabel alloc] init];
    proteinsAllowedLabel.font = [UIFont fontWithName:@"Oswald" size:30];
    proteinsAllowedLabel.textColor = [UIColor grayColor];
    proteinsAllowedLabel.text = @"0";
    proteinsAllowedLabel.hidden = YES;
    proteinsAllowedLabel.userInteractionEnabled = NO;
    [proteinsAllowedLabel sizeToFit];
    
    fatsAllowedLabel = [[UILabel alloc] init];
    fatsAllowedLabel.font = [UIFont fontWithName:@"Oswald" size:30];
    fatsAllowedLabel.textColor = [UIColor grayColor];
    fatsAllowedLabel.text = @"0";
    fatsAllowedLabel.hidden = YES;
    fatsAllowedLabel.userInteractionEnabled = NO;
    [fatsAllowedLabel sizeToFit];
    
    carbsAllowedLabel = [[UILabel alloc] init];
    carbsAllowedLabel.font = [UIFont fontWithName:@"Oswald" size:30];
    carbsAllowedLabel.textColor = [UIColor grayColor];
    carbsAllowedLabel.text = @"0";
    carbsAllowedLabel.hidden = YES;
    carbsAllowedLabel.userInteractionEnabled = NO;
    [carbsAllowedLabel sizeToFit];
    
    [self.view addSubview:caloriesAllowedLabel];
    [self.view addSubview:proteinsAllowedLabel];
    [self.view addSubview:fatsAllowedLabel];
    [self.view addSubview:carbsAllowedLabel];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    dataSource = [self dataForMasterArray];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    NSDictionary *mealDictionary = dataSource;
    
    foodTrackerItemMutableArray = [NSMutableArray new];
    for (FoodTrackerItem *foodTrackerItem in [mealDictionary objectForKey:selectedMidnightDate]) {
        [foodTrackerItemMutableArray addObject:foodTrackerItem];
    }
    
    [myTableView reloadData];
    
    [self addDateLabelSubView:selectedDate];
    [self updateFeastTracker];
    
    if ([self checkMacroCalculation] == YES) {
        [self macrosCalculated];
    } else {
        [self macrosNotCalculated];
    }
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

- (void) macrosCalculated {
    calculateMacrosButton.hidden = YES;
    
    [self calculateCaloriesConsumedLabel];
    [self calculateProteinsConsumedLabel];
    [self calculateFatsConsumedLabel];
    [self calculateCarbsConsumedLabel];
    
    caloriesConsumedLabel.hidden = NO;
    proteinsConsumedLabel.hidden = NO;
    fatsConsumedLabel.hidden = NO;
    carbsConsumedLabel.hidden = NO;
    
    isADF = FALSE;
    [self calculateMacros];
    
    caloriesAllowedLabel.hidden = NO;
    proteinsAllowedLabel.hidden = NO;
    fatsAllowedLabel.hidden = NO;
    carbsAllowedLabel.hidden = NO;
}

- (void) macrosNotCalculated {
    calculateMacrosButton.hidden = NO;

    caloriesConsumedLabel.hidden = YES;
    proteinsConsumedLabel.hidden = YES;
    fatsConsumedLabel.hidden = YES;
    carbsConsumedLabel.hidden = YES;
    
    caloriesAllowedLabel.hidden = YES;
    proteinsAllowedLabel.hidden = YES;
    fatsAllowedLabel.hidden = YES;
    carbsAllowedLabel.hidden = YES;
}

-(BOOL)checkMacroCalculation {
    [self fillMacroCalculatorDetailsArray];
    
    for (MacroCalculatorDetails *tempMacroCalculatorDetails in recordedMacroCalculatorDetails) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempMacroCalculatorDetails.date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:dateInterval]];
        
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            return YES;
        }
    }
    
    return NO;
}

- (void) fillMacroCalculatorDetailsArray {
    recordedMacroCalculatorDetails = [coreDataStack.managedObjectContext executeFetchRequest:[self recordedMacroCalculationsRequest] error:nil];
}

- (NSFetchRequest *)recordedMacroCalculationsRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MacroCalculatorDetails"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

- (void) calculateMacros {
    [self fillMacroCalculatorDetailsArray];
    
    MacroCalculatorDetails *latestMacrosCalculatorDetails = [[MacroCalculatorDetails alloc] initWithEntity:[NSEntityDescription entityForName:@"MacroCalculatorDetails" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
    [latestMacrosCalculatorDetails setDate:user.dateCreated];
    [latestMacrosCalculatorDetails setBodyfat:[NSNumber numberWithInt:0]];
    [latestMacrosCalculatorDetails setActivityLevel:[NSNumber numberWithInt:0]];
    [latestMacrosCalculatorDetails setResults:[NSNumber numberWithInt:0]];
    [latestMacrosCalculatorDetails setProteinCalculation:[NSNumber numberWithInt:0]];
    [latestMacrosCalculatorDetails setFats:[NSNumber numberWithInt:0]];
    
    [self fillMacroCalculatorDetailsArray];
    
    for (MacroCalculatorDetails *tempMacroCalculatorDetails in recordedMacroCalculatorDetails) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempMacroCalculatorDetails.date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:dateInterval]];
        
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            latestMacrosCalculatorDetails = tempMacroCalculatorDetails;
        }
    }
    
    float maintenanceLevelCalories = [self maintenanceLevelCalories:[latestMacrosCalculatorDetails.latestWeight intValue] heightInInches:[user.height intValue] age:[user.age intValue] gender:[user.gender intValue] neat:[latestMacrosCalculatorDetails.activityLevel intValue]];
    
    float resultsFactor = 0.0;
    switch ([latestMacrosCalculatorDetails.results intValue]) {
        case 0:
            resultsFactor = 1.0;
            break;
        case 1:
            resultsFactor = 0.2;
            isADF = TRUE;
            break;
        case 2:
            resultsFactor = 0.25;
            isADF = TRUE;
            break;
        case 3:
            resultsFactor = 0.3;
            isADF = TRUE;
            break;
        case 4:
            resultsFactor = 0.35;
            isADF = TRUE;
            break;
        case 5:
            resultsFactor = 0.4;
            isADF = TRUE;
            break;
        case 6:
            resultsFactor = 0.45;
            isADF = TRUE;
            break;
        case 7:
            resultsFactor = 0.5;
            isADF = TRUE;
            break;
        case 8:
            resultsFactor = 0.9;
            break;
        case 9:
            resultsFactor = 0.85;
            break;
        default:
            break;
    }
    
    float proteinFactor = 1.0;
    switch ([latestMacrosCalculatorDetails.proteinCalculation intValue]) {
        case 0:
            proteinFactor = 1.0;
            break;
        case 1:
            proteinFactor = 1.1;
            break;
        case 2:
            proteinFactor = 1.2;
            break;
        case 3:
            proteinFactor = 1.3;
            break;
        case 4:
            proteinFactor = 1.4;
            break;
        default:
            break;
    }
    
    float fatsFactor = 0;
    switch ([latestMacrosCalculatorDetails.fats intValue]) {
        case 0:
            fatsFactor = .15;
            break;
        case 1:
            fatsFactor = .20;
            break;
        case 2:
            fatsFactor = .25;
            break;
        case 3:
            fatsFactor = .30;
            break;
        case 4:
            fatsFactor = .35;
            break;
        case 5:
            fatsFactor = .40;
            break;
        default:
            break;
    }
    
    float caloriesAllowed = (float)maintenanceLevelCalories * (float)resultsFactor;
    
    [caloriesAllowedLabel removeFromSuperview];
    
    caloriesAllowedLabel.text = [NSString stringWithFormat:@"%.0f", caloriesAllowed];
    [caloriesAllowedLabel sizeToFit];
    caloriesAllowedLabel.frame = CGRectMake(250, 27, caloriesAllowedLabel.frame.size.width, caloriesAllowedLabel.frame.size.height);
    if (is35) {
        caloriesAllowedLabel.frame = CGRectMake(250, 26, caloriesAllowedLabel.frame.size.width, caloriesAllowedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:caloriesAllowedLabel];
    
    float proteinsAllowed = [latestMacrosCalculatorDetails.latestWeight floatValue] * proteinFactor;
    
    [proteinsAllowedLabel removeFromSuperview];
    
    proteinsAllowedLabel.text = [NSString stringWithFormat:@"%.0f", proteinsAllowed];
    if (isADF) {
        proteinsAllowedLabel.text = @"-";
    }
    [proteinsAllowedLabel sizeToFit];
    proteinsAllowedLabel.frame = CGRectMake(10, 27, proteinsAllowedLabel.frame.size.width, proteinsAllowedLabel.frame.size.height);
    if (is35) {
        proteinsAllowedLabel.frame = CGRectMake(10, 26, proteinsAllowedLabel.frame.size.width, proteinsAllowedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:proteinsAllowedLabel];
    
    float fatsAllowed = (caloriesAllowed * fatsFactor)/9;
    
    [fatsAllowedLabel removeFromSuperview];
    
    fatsAllowedLabel.text = [NSString stringWithFormat:@"%.0f", fatsAllowed];
    if (isADF) {
        fatsAllowedLabel.text = @"-";
    }
    [fatsAllowedLabel sizeToFit];
    fatsAllowedLabel.frame = CGRectMake(90, 27, fatsAllowedLabel.frame.size.width, fatsAllowedLabel.frame.size.height);
    if (is35) {
        fatsAllowedLabel.frame = CGRectMake(90, 26, fatsAllowedLabel.frame.size.width, fatsAllowedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:fatsAllowedLabel];
    
    float carbsAllowed = (caloriesAllowed - (proteinsAllowed * 4) - (caloriesAllowed * fatsFactor))/4;
    
    carbsAllowedLabel.text = [NSString stringWithFormat:@"%.0f", carbsAllowed];
    if (isADF) {
        carbsAllowedLabel.text = @"-";
    }
    [carbsAllowedLabel sizeToFit];
    carbsAllowedLabel.frame = CGRectMake(170, 27, carbsAllowedLabel.frame.size.width, carbsAllowedLabel.frame.size.height);
    if (is35) {
        carbsAllowedLabel.frame = CGRectMake(170, 26, carbsAllowedLabel.frame.size.width, carbsAllowedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:carbsAllowedLabel];
}

- (float)maintenanceLevelCalories:(int)weight heightInInches:(int)height age:(int)age gender:(int)gender neat:(int)neat {
    
    MacroCalculatorDetails *latestMacroCalculatorDetails = [[MacroCalculatorDetails alloc] initWithEntity:[NSEntityDescription entityForName:@"MacroCalculatorDetails" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
    [latestMacroCalculatorDetails setActivityLevel:user.activityFactor];
    [latestMacroCalculatorDetails setDate:user.dateCreated];
    for (MacroCalculatorDetails *tempMacroCalculatorDetails in recordedMacroCalculatorDetails) {
        if ([latestMacroCalculatorDetails.date compare:tempMacroCalculatorDetails.date] == NSOrderedAscending) {
            latestMacroCalculatorDetails = tempMacroCalculatorDetails;
        }
    }
    
    float neatValue = 0;
    neat = [latestMacroCalculatorDetails.activityLevel intValue];
    switch (neat) {
        case 0:
            neatValue = 1.2;
            break;
        case 1:
            neatValue = 1.375;
            break;
        case 2:
            neatValue = 1.55;
            break;
        case 3:
            neatValue = 1.725;
            break;
        case 4:
            neatValue = 1.9;
            break;
        default:
            break;
    }
    
    NSMutableArray *initialRecordedWeightsMutableArray = [[NSMutableArray alloc] initWithArray:recordedWeights];
    
    RecordedWeight *latestRecordedWeight = [[RecordedWeight alloc] initWithEntity:[NSEntityDescription entityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
    [latestRecordedWeight setDate:user.dateCreated];
    [latestRecordedWeight setWeight:user.initialWeight];
    
    for (RecordedWeight *tempRecordedWeight in initialRecordedWeightsMutableArray) {
        if ([latestRecordedWeight.date compare:tempRecordedWeight.date] == NSOrderedAscending) {
            latestRecordedWeight = tempRecordedWeight;
        }
    }
    
    //Include neat into calculations with array.
    if (gender == 0) {
        return (655 + (4.35 * weight) + (4.7 * height) - (4.7 * age)) * neatValue;
    } else {
        NSLog(@"maintenance level calories = %.0f", ((66 + (6.23 * weight) + (12.7 * height) - (6.8 * age)) * neatValue));
        return (66 + (6.23 * weight) + (12.7 * height) - (6.8 * age)) * neatValue;
    }
}

-(void)addDateLabelSubView:(NSDate *)date {
    [dateLabel removeFromSuperview];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    NSString *dayDate = [[formatter stringFromDate:date] uppercaseString];
    [formatter setDateFormat:@"MMMM"];
    NSString *monthDate = [[formatter stringFromDate:date] uppercaseString];
    [formatter setDateFormat:@"dd, yyyy"];
    NSString *restOfDate = [[formatter stringFromDate:date] uppercaseString];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 67, 200, 50)];
    if (is35) {
        dateLabel.frame = CGRectMake(100, 57, 200, 42);
    }
    dateLabel.font = [UIFont fontWithName:@"Oswald" size:15];
    dateLabel.textColor = [UIColor whiteColor];
    
     NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if ([today day] == [otherDay day] &&
        [today month] == [otherDay month] &&
        [today year] == [otherDay year] &&
        [today era] == [otherDay era]) {
        dateLabel.text = [NSString stringWithFormat:@"TODAY  |  %@, %@ %@", dayDate, monthDate, restOfDate];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"%@, %@ %@", dayDate, monthDate, restOfDate];
    }
    
    [dateLabel sizeToFit];
    
    float xPosDate = (((276 - 45) - dateLabel.frame.size.width)/ 2) + 45;
    
    dateLabel.frame = CGRectMake(xPosDate, dateLabel.frame.origin.y, dateLabel.frame.size.width, dateLabel.frame.size.height);
    
    [self.view addSubview:dateLabel];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    selectedDate = [calendar dateFromComponents:otherDay];
    
    [self calculateCaloriesConsumedLabel];
    [self calculateProteinsConsumedLabel];
    [self calculateFatsConsumedLabel];
    [self calculateCarbsConsumedLabel];
}

- (void) calculateCaloriesConsumedLabel {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    
    caloriesConsumed = 0;
    if ([dataSource objectForKey:selectedMidnightDate] != nil) {
        for (FoodTrackerItem *foodTrackerItem in [dataSource objectForKey:selectedMidnightDate]) {
            caloriesConsumed += ((float)[foodTrackerItem.numberOfServings intValue] * [foodTrackerItem.caloriesPerServing floatValue]);
        }
    }
    
    [caloriesConsumedLabel removeFromSuperview];
    
    caloriesConsumedLabel.text = [NSString stringWithFormat:@"%.0f", caloriesConsumed];
    [caloriesConsumedLabel sizeToFit];
//    caloriesConsumedLabel.frame = CGRectMake(250, 100, caloriesConsumedLabel.frame.size.width, caloriesConsumedLabel.frame.size.height);
//    if (is35) {
//        caloriesConsumedLabel.frame = CGRectMake(250, 85, caloriesConsumedLabel.frame.size.width, caloriesConsumedLabel.frame.size.height);
//    }
//    [self.view addSubview:caloriesConsumedLabel];
    
    caloriesConsumedLabel.frame = CGRectMake(250, -4, caloriesConsumedLabel.frame.size.width, caloriesConsumedLabel.frame.size.height);
    if (is35) {
        caloriesConsumedLabel.frame = CGRectMake(250, -3, caloriesConsumedLabel.frame.size.width, caloriesConsumedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:caloriesConsumedLabel];
}

- (void) calculateProteinsConsumedLabel {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    
    proteinsConsumed = 0;
    if ([dataSource objectForKey:selectedMidnightDate] != nil) {
        for (FoodTrackerItem *foodTrackerItem in [dataSource objectForKey:selectedMidnightDate]) {
            proteinsConsumed += ((float)[foodTrackerItem.numberOfServings intValue] * [foodTrackerItem.proteinsPerServing floatValue]);
        }
    }
    
    [proteinsConsumedLabel removeFromSuperview];
    
    proteinsConsumedLabel.text = [NSString stringWithFormat:@"%.0f", proteinsConsumed];
    [proteinsConsumedLabel sizeToFit];
    proteinsConsumedLabel.frame = CGRectMake(10, -4, proteinsConsumedLabel.frame.size.width, proteinsConsumedLabel.frame.size.height);
    if (is35) {
        proteinsConsumedLabel.frame = CGRectMake(10, -3, proteinsConsumedLabel.frame.size.width, proteinsConsumedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:proteinsConsumedLabel];
}

- (void) calculateFatsConsumedLabel {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    
    fatsConsumed = 0;
    if ([dataSource objectForKey:selectedMidnightDate] != nil) {
        for (FoodTrackerItem *foodTrackerItem in [dataSource objectForKey:selectedMidnightDate]) {
            fatsConsumed += ((float)[foodTrackerItem.numberOfServings intValue] * [foodTrackerItem.fatsPerServing floatValue]);
        }
    }
    
    [fatsConsumedLabel removeFromSuperview];
    
    fatsConsumedLabel.text = [NSString stringWithFormat:@"%.0f", fatsConsumed];
    [fatsConsumedLabel sizeToFit];
    fatsConsumedLabel.frame = CGRectMake(90, -4, fatsConsumedLabel.frame.size.width, fatsConsumedLabel.frame.size.height);
    if (is35) {
        fatsConsumedLabel.frame = CGRectMake(90, -3, fatsConsumedLabel.frame.size.width, fatsConsumedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:fatsConsumedLabel];
}

- (void) calculateCarbsConsumedLabel {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    
    carbsConsumed = 0;
    if ([dataSource objectForKey:selectedMidnightDate] != nil) {
        for (FoodTrackerItem *foodTrackerItem in [dataSource objectForKey:selectedMidnightDate]) {
            carbsConsumed += ((float)[foodTrackerItem.numberOfServings intValue] * [foodTrackerItem.carbsPerServing floatValue]);
        }
    }
    
    [carbsConsumedLabel removeFromSuperview];
    
    carbsConsumedLabel.text = [NSString stringWithFormat:@"%.0f", carbsConsumed];
    [carbsConsumedLabel sizeToFit];
    carbsConsumedLabel.frame = CGRectMake(170, -4, carbsConsumedLabel.frame.size.width, carbsConsumedLabel.frame.size.height);
    if (is35) {
        carbsConsumedLabel.frame = CGRectMake(170, -3, carbsConsumedLabel.frame.size.width, carbsConsumedLabel.frame.size.height);
    }
    [recalculateMacrosButton addSubview:carbsConsumedLabel];
}

- (NSDictionary *) dataForMasterArray {
    
    [self populateArrayWithFoodTrackerItems];

    NSDictionary *myDataSource = [[NSDictionary alloc] init];
    myDataSource = [self dataForMealArray];

    return myDataSource;
}

- (NSMutableDictionary *) dataForMealArray {
    
    NSMutableDictionary *myDataSource = [[NSMutableDictionary alloc] init];
    
    if ([foodTrackerItems count] > 0) {
        for (int i = 0; i < [foodTrackerItems count]; i++) {
            FoodTrackerItem *foodTrackerItem = foodTrackerItems[i];
            NSDate *date = user.dateCreated;
            if (foodTrackerItem.date != nil) {
                date = foodTrackerItem.date;
            }
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
            [components setHour:0];
            
            NSString *midnightDate = [[calendar dateFromComponents:components] description];
            NSMutableArray *section = [myDataSource objectForKey:midnightDate];
            
            if (!section) {
                section = [[NSMutableArray alloc] init];
                [myDataSource setObject:section forKey:midnightDate];
            }
            [section addObject:foodTrackerItem];
        }
    }

    return myDataSource;
}

- (void) populateArrayWithFoodTrackerItems {
    // Loads all foodTrackItem objects into an Array in descending order of date created
    
    [foodTrackerItems removeAllObjects];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    foodTrackerItems = [NSMutableArray arrayWithArray:[coreDataStack.managedObjectContext executeFetchRequest:[self foodTrackerItemFetchRequest] error:nil]];
}

- (NSFetchRequest *) foodTrackerItemFetchRequest {
    // Just a fetchRequest.
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FoodTrackerItem"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyTrackerTableViewCell *cell = (DailyTrackerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FeastCell"];
    
    FoodTrackerItem *foodTrackerItem = foodTrackerItemMutableArray[indexPath.row];
    
    UIView *dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [dividerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *numberOfServingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 30, 38)];
    if (is35) {
        numberOfServingsLabel.frame = CGRectMake(10, 6, 30, 30);
    }
    numberOfServingsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    numberOfServingsLabel.textColor = [UIColor whiteColor];
    numberOfServingsLabel.textAlignment = NSTextAlignmentCenter;
    numberOfServingsLabel.adjustsFontSizeToFitWidth = YES;
    if (foodTrackerItem.servingAmount > 0) {
        numberOfServingsLabel.text = [NSString stringWithFormat:@"%@", ([NSNumber numberWithFloat:([foodTrackerItem.numberOfServings floatValue] * [foodTrackerItem.servingAmount floatValue])])];
    } else {
        numberOfServingsLabel.text = [NSString stringWithFormat:@"%@", foodTrackerItem.numberOfServings];
    }
    
    UILabel *servingUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 35, 20)];
    if (is35) {
        servingUnitLabel.frame = CGRectMake(10, 24, 35, 17);
    }
    servingUnitLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
    servingUnitLabel.textColor = [UIColor whiteColor];
    servingUnitLabel.adjustsFontSizeToFitWidth = YES;
    servingUnitLabel.textAlignment = NSTextAlignmentCenter;
    servingUnitLabel.text = [NSString stringWithFormat:@"%@", foodTrackerItem.servingUnit];
    
    UILabel *foodTrackerItemDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 7, 220, 38)];
    if (is35) {
        foodTrackerItemDetailLabel.frame = CGRectMake(45, 6, 220, 32);
    }
    [foodTrackerItemDetailLabel setAdjustsFontSizeToFitWidth:YES];
    foodTrackerItemDetailLabel.textAlignment = NSTextAlignmentCenter;
    foodTrackerItemDetailLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    foodTrackerItemDetailLabel.textColor = [UIColor whiteColor];
    foodTrackerItemDetailLabel.adjustsFontSizeToFitWidth = YES;
    foodTrackerItemDetailLabel.text = [NSString stringWithFormat:@"%@",[foodTrackerItem.name lowercaseString]];
    
    UILabel *calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(272, 10, 48, 38)];
    if (is35) {
        calorieLabel.frame = CGRectMake(272, 10, 48, 32);
    }
    calorieLabel.font = [UIFont fontWithName:@"Oswald" size:18];
    calorieLabel.textColor = [UIColor whiteColor];
    calorieLabel.adjustsFontSizeToFitWidth = YES;
    calorieLabel.text = [NSString stringWithFormat:@"%.0f", ([foodTrackerItem.caloriesPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
    [calorieLabel sizeToFit];
    
    UILabel *proteinLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 70, 10)];
    if (is35) {
        proteinLabel.frame = CGRectMake(80, 31, 70, 8);
    }
    proteinLabel.font = [UIFont fontWithName:@"Oswald" size:10];
    proteinLabel.textColor = [UIColor whiteColor];
    proteinLabel.adjustsFontSizeToFitWidth = YES;
    proteinLabel.text = [NSString stringWithFormat:@"P:%.0f", ([foodTrackerItem.proteinsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
    
    UILabel *fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 35, 70, 10)];
    if (is35) {
        fatLabel.frame = CGRectMake(160, 31, 70, 8);
    }
    fatLabel.font = [UIFont fontWithName:@"Oswald" size:10];
    fatLabel.textColor = [UIColor whiteColor];
    fatLabel.adjustsFontSizeToFitWidth = YES;
    fatLabel.text = [NSString stringWithFormat:@"F:%.0f", ([foodTrackerItem.fatsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
    
    UILabel *carbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 35, 70, 10)];
    if (is35) {
        carbsLabel.frame = CGRectMake(240, 31, 70, 8);
    }
    carbsLabel.font = [UIFont fontWithName:@"Oswald" size:10];
    carbsLabel.textColor = [UIColor whiteColor];
    carbsLabel.adjustsFontSizeToFitWidth = YES;
    carbsLabel.text = [NSString stringWithFormat:@"C:%.0f", ([foodTrackerItem.carbsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (is35) {
        [containerView setFrame:CGRectMake(0, 0, 320, 42)];
    }
    
    [containerView addSubview:dividerView];
    [containerView addSubview:numberOfServingsLabel];
    [containerView addSubview:servingUnitLabel];
    [containerView addSubview:foodTrackerItemDetailLabel];
    [containerView addSubview:calorieLabel];
    [containerView addSubview:proteinLabel];
    [containerView addSubview:fatLabel];
    [containerView addSubview:carbsLabel];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    [cell.contentView addSubview:containerView];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [foodTrackerItemMutableArray count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *eventToDelete = [coreDataStack.managedObjectContext objectWithID:[[foodTrackerItemMutableArray objectAtIndex:indexPath.row] objectID]];
        [coreDataStack.managedObjectContext deleteObject:eventToDelete];
        [foodTrackerItemMutableArray removeObjectAtIndex:indexPath.row];
        [coreDataStack saveContext];
        [myTableView reloadData];
    }
}

-(void)updateFeastTracker {
/*
 
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    NSDictionary *mealDictionary = dataSource;
    
    for (UIView *view in myScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int heightOfScrollView = 0;
    if ([mealDictionary objectForKey:selectedMidnightDate] != nil) {
        for (FoodTrackerItem *foodTrackerItem in [mealDictionary objectForKey:selectedMidnightDate]) {
            if (is35) {
                heightOfScrollView += 42;
            } else {
                heightOfScrollView += 50;
            }
            [myScrollView setContentSize:CGSizeMake(320, heightOfScrollView)];
            
            UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 11)];
            [dividerImageView setImage:[UIImage imageNamed:@"divider@2x.png"]];
            
            UILabel *numberOfServingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 30, 38)];
            if (is35) {
                numberOfServingsLabel.frame = CGRectMake(10, 10, 30, 30);
            }
            numberOfServingsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
            numberOfServingsLabel.textColor = [UIColor whiteColor];
            numberOfServingsLabel.textAlignment = NSTextAlignmentCenter;
            if (foodTrackerItem.servingAmount > 0) {
                numberOfServingsLabel.text = [NSString stringWithFormat:@"%@", ([NSNumber numberWithFloat:([foodTrackerItem.numberOfServings floatValue] * [foodTrackerItem.servingAmount floatValue])])];
            } else {
                numberOfServingsLabel.text = [NSString stringWithFormat:@"%@", foodTrackerItem.numberOfServings];
            }
            
            UILabel *servingUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 36, 35, 20)];
            if (is35) {
                servingUnitLabel.frame = CGRectMake(10, 30, 35, 17);
            }
            servingUnitLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            servingUnitLabel.textColor = [UIColor whiteColor];
            servingUnitLabel.textAlignment = NSTextAlignmentCenter;
            servingUnitLabel.text = [NSString stringWithFormat:@"%@", foodTrackerItem.servingUnit];
            
            UILabel *foodTrackerItemDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 12, 220, 38)];
            if (is35) {
                foodTrackerItemDetailLabel.frame = CGRectMake(45, 10, 220, 32);
            }
            [foodTrackerItemDetailLabel setAdjustsFontSizeToFitWidth:YES];
            foodTrackerItemDetailLabel.textAlignment = NSTextAlignmentCenter;
            foodTrackerItemDetailLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
            foodTrackerItemDetailLabel.textColor = [UIColor whiteColor];
            foodTrackerItemDetailLabel.text = [NSString stringWithFormat:@"%@",[foodTrackerItem.name lowercaseString]];
            
            UILabel *calorieLabel = [[UILabel alloc] initWithFrame:CGRectMake(272, 17, 48, 38)];
            if (is35) {
                calorieLabel.frame = CGRectMake(272, 14, 48, 32);
            }
            calorieLabel.font = [UIFont fontWithName:@"Oswald" size:18];
            calorieLabel.textColor = [UIColor whiteColor];
            calorieLabel.text = [NSString stringWithFormat:@"%.0f", ([foodTrackerItem.caloriesPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
            [calorieLabel sizeToFit];
            
            UILabel *proteinLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 42, 70, 10)];
            if (is35) {
                proteinLabel.frame = CGRectMake(80, 35, 70, 8);
            }
            proteinLabel.font = [UIFont fontWithName:@"Oswald" size:10];
            proteinLabel.textColor = [UIColor whiteColor];
            proteinLabel.text = [NSString stringWithFormat:@"P:%.0f", ([foodTrackerItem.proteinsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
            
            UILabel *fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 42, 70, 10)];
            if (is35) {
                fatLabel.frame = CGRectMake(160, 35, 70, 8);
            }
            fatLabel.font = [UIFont fontWithName:@"Oswald" size:10];
            fatLabel.textColor = [UIColor whiteColor];
            fatLabel.text = [NSString stringWithFormat:@"F:%.0f", ([foodTrackerItem.fatsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
            
            UILabel *carbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 42, 70, 10)];
            if (is35) {
                carbsLabel.frame = CGRectMake(240, 35, 70, 8);
            }
            carbsLabel.font = [UIFont fontWithName:@"Oswald" size:10];
            carbsLabel.textColor = [UIColor whiteColor];
            carbsLabel.text = [NSString stringWithFormat:@"C:%.0f", ([foodTrackerItem.carbsPerServing floatValue] * [foodTrackerItem.numberOfServings intValue])];
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, heightOfScrollView - 50, 320, 50)];
            if (is35) {
                [containerView setFrame:CGRectMake(0, heightOfScrollView - 42, 320, 42)];
            }
            
            [containerView addSubview:dividerImageView];
            [containerView addSubview:numberOfServingsLabel];
            [containerView addSubview:servingUnitLabel];
            [containerView addSubview:foodTrackerItemDetailLabel];
            [containerView addSubview:calorieLabel];
            [containerView addSubview:proteinLabel];
            [containerView addSubview:fatLabel];
            [containerView addSubview:carbsLabel];
            
            [myScrollView addSubview:containerView];
        }
    } else {
        for (UIView *view in myScrollView.subviews) {
            [view removeFromSuperview];
        }
        [myScrollView setContentSize:CGSizeMake(320, heightOfScrollView)];
    }
 */
}

-(void) addFoodButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"AddFoodSegue" sender:self];
}

- (IBAction)dateButtonPrevious:(id)sender {
    dateInterval = dateInterval - (24*60*60);
    [self addDateLabelSubView:[NSDate dateWithTimeIntervalSinceNow:dateInterval]];
    dataSource = [self dataForMasterArray];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
    [components setHour:0];
    
    NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
    NSDictionary *mealDictionary = dataSource;
    
    foodTrackerItemMutableArray = [NSMutableArray new];
    for (FoodTrackerItem *foodTrackerItem in [mealDictionary objectForKey:selectedMidnightDate]) {
        [foodTrackerItemMutableArray addObject:foodTrackerItem];
    }
    
    [myTableView reloadData];
    [self updateFeastTracker];
    
    if ([self checkMacroCalculation] == YES) {
        [self macrosCalculated];
    } else {
        [self macrosNotCalculated];
    }
}

- (IBAction)dateButtonNext:(id)sender {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:(dateInterval + (24*60*60))]];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if (([today day] + 1) == [otherDay day] &&
        [today month] == [otherDay month] &&
        [today year] == [otherDay year] &&
        [today era] == [otherDay era]) {
    } else {
        dateInterval = dateInterval + (24*60*60);
        [self addDateLabelSubView:[NSDate dateWithTimeIntervalSinceNow:dateInterval]];
        
        dataSource = [self dataForMasterArray];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:selectedDate];
        [components setHour:0];
        
        NSString *selectedMidnightDate = [[calendar dateFromComponents:components] description];
        NSDictionary *mealDictionary = dataSource;
        
        foodTrackerItemMutableArray = [NSMutableArray new];
        for (FoodTrackerItem *foodTrackerItem in [mealDictionary objectForKey:selectedMidnightDate]) {
            [foodTrackerItemMutableArray addObject:foodTrackerItem];
        }
        
        [myTableView reloadData];
        [self updateFeastTracker];
    }
    
    if ([self checkMacroCalculation] == YES) {
        [self macrosCalculated];
    } else {
        [self macrosNotCalculated];
    }
}

- (IBAction)calculateMacroButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"CalculatorSegue" sender:self];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)recalculateMacrosButton:(id)sender {
    [self fillMacroCalculatorDetailsArray];
    
    for (MacroCalculatorDetails *tempMacroCalculatorDetails in recordedMacroCalculatorDetails) {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempMacroCalculatorDetails.date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate dateWithTimeIntervalSinceNow:dateInterval]];
        
        if([today day] == [otherDay day] &&
           [today month] == [otherDay month] &&
           [today year] == [otherDay year] &&
           [today era] == [otherDay era]) {
            [coreDataStack.managedObjectContext deleteObject:tempMacroCalculatorDetails];
            [coreDataStack saveContext];
            [self performSegueWithIdentifier:@"CalculatorSegue" sender:self];
        }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CalculatorSegue"]) {
        MacroCalculatorViewControllerStep1 *myMacroCalculatorViewControllerStep1 = (MacroCalculatorViewControllerStep1 *) segue.destinationViewController;
        myMacroCalculatorViewControllerStep1.date = [NSDate dateWithTimeIntervalSinceNow:dateInterval];
    }
    if ([segue.identifier isEqualToString:@"AddFoodSegue"]) {
        AddFoodViewController *addFoodViewController = (AddFoodViewController *) segue.destinationViewController;
        addFoodViewController.trackerDate = [NSDate dateWithTimeIntervalSinceNow:dateInterval];
    }
}

@end
