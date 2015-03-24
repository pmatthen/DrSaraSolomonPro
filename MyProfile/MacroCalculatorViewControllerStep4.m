//
//  MacroCalculatorViewControllerStep2.m
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MacroCalculatorViewControllerStep4.h"
#import "MacroCalculatorDetails.h"
#import "CoreDataStack.h"
#import "User.h"
#import "RecordedWeight.h"
#import "Parse/Parse.h"

@interface MacroCalculatorViewControllerStep4 ()

@property NSArray *fatsArray;
@property CoreDataStack *coreDataStack;
@property NSArray *recordedWeights;
@property User *user;
@property BOOL is35;

@end

@implementation MacroCalculatorViewControllerStep4
@synthesize myPickerView, fatsArray, neat, bodyfatPercentage, results, proteinCalculations, coreDataStack, date, recordedWeights, user, is35;

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

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MACRO CALCULATOR";
    
    [self.view addSubview:titleLabel];
    
    fatsArray = [NSArray new];
    fatsArray = @[@15, @20, @25, @30, @35, @40];
    
    UILabel *stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 149, 60, 40)];
    if (is35) {
        stepLabel.frame = CGRectMake(55, 126, 60, 34);
    }
    stepLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
    stepLabel.textColor = [UIColor whiteColor];
    stepLabel.text = @"Step 4";
    [stepLabel sizeToFit];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(132, 163, 60, 40)];
    if (is35) {
        instructionsLabel.frame = CGRectMake(132, 138, 60, 34);
    }
    instructionsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:16];
    instructionsLabel.textColor = [UIColor whiteColor];
    instructionsLabel.text = @"ENTER FAT CALCULATION";
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [fatsArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@%%", [fatsArray[row] description]];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@%%", [fatsArray[row] description]];
    
    return label;
}

- (void) fillRecordedWeightsArray {
    recordedWeights = [coreDataStack.managedObjectContext executeFetchRequest:[self recordedWeightsRequest] error:nil];
}

- (NSFetchRequest *)recordedWeightsRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"RecordedWeight"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    return fetchRequest;
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

- (IBAction)calculateMacroButtonTouched:(id)sender {
    [self fillRecordedWeightsArray];
    
    NSMutableArray *initialRecordedWeightsMutableArray = [[NSMutableArray alloc] initWithArray:recordedWeights];
    
    RecordedWeight *latestRecordedWeight = [[RecordedWeight alloc] initWithEntity:[NSEntityDescription entityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext] insertIntoManagedObjectContext:coreDataStack.managedObjectContext];
    [latestRecordedWeight setDate:user.dateCreated];
    [latestRecordedWeight setWeight:user.initialWeight];
    
    for (RecordedWeight *tempRecordedWeight in initialRecordedWeightsMutableArray) {
        if ([latestRecordedWeight.date compare:tempRecordedWeight.date] == NSOrderedAscending) {
            latestRecordedWeight = tempRecordedWeight;
        }
    }
    
    MacroCalculatorDetails *details = [NSEntityDescription insertNewObjectForEntityForName:@"MacroCalculatorDetails" inManagedObjectContext:coreDataStack.managedObjectContext];
    details.activityLevel = [NSNumber numberWithInt:neat];
    details.bodyfat = [NSNumber numberWithInt:bodyfatPercentage];
    details.results = [NSNumber numberWithInt:results];
    details.proteinCalculation = [NSNumber numberWithFloat:proteinCalculations];
    details.fats = [NSNumber numberWithInt:(int) [myPickerView selectedRowInComponent:0]];
    details.latestWeight = latestRecordedWeight.weight;
    details.date = date;
    
    [coreDataStack saveContext];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
