//
//  IngredientDetailViewController.m
//  MyProfile
//
//  Created by Apple on 22/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "IngredientDetailViewController.h"
#import <FatSecretKit/FSClient.h>
#import <FatSecretKit/FSServing.h>
#import "CoreDataStack.h"
#import "FoodTrackerItem.h"

@interface IngredientDetailViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    FSFood *myFood;
    
    NSNumber *calories;
    NSNumber *fats;
    NSNumber *saturatedFats;
    NSNumber *cholesterol;
    NSNumber *sodium;
    NSNumber *carbs;
    NSNumber *fiber;
    NSNumber *sugars;
    NSNumber *protein;
    
    float numberOfServings;
    
    int indexForGRatio;
    int indexForMlRatio;
    int indexForOzRatio;
    
    NSMutableArray *foodServingsInfoArray;
    
    NSMutableArray *isUnitPresentArray;
    NSMutableArray *unitsArray;
    NSMutableArray *updatedUnitsArray;
    NSMutableArray *integerArray;
    NSMutableArray *fractionArray;
    
    UILabel *calorieValueLabel;
    UILabel *totalFatValueLabel;
    UILabel *satFatValueLabel;
    UILabel *cholesterolValueLabel;
    UILabel *sodiumValueLabel;
    UILabel *carbsValueLabel;
    UILabel *fiberValueLabel;
    UILabel *sugarsValueLabel;
    UILabel *proteinValueLabel;
    
    BOOL gDone;
    BOOL mlDone;
    BOOL ozDone;
}

@end

@implementation IngredientDetailViewController
@synthesize ingredientNameLabel, myPickerView, nutritionView, myFood, trackerDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    indexForGRatio = -1;
    indexForMlRatio = -1;
    indexForOzRatio = -1;
    
    isUnitPresentArray = [[NSMutableArray alloc] initWithArray:@[@0, @0, @0]];
    unitsArray = [NSMutableArray new];
    updatedUnitsArray = [NSMutableArray new];
    integerArray = [NSMutableArray new];
    fractionArray = [[NSMutableArray alloc] initWithArray:@[@"-", @"1/8", @"1/4", @"1/3", @"1/2", @"2/3", @"3/4"]];
    
    for (int i = 0; i < 501; i++) {
        [integerArray addObject:[NSNumber numberWithInt:i]];
    }

    [[FSClient sharedClient] getFood:myFood.identifier completion:^(FSFood *food) {
        myFood = food;
        
        [self configureFoodName];
        [self fillUnitsArray];
        
        [myPickerView selectRow:3 inComponent:0 animated:NO];
        [self interpretPickerView];
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"ADD INGREDIENT";
    
    [self.view addSubview:titleLabel];
    
    [self configureNutritionView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void) configureNutritionView {
    UILabel *calorieLabel = [[UILabel alloc] init];
    calorieLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    calorieLabel.textColor = [UIColor whiteColor];
    calorieLabel.text = @"CALORIES";
    [calorieLabel sizeToFit];
    [calorieLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) - (calorieLabel.frame.size.width))/2, 20, calorieLabel.frame.size.width, calorieLabel.frame.size.height)];
    
    UILabel *totalFatLabel = [[UILabel alloc] init];
    totalFatLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    totalFatLabel.textColor = [UIColor whiteColor];
    totalFatLabel.text = @"TOTAL FAT";
    [totalFatLabel sizeToFit];
    [totalFatLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10, 20, totalFatLabel.frame.size.width, totalFatLabel.frame.size.height)];
    
    UILabel *satFatLabel = [[UILabel alloc] init];
    satFatLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    satFatLabel.textColor = [UIColor grayColor];
    satFatLabel.text = @"SAT FAT";
    [satFatLabel sizeToFit];
    [satFatLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 20, totalFatLabel.frame.origin.y + totalFatLabel.frame.size.height + 5, satFatLabel.frame.size.width, satFatLabel.frame.size.height)];
    
    UILabel *cholesterolLabel = [[UILabel alloc] init];
    cholesterolLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    cholesterolLabel.textColor = [UIColor whiteColor];
    cholesterolLabel.text = @"CHOLEST";
    [cholesterolLabel sizeToFit];
    [cholesterolLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10, satFatLabel.frame.origin.y + satFatLabel.frame.size.height + 5, cholesterolLabel.frame.size.width, cholesterolLabel.frame.size.height)];
    
    UILabel *sodiumLabel = [[UILabel alloc] init];
    sodiumLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    sodiumLabel.textColor = [UIColor whiteColor];
    sodiumLabel.text = @"SODIUM";
    [sodiumLabel sizeToFit];
    [sodiumLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10, cholesterolLabel.frame.origin.y + cholesterolLabel.frame.size.height + 5, sodiumLabel.frame.size.width, sodiumLabel.frame.size.height)];
    
    UILabel *carbsLabel = [[UILabel alloc] init];
    carbsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    carbsLabel.textColor = [UIColor whiteColor];
    carbsLabel.text = @"CARBS";
    [carbsLabel sizeToFit];
    [carbsLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 10, 20, carbsLabel.frame.size.width, carbsLabel.frame.size.height)];
    
    UILabel *fiberLabel = [[UILabel alloc] init];
    fiberLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    fiberLabel.textColor = [UIColor grayColor];
    fiberLabel.text = @"FIBER";
    [fiberLabel sizeToFit];
    [fiberLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 20, carbsLabel.frame.origin.y + carbsLabel.frame.size.height + 5, fiberLabel.frame.size.width, fiberLabel.frame.size.height)];
    
    UILabel *sugarsLabel = [[UILabel alloc] init];
    sugarsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    sugarsLabel.textColor = [UIColor grayColor];
    sugarsLabel.text = @"SUGARS";
    [sugarsLabel sizeToFit];
    [sugarsLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 20, fiberLabel.frame.origin.y + fiberLabel.frame.size.height + 5, sugarsLabel.frame.size.width, sugarsLabel.frame.size.height)];
    
    UILabel *proteinLabel = [[UILabel alloc] init];
    proteinLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    proteinLabel.textColor = [UIColor whiteColor];
    proteinLabel.text = @"PROTEIN";
    [proteinLabel sizeToFit];
    [proteinLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 10, sugarsLabel.frame.origin.y + sugarsLabel.frame.size.height + 5, proteinLabel.frame.size.width, proteinLabel.frame.size.height)];
    
    UIView *lineSeparatorView1 = [[UIView alloc] initWithFrame:CGRectMake(nutritionView.frame.size.width/3, 20, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20)];
    [lineSeparatorView1 setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineSeparatorView2 = [[UIView alloc] initWithFrame:CGRectMake((nutritionView.frame.size.width/3) * 2, 20, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20)];
    [lineSeparatorView2 setBackgroundColor:[UIColor whiteColor]];
    
    [nutritionView addSubview:calorieLabel];
    [nutritionView addSubview:totalFatLabel];
    [nutritionView addSubview:satFatLabel];
    [nutritionView addSubview:cholesterolLabel];
    [nutritionView addSubview:sodiumLabel];
    [nutritionView addSubview:carbsLabel];
    [nutritionView addSubview:fiberLabel];
    [nutritionView addSubview:sugarsLabel];
    [nutritionView addSubview:proteinLabel];
    [nutritionView addSubview:lineSeparatorView1];
    [nutritionView addSubview:lineSeparatorView2];
    
    calorieValueLabel = [[UILabel alloc] init];
    calorieValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:25];
    calorieValueLabel.textColor = [UIColor whiteColor];
    calorieValueLabel.text = @"0";
    [calorieValueLabel sizeToFit];
    calorieValueLabel.textAlignment = NSTextAlignmentCenter;
    [calorieValueLabel setFrame:CGRectMake(5, calorieLabel.frame.origin.y + calorieLabel.frame.size.height + 5, nutritionView.frame.size.width/3 - 10, lineSeparatorView1.frame.size.height - (calorieLabel.frame.origin.y + calorieLabel.frame.size.height))];
    
    totalFatValueLabel = [[UILabel alloc] init];
    totalFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    totalFatValueLabel.textColor = [UIColor whiteColor];
    totalFatValueLabel.text = @"0";
    [totalFatValueLabel sizeToFit];
    totalFatValueLabel.textAlignment = NSTextAlignmentCenter;
    [totalFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, 20, 25, totalFatLabel.frame.size.height)];
    
    satFatValueLabel = [[UILabel alloc] init];
    satFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    satFatValueLabel.textColor = [UIColor whiteColor];
    satFatValueLabel.text = @"0";
    [satFatValueLabel sizeToFit];
    satFatValueLabel.textAlignment = NSTextAlignmentCenter;
    [satFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, satFatLabel.frame.origin.y, 25, totalFatLabel.frame.size.height)];
    
    cholesterolValueLabel = [[UILabel alloc] init];
    cholesterolValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    cholesterolValueLabel.textColor = [UIColor whiteColor];
    cholesterolValueLabel.text = @"0";
    [cholesterolValueLabel sizeToFit];
    cholesterolValueLabel.textAlignment = NSTextAlignmentCenter;
    [cholesterolValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, cholesterolLabel.frame.origin.y, 25, cholesterolValueLabel.frame.size.height)];
    
    sodiumValueLabel = [[UILabel alloc] init];
    sodiumValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    sodiumValueLabel.textColor = [UIColor whiteColor];
    sodiumValueLabel.text = @"0";
    [sodiumValueLabel sizeToFit];
    sodiumValueLabel.textAlignment = NSTextAlignmentCenter;
    [sodiumValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, sodiumLabel.frame.origin.y, 25, sodiumValueLabel.frame.size.height)];
    
    carbsValueLabel = [[UILabel alloc] init];
    carbsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    carbsValueLabel.textColor = [UIColor whiteColor];
    carbsValueLabel.text = @"0";
    [carbsValueLabel sizeToFit];
    carbsValueLabel.textAlignment = NSTextAlignmentCenter;
    [carbsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, 20, 25, carbsLabel.frame.size.height)];
    
    fiberValueLabel = [[UILabel alloc] init];
    fiberValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    fiberValueLabel.textColor = [UIColor whiteColor];
    fiberValueLabel.text = @"0";
    [fiberValueLabel sizeToFit];
    fiberValueLabel.textAlignment = NSTextAlignmentCenter;
    [fiberValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, fiberLabel.frame.origin.y, 25, fiberValueLabel.frame.size.height)];
    
    sugarsValueLabel = [[UILabel alloc] init];
    sugarsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    sugarsValueLabel.textColor = [UIColor whiteColor];
    sugarsValueLabel.text = @"0";
    [sugarsValueLabel sizeToFit];
    sugarsValueLabel.textAlignment = NSTextAlignmentCenter;
    [sugarsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, sugarsLabel.frame.origin.y, 25, sugarsValueLabel.frame.size.height)];
    
    proteinValueLabel = [[UILabel alloc] init];
    proteinValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    proteinValueLabel.textColor = [UIColor whiteColor];
    proteinValueLabel.text = @"0";
    [proteinValueLabel sizeToFit];
    proteinValueLabel.textAlignment = NSTextAlignmentCenter;
    [proteinValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, proteinLabel.frame.origin.y, 25, proteinValueLabel.frame.size.height)];
    
    [nutritionView addSubview:calorieValueLabel];
    [nutritionView addSubview:totalFatValueLabel];
    [nutritionView addSubview:satFatValueLabel];
    [nutritionView addSubview:cholesterolValueLabel];
    [nutritionView addSubview:sodiumValueLabel];
    [nutritionView addSubview:carbsValueLabel];
    [nutritionView addSubview:fiberValueLabel];
    [nutritionView addSubview:sugarsValueLabel];
    [nutritionView addSubview:proteinValueLabel];
}

- (void) configureFoodName {
    ingredientNameLabel.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    ingredientNameLabel.textColor = [UIColor whiteColor];
    ingredientNameLabel.textAlignment = NSTextAlignmentCenter;
    ingredientNameLabel.text = [myFood.name uppercaseString];
}

- (void) fillUnitsArray {
    foodServingsInfoArray = [[NSMutableArray alloc] initWithArray:myFood.servings];
    
    for (int i = 0; i < [[myFood servings] count]; i++) {
        
        FSServing *tempFoodServing = [foodServingsInfoArray objectAtIndex:i];
        
        if ([tempFoodServing.metricServingUnit isEqual:@"g"]) {
            [isUnitPresentArray setObject:@1 atIndexedSubscript:0];
            [foodServingsInfoArray addObject:tempFoodServing];
        }
        
        if ([tempFoodServing.metricServingUnit isEqual:@"ml"]) {
            [isUnitPresentArray setObject:@1 atIndexedSubscript:1];
            [foodServingsInfoArray addObject:tempFoodServing];
        }
        
        if ([tempFoodServing.metricServingUnit isEqual:@"oz"]) {
            [isUnitPresentArray setObject:@1 atIndexedSubscript:2];
            [foodServingsInfoArray addObject:tempFoodServing];
        }
        
        for (int i = 0; i < [isUnitPresentArray count]; i++) {
            if ([isUnitPresentArray[i] integerValue] == 1) {
                NSString *tempUnitName = [[NSString alloc] init];
                switch (i) {
                    case 0:
                        tempUnitName = @"gram";
                        break;
                    case 1:
                        tempUnitName = @"milliliter";
                        break;
                    case 2:
                        tempUnitName = @"ounce";
                        break;
                    default:
                        break;
                }
                
                [unitsArray addObject:tempUnitName];
            }
        }
    }
    
    [myPickerView reloadComponent:2];
    [self figureOutUnitRatioIndex];
}

- (void) figureOutUnitRatioIndex {
    gDone = NO;
    mlDone = NO;
    ozDone = NO;
    
    FSServing *tempFoodServing = [[FSServing alloc] init];
    
    for (int i = 0; i < [foodServingsInfoArray count]; i++) {
        tempFoodServing = foodServingsInfoArray[i];
        NSLog(@"metric serving unit = %@", tempFoodServing.metricServingUnit);
        
        if ([tempFoodServing.metricServingUnit isEqualToString:@"g"] && (gDone == NO)) {
            indexForGRatio = i;
            gDone = YES;
        }
        
        if ([tempFoodServing.metricServingUnit isEqualToString:@"ml"] && (mlDone == NO)) {
            indexForMlRatio = i;
            mlDone = YES;
        }
        
        if ([tempFoodServing.metricServingUnit isEqualToString:@"oz"] && (ozDone == NO)) {
            indexForOzRatio = i;
            ozDone = YES;
        }
    }
    
    [myPickerView reloadComponent:2];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int i = 0;
    
    switch (component) {
        case 0:
            return [integerArray count];
            break;
        case 1:
            return [fractionArray count];
            break;
        case 2:
            if (gDone) i++;
            if (mlDone) i++;
            if (ozDone) i++;
            
            return i;
            break;
        default:
            break;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [integerArray[row] description];
            break;
        case 1:
            return fractionArray[row];
            break;
        case 2:
            if ([myPickerView selectedRowInComponent:0] == 0) {
                return updatedUnitsArray[row];
            } else {
                return [NSString stringWithFormat:@"%@s", updatedUnitsArray[row]];
            }
            break;
        default:
            break;
    }
    
    return @"";
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 20;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case 0:
            label.text = [integerArray[row] description];
            return label;
            break;
        case 1:
            label.text = fractionArray[row];
            return label;
            break;
        case 2:
            if ([myPickerView selectedRowInComponent:0] == 0) {
                label.text = unitsArray[row];
                return label;
            } else {
                label.text = [NSString stringWithFormat:@"%@s", unitsArray[row]];
                return label;
            }
            break;
        default:
            break;
    }
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self interpretPickerView];
}

- (void) interpretPickerView {
    
    switch ([myPickerView selectedRowInComponent:1]) {
        case 0:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0;
            break;
        case 1:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.125;
            break;
        case 2:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.25;
            break;
        case 3:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.333;
            break;
        case 4:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.5;
            break;
        case 5:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.666;
            break;
        case 6:
            numberOfServings = (float)[myPickerView selectedRowInComponent:0] + 0.75;
            break;
        default:
            break;
    }
    
    FSServing *tempFoodServing = [[FSServing alloc] init];
    
    if ([unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"gram"] || [unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"grams"]) {
        tempFoodServing = foodServingsInfoArray[indexForGRatio];
    }
    
    if ([unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"milliliter"] || [unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"milliliters"]) {
        tempFoodServing = foodServingsInfoArray[indexForMlRatio];
    }
    
    if ([unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"ounce"] || [unitsArray[[myPickerView selectedRowInComponent:2]] isEqualToString:@"ounces"]) {
        tempFoodServing = foodServingsInfoArray[indexForOzRatio];
    }
    
    calories = [NSNumber numberWithFloat:(tempFoodServing.caloriesValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    fats = [NSNumber numberWithFloat:(tempFoodServing.fatValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    saturatedFats = [NSNumber numberWithFloat:(tempFoodServing.saturatedFatValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    cholesterol = [NSNumber numberWithFloat:(tempFoodServing.cholesterolValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    sodium = [NSNumber numberWithFloat:(tempFoodServing.sodiumValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    carbs = [NSNumber numberWithFloat:(tempFoodServing.carbohydrateValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    fiber = [NSNumber numberWithFloat:(tempFoodServing.fiberValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    sugars = [NSNumber numberWithFloat:(tempFoodServing.sugarValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    protein = [NSNumber numberWithFloat:(tempFoodServing.proteinValue / tempFoodServing.metricServingAmountValue) * numberOfServings];
    
    [self updateNutritionLabels];
}

- (void) updateNutritionLabels {
    calorieValueLabel.text = [NSString stringWithFormat:@"%.1f", [calories floatValue]];
    totalFatValueLabel.text = [NSString stringWithFormat:@"%.1fg", [fats floatValue]];
    satFatValueLabel.text = [NSString stringWithFormat:@"%.1fg", [saturatedFats floatValue]];
    cholesterolValueLabel.text = [NSString stringWithFormat:@"%.1fmg", [cholesterol floatValue]];
    sodiumValueLabel.text = [NSString stringWithFormat:@"%.1fmg", [sodium floatValue]];
    carbsValueLabel.text = [NSString stringWithFormat:@"%.1fg", [carbs floatValue]];
    fiberValueLabel.text = [NSString stringWithFormat:@"%.1fg", [fiber floatValue]];
    sugarsValueLabel.text = [NSString stringWithFormat:@"%.1fg", [sugars floatValue]];
    proteinValueLabel.text = [NSString stringWithFormat:@"%.1fg", [protein floatValue]];
    
    [totalFatValueLabel sizeToFit];
    [satFatValueLabel sizeToFit];
    [cholesterolValueLabel sizeToFit];
    [sodiumValueLabel sizeToFit];
    [carbsValueLabel sizeToFit];
    [fiberValueLabel sizeToFit];
    [sugarsValueLabel sizeToFit];
    [proteinValueLabel sizeToFit];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFoodButtonTouched:(id)sender {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    FoodTrackerItem *foodTrackerItem = [NSEntityDescription insertNewObjectForEntityForName:@"FoodTrackerItem" inManagedObjectContext:coreDataStack.managedObjectContext];
    FSServing *tempServing = myFood.servings[0];
    
    foodTrackerItem.servingSize = tempServing.servingDescription;
    foodTrackerItem.numberOfServings = [NSNumber numberWithFloat:numberOfServings];
    foodTrackerItem.caloriesPerServing = [NSNumber numberWithFloat:[tempServing caloriesValue]];
    foodTrackerItem.proteinsPerServing = [NSNumber numberWithFloat:[tempServing proteinValue]];
    foodTrackerItem.fatsPerServing = [NSNumber numberWithFloat:[tempServing fatValue]];
    foodTrackerItem.carbsPerServing = [NSNumber numberWithFloat:[tempServing carbohydrateValue]];
    foodTrackerItem.name = myFood.name;
    foodTrackerItem.identifier = [NSNumber numberWithLong:myFood.identifier];
    foodTrackerItem.date = trackerDate;
    
    [coreDataStack saveContext];
    
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

@end
