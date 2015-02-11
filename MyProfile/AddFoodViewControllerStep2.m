//
//  AddFoodViewControllerStep2.m
//  MyProfile
//
//  Created by Poulose Matthen on 15/09/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "AppDelegate.h"
#import "DailyTrackerViewController.h"
#import "AddFoodViewControllerStep2.h"
#import "AddFoodStep2TableViewCell.h"
#import <FatSecretKit/FSClient.h>
#import <FatSecretKit/FSRecipe.h>
#import <FatSecretKit/FSFood.h>
#import <FatSecretKit/FSServing.h>
#import <FatSecretKit/FSRecipeServings.h>
#import "FoodTrackerItem.h"
#import "RecipeSampleViewController.h"
#import "IngredientDetailViewController.h"
#import "SaraRecipeViewController.h"

@interface AddFoodViewControllerStep2 () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *resultsArray;
@property (nonatomic, strong) NSMutableArray *isSelectedArray;
@property (nonatomic, strong) NSMutableArray *numberOfServingsArray;
@property (nonatomic, strong) PFQuery *query;
@property (nonatomic, strong) FSRecipe *recipeToSend;
@property (nonatomic, strong) FSFood *foodToSend;
@property (nonatomic, strong) PFObject *saraRecipeToSend;

@end

@implementation AddFoodViewControllerStep2
@synthesize searchTextField, searchText, myTableView, mySegmentedControl, resultsArray, query, isSelectedArray, numberOfServingsArray, recipeToSend, foodToSend, saraRecipeToSend, trackerDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FSClient sharedClient] searchFoods:searchText completion:^(NSArray *foods, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
        resultsArray = foods;
        FSFood *tempFood = resultsArray[0];
        [[FSClient sharedClient] getFood:tempFood.identifier completion:^(FSFood *food) {
            for (int i = 0; i < [food.servings count]; i++) {
                FSServing *tempServing = food.servings[i];
                NSLog(@"serving_description = %@", tempServing.servingDescription);
                NSLog(@"metric_serving_amount = %.0f", tempServing.metricServingAmountValue);
                NSLog(@"metric_serving_unit = %@", tempServing.metricServingUnit);
                NSLog(@"number_of_units = %f", tempServing.numberOfUnitsValue);
                NSLog(@"meausurement_description = %@", tempServing.measurementDescription);
                NSLog(@"*************************");
            }
        }];
    }];
    
    [mySegmentedControl setTintColor:[UIColor whiteColor]];
    
    isSelectedArray = [NSMutableArray new];
    numberOfServingsArray = [NSMutableArray new];
    
    [searchTextField setBackgroundColor:[UIColor clearColor]];
    searchTextField.font = [UIFont fontWithName:@"Oswald" size:23];
    searchTextField.textColor = [UIColor whiteColor];
    
    searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Oswald" size:23]}];

    searchTextField.text = searchText;
    query = [PFQuery queryWithClassName:@"Recipe"];
    [query whereKey:@"name" hasPrefix:[searchTextField.text lowercaseString]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && self.mySegmentedControl.selectedSegmentIndex == 0) {
            resultsArray = objects;
            [self deselectAllCells];
            [myTableView reloadData];
        }
        if (error) {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ((textField.tag - 1) == -1) {
        [self searchButtonTouched:self];
    } else {
        numberOfServingsArray[textField.tag - 1] = [NSNumber numberWithInt:[textField.text intValue]];
        [myTableView reloadData];
    }
    
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFoodStep2TableViewCell *cell = (AddFoodStep2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddFoodStep2Cell"];
    
    cell.servingSizeLabel.text = @"";
    cell.selectionButtonImageView.tag = indexPath.row;
    
    if (mySegmentedControl.selectedSegmentIndex == 0) {
        PFObject *PFTempRecipe = resultsArray[indexPath.row];
        cell.myTableViewCellTextLabel.text = [PFTempRecipe[@"name"] lowercaseString];
    } else if (mySegmentedControl.selectedSegmentIndex == 1) {
        FSRecipe *tempRecipe = resultsArray[indexPath.row];
        cell.myTableViewCellTextLabel.text = [tempRecipe.name lowercaseString];
    } else if (mySegmentedControl.selectedSegmentIndex == 2) {
        FSFood *tempFood = resultsArray[indexPath.row];

        cell.myTableViewCellTextLabel.text = [tempFood.name lowercaseString];
        cell.servingSizeLabel.textColor = [UIColor whiteColor];
        cell.servingSizeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:9];
        
        [[FSClient sharedClient] getFood:tempFood.identifier completion:^(FSFood *food) {
            if ([food.servings count] > 0) {
                FSServing *tempServing = food.servings[0];
                cell.servingSizeLabel.text = tempServing.servingDescription;
                [cell.servingSizeLabel sizeToFit];
            }
        }];
    }

    cell.myTableViewCellTextLabel.textColor = [UIColor whiteColor];
    cell.myTableViewCellTextLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    
    if (isSelectedArray[indexPath.row] == [NSNumber numberWithBool:YES]) {
        [cell.selectionButtonImageView setImage:[UIImage imageNamed:@"selectedicon@2x.png"] forState:UIControlStateNormal];
        cell.selectionHighlightImageView.hidden = NO;
    } else {
        [cell.selectionButtonImageView setImage:[UIImage imageNamed:@"addicon@2x.png"] forState:UIControlStateNormal];
        cell.selectionHighlightImageView.hidden = YES;
    }
    
    UILabel *servingsLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 10, 40, 20)];
    servingsLabel.tag = 1000;
    servingsLabel.text = @"servings";
    servingsLabel.textColor = [UIColor whiteColor];
    servingsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:14];
    [servingsLabel sizeToFit];
    
    cell.servingsTextField.text = [numberOfServingsArray[indexPath.row] description];
    cell.servingsTextField.textColor = [UIColor whiteColor];
    cell.servingsTextField.font = [UIFont fontWithName:@"Oswald-Light" size:14];
    [cell.servingsTextField sizeToFit];
    cell.servingsTextField.tag = indexPath.row + 1;
    
    [cell.contentView addSubview:servingsLabel];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (mySegmentedControl.selectedSegmentIndex == 0) {
        saraRecipeToSend = resultsArray[indexPath.row];
        [self performSegueWithIdentifier:@"SaraRecipeSampleSegue" sender:self];
    } else if (mySegmentedControl.selectedSegmentIndex == 1) {
        recipeToSend = resultsArray[indexPath.row];
        [self performSegueWithIdentifier:@"RecipeSampleSegue" sender:self];
    } else if (mySegmentedControl.selectedSegmentIndex == 2) {
        foodToSend = resultsArray[indexPath.row];
        [self performSegueWithIdentifier:@"FoodSampleSegue" sender:self];
    }
}

- (IBAction)doneButtonTouched:(id)sender {
    [self saveSelectedFoodItems];
}

- (void) saveSelectedFoodItems {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    for (int i = 0; i < [resultsArray count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (isSelectedArray[indexPath.row] == [NSNumber numberWithBool:YES]) {
            FoodTrackerItem *foodTrackerItem = [NSEntityDescription insertNewObjectForEntityForName:@"FoodTrackerItem" inManagedObjectContext:coreDataStack.managedObjectContext];
            
            if (mySegmentedControl.selectedSegmentIndex == 2) {
                FSFood *tempFood = resultsArray[indexPath.row];
                foodTrackerItem.numberOfServings = numberOfServingsArray[indexPath.row];
                [[FSClient sharedClient] getFood:tempFood.identifier completion:^(FSFood *food) {
                    if ([food.servings count] > 0) {
                        FSServing *tempServing = food.servings[0];
                        foodTrackerItem.servingSize = tempServing.servingDescription;
                        foodTrackerItem.caloriesPerServing = [NSNumber numberWithFloat:[tempServing caloriesValue]];
                        foodTrackerItem.proteinsPerServing = [NSNumber numberWithFloat:[tempServing proteinValue]];
                        foodTrackerItem.fatsPerServing = [NSNumber numberWithFloat:[tempServing fatValue]];
                        foodTrackerItem.carbsPerServing = [NSNumber numberWithFloat:[tempServing carbohydrateValue]];
                    }
                        foodTrackerItem.name = tempFood.name;
                        foodTrackerItem.identifier = [NSNumber numberWithLong:tempFood.identifier];
                        foodTrackerItem.date = trackerDate;
                        [coreDataStack saveContext];
                        [self goToDailyTrackerViewController];
                }];
            } else if (mySegmentedControl.selectedSegmentIndex == 1) {
                FSRecipe *tempRecipe = resultsArray[indexPath.row];
                foodTrackerItem.numberOfServings = numberOfServingsArray[indexPath.row];
                [[FSClient sharedClient] getRecipe:tempRecipe.identifier completion:^(FSRecipe *recipe) {
                    if ([recipe.servings count] > 0) {
                        FSRecipeServings *tempRecipeServings = recipe.servings[0];
                        NSString *tempString = [tempRecipeServings carbohydrate];
                        NSNumber *tempNumber = [NSNumber numberWithFloat:[tempString floatValue]];
                        [foodTrackerItem setCarbsPerServing:tempNumber];
                        foodTrackerItem.caloriesPerServing = [NSNumber numberWithFloat:[tempRecipeServings caloriesValue]];
                        foodTrackerItem.proteinsPerServing = [NSNumber numberWithFloat:[tempRecipeServings proteinValue]];
                        foodTrackerItem.fatsPerServing = [NSNumber numberWithFloat:[tempRecipeServings fatValue]];
                    }
                    foodTrackerItem.servingSize = @"1";
                    foodTrackerItem.name = tempRecipe.name;
                    foodTrackerItem.identifier = [NSNumber numberWithLong:tempRecipe.identifier];
                    foodTrackerItem.date = trackerDate;
                    [coreDataStack saveContext];
                    [self goToDailyTrackerViewController];
                }];
            } else if (mySegmentedControl.selectedSegmentIndex == 0) {
                PFObject *PFTempRecipe = resultsArray[indexPath.row];
                foodTrackerItem.servingSize = @"1";
                foodTrackerItem.caloriesPerServing = PFTempRecipe[@"calories"];
                foodTrackerItem.proteinsPerServing = PFTempRecipe[@"protein"];
                foodTrackerItem.fatsPerServing = PFTempRecipe[@"fat"];
                foodTrackerItem.carbsPerServing = PFTempRecipe[@"netCarbs"];
                foodTrackerItem.name = PFTempRecipe[@"name"];
                foodTrackerItem.identifier = [NSNumber numberWithInt:0];
                foodTrackerItem.numberOfServings = numberOfServingsArray[indexPath.row];
                foodTrackerItem.date = trackerDate;
                [coreDataStack saveContext];
                [self goToDailyTrackerViewController];
            }
        }
    }
    [self deselectAllCells];
}

- (void) goToDailyTrackerViewController {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[DailyTrackerViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButtonTouched:(id)sender {
    [searchTextField resignFirstResponder];
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        {case 0:
            //
            [query whereKey:@"name" hasPrefix:[searchTextField.text lowercaseString]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    resultsArray = objects;
                    [self deselectAllCells];
                    [myTableView reloadData];
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }];
            break;}
        {case 1:
            [[FSClient sharedClient] searchRecipes:searchTextField.text recipeType:@"" pageNumber:0 maxResults:20 completion:^(NSArray *recipes, NSString *recipeType, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
                resultsArray = recipes;
                [self deselectAllCells];
                [myTableView reloadData];
            }];
            break;}
        {case 2:
            [[FSClient sharedClient] searchFoods:searchTextField.text completion:^(NSArray *foods, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
                resultsArray = foods;
                [self deselectAllCells];
                [myTableView reloadData];
            }];
            break;}
        default:
            break;
    }
}

- (IBAction)indexChanged:(id)sender {
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        {case 0:
            //
            [query whereKey:@"name" hasPrefix:[searchTextField.text lowercaseString]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error && self.mySegmentedControl.selectedSegmentIndex == 0) {
                    resultsArray = objects;
                    [self deselectAllCells];
                    [myTableView reloadData];
                    NSLog(@"Shouldn't be here");
                }
                if (error) {
                    NSString *errorString = [error userInfo][@"error"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }];
            break;}
        {case 1:
            [[FSClient sharedClient] searchRecipes:searchTextField.text recipeType:@"" pageNumber:0 maxResults:20 completion:^(NSArray *recipes, NSString *recipeType, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
                resultsArray = recipes;
                [self deselectAllCells];
                [myTableView reloadData];
            }];
            break;}
        {case 2:
            [[FSClient sharedClient] searchFoods:searchTextField.text completion:^(NSArray *foods, NSInteger maxResults, NSInteger totalResults, NSInteger pageNumber) {
                resultsArray = foods;
                [self deselectAllCells];
                [myTableView reloadData];
             }];
            break;}
        default:
            break;
    }
}

- (IBAction)selectionButtonClicked:(UIButton *)sender {
    if (isSelectedArray[sender.tag] == [NSNumber numberWithBool:NO]) {
        isSelectedArray[sender.tag] = [NSNumber numberWithBool:YES];
    } else {
        isSelectedArray[sender.tag] = [NSNumber numberWithBool:NO];
        numberOfServingsArray[sender.tag] = [NSNumber numberWithInt:1];
    }
    
    [myTableView reloadData];
}

- (void) deselectAllCells {
    [isSelectedArray removeAllObjects];
    [numberOfServingsArray removeAllObjects];
    for (int i = 0; i < [resultsArray count]; i++) {
        
        [isSelectedArray addObject:[NSNumber numberWithBool:NO]];
        [numberOfServingsArray addObject:[NSNumber numberWithInt:1]];
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        AddFoodStep2TableViewCell *cell = (AddFoodStep2TableViewCell *) [myTableView cellForRowAtIndexPath:indexPath];

        cell.selectionButtonImageView.imageView.image = [UIImage imageNamed:@"addicon@2x.png"];
        cell.selectionHighlightImageView.hidden = YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SaraRecipeSampleSegue"]) {
        SaraRecipeViewController *saraRecipeViewController = (SaraRecipeViewController *) segue.destinationViewController;
        saraRecipeViewController.myRecipe = saraRecipeToSend;
    }
    
    if ([segue.identifier isEqual:@"RecipeSampleSegue"]) {
        RecipeSampleViewController *recipeSampleViewController = (RecipeSampleViewController *) segue.destinationViewController;
        recipeSampleViewController.myRecipe = recipeToSend;
    }

    if ([segue.identifier isEqual:@"FoodSampleSegue"]) {
        IngredientDetailViewController *ingredientDetailViewController = (IngredientDetailViewController *) segue.destinationViewController;
        ingredientDetailViewController.myFood = foodToSend;
        ingredientDetailViewController.trackerDate = trackerDate;
    }
}

@end
