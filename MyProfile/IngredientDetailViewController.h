//
//  IngredientDetailViewController.h
//  MyProfile
//
//  Created by Apple on 22/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FatSecretKit/FSFood.h>

@interface IngredientDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *ingredientNameLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (weak, nonatomic) IBOutlet UIView *nutritionView;
@property FSFood *myFood;
@property (strong, nonatomic) NSDate *trackerDate;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)addFoodButtonTouched:(id)sender;

@end
