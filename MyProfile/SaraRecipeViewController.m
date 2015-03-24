//
//  SaraRecipeViewController.m
//  MyProfile
//
//  Created by Apple on 05/01/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "SaraRecipeViewController.h"
#import "SaraRecipeTableViewCell.h"

@interface SaraRecipeViewController ()

@property (nonatomic, strong) NSArray *categoryArray;
@property int currentSelection;
@property BOOL isFirstTime;
@property BOOL isFirstClick;
@property NSArray *ingredientsArray;
@property NSArray *directionsArray;

@property UILabel *calorieValueLabel;
@property UILabel *totalFatValueLabel;
@property UILabel *satFatValueLabel;
@property UILabel *cholesterolValueLabel;
@property UILabel *sodiumValueLabel;
@property UILabel *carbsValueLabel;
@property UILabel *fiberValueLabel;
@property UILabel *sugarsValueLabel;
@property UILabel *proteinValueLabel;
@property BOOL is35;

@end

@implementation SaraRecipeViewController
@synthesize categoryArray, isFirstClick, isFirstTime, myPFImageView, myRecipe, ingredientsArray, directionsArray, currentSelection, calorieValueLabel, totalFatValueLabel, satFatValueLabel, cholesterolValueLabel, sodiumValueLabel, carbsValueLabel, fiberValueLabel, sugarsValueLabel, proteinValueLabel, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    ingredientsArray = [NSArray new];
    ingredientsArray = [myRecipe objectForKey:@"Ingredients"];
    directionsArray = [NSArray new];
    directionsArray = [myRecipe objectForKey:@"Directions"];

    categoryArray = @[@"OVERVIEW", @"INGREDIENTS", @"DIRECTIONS"];
    
    isFirstTime = YES;
    isFirstClick = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"RECIPES";
    
    [self.view addSubview:titleLabel];
    
    myPFImageView.contentMode = UIViewContentModeScaleAspectFill;
    myPFImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    myPFImageView.layer.cornerRadius = myPFImageView.frame.size.height/2;
    myPFImageView.clipsToBounds = YES;
    [myPFImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [myPFImageView.layer setBorderWidth:2.0];
    
    PFFile *image = [myRecipe objectForKey:@"image"];
    myPFImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    myPFImageView.file = image;
    [myPFImageView loadInBackground];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaraRecipeTableViewCell *cell = (SaraRecipeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RecipeSampleCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.myTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:18];
    cell.myTitleLabel.textColor = [UIColor whiteColor];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        {case 0:
            NSLog(@"");
            UIImageView *titleBoxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 55, 320, 38)];
            if (is35) {
                [titleBoxImageView setFrame:CGRectMake(0, 46, 320, 32)];
            }
            titleBoxImageView.image = [UIImage imageNamed:@"title_rectangle@2x.png"];
            
            UILabel *foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 100, 40)];
            if (is35) {
                foodNameLabel.frame = CGRectMake(0, 7, 100, 34);
            }
            foodNameLabel.font = [UIFont fontWithName:@"Oswald" size:13];
            foodNameLabel.textColor = [UIColor whiteColor];
            foodNameLabel.text = [[myRecipe objectForKey:@"name"] uppercaseString];
            [foodNameLabel sizeToFit];
            foodNameLabel.frame = CGRectMake((320 - foodNameLabel.frame.size.width)/2, 8, foodNameLabel.frame.size.width, foodNameLabel.frame.size.height);
            
            [cell.contentView addSubview:titleBoxImageView];
            [titleBoxImageView addSubview:foodNameLabel];
            
            UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 320, 10)];
            if (is35) {
                [dividerImageView setFrame:CGRectMake(0, 108, 320, 10)];
            }
            dividerImageView.image = [UIImage imageNamed:@"divider@2x.png"];
            
            UILabel *prepTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 150, 60, 40)];
            if (is35) {
                prepTimeLabel.frame = CGRectMake(36, 127, 60, 34);
            }
            prepTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            prepTimeLabel.textColor = [UIColor whiteColor];
            prepTimeLabel.text = @"PREP TIME";
            [prepTimeLabel sizeToFit];
            prepTimeLabel.frame = CGRectMake( (((320/3)/2) - prepTimeLabel.frame.size.width/2) , 140, prepTimeLabel.frame.size.width, prepTimeLabel.frame.size.height);
            if (is35) {
                prepTimeLabel.frame = CGRectMake( (((320/3)/2) - prepTimeLabel.frame.size.width/2) , 118, prepTimeLabel.frame.size.width, prepTimeLabel.frame.size.height);
            }
            
            UILabel *cookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(136, 150, 60, 40)];
            if (is35) {
                cookTimeLabel.frame = CGRectMake(136, 127, 60, 34);
            }
            cookTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            cookTimeLabel.textColor = [UIColor whiteColor];
            cookTimeLabel.text = @"COOK TIME";
            [cookTimeLabel sizeToFit];
            cookTimeLabel.frame = CGRectMake( (((320/3)/2) - cookTimeLabel.frame.size.width/2) + ((320/3) * 1) , 140, cookTimeLabel.frame.size.width, cookTimeLabel.frame.size.height);
            if (is35) {
                cookTimeLabel.frame = CGRectMake( (((320/3)/2) - cookTimeLabel.frame.size.width/2) + ((320/3) * 1) , 118, cookTimeLabel.frame.size.width, cookTimeLabel.frame.size.height);
            }
            
            UILabel *totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(236, 150, 60, 40)];
            if (is35) {
                totalTimeLabel.frame = CGRectMake(236, 127, 60, 34);
            }
            totalTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            totalTimeLabel.textColor = [UIColor whiteColor];
            totalTimeLabel.text = @"TOTAL TIME";
            [totalTimeLabel sizeToFit];
            totalTimeLabel.frame = CGRectMake( (((320/3)/2) - totalTimeLabel.frame.size.width/2) + ((320/3) * 2) , 140, totalTimeLabel.frame.size.width, totalTimeLabel.frame.size.height);
            if (is35) {
                totalTimeLabel.frame = CGRectMake( (((320/3)/2) - totalTimeLabel.frame.size.width/2) + ((320/3) * 2) , 118, totalTimeLabel.frame.size.width, totalTimeLabel.frame.size.height);
            }
            
            UIView *nutritionView = [[UIView alloc] initWithFrame:CGRectMake(20, 151, 280, 129)];
            if (is35) {
                nutritionView.frame = CGRectMake(20, 128, 280, 109);
            }
            [nutritionView setBackgroundColor:[UIColor clearColor]];
            
            UILabel *calorieLabel = [[UILabel alloc] init];
            calorieLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            calorieLabel.textColor = [UIColor whiteColor];
            calorieLabel.text = @"CALORIES";
            [calorieLabel sizeToFit];
            [calorieLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) - (calorieLabel.frame.size.width))/2 - 19, 20, calorieLabel.frame.size.width, calorieLabel.frame.size.height)];
            if (is35) {
                [calorieLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) - (calorieLabel.frame.size.width))/2 - 19, 17, calorieLabel.frame.size.width, calorieLabel.frame.size.height)];
            }
            
            UILabel *totalFatLabel = [[UILabel alloc] init];
            totalFatLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            totalFatLabel.textColor = [UIColor whiteColor];
            totalFatLabel.text = @"TOTAL FAT";
            [totalFatLabel sizeToFit];
            [totalFatLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10 - 19, 20, totalFatLabel.frame.size.width, totalFatLabel.frame.size.height)];
            if (is35) {
                [totalFatLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10 - 19, 17, totalFatLabel.frame.size.width, totalFatLabel.frame.size.height)];
            }
            
            UILabel *satFatLabel = [[UILabel alloc] init];
            satFatLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            satFatLabel.textColor = [UIColor grayColor];
            satFatLabel.text = @"SAT FAT";
            [satFatLabel sizeToFit];
            [satFatLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 20 - 19, totalFatLabel.frame.origin.y + totalFatLabel.frame.size.height + 5, satFatLabel.frame.size.width, satFatLabel.frame.size.height)];
            
            UILabel *cholesterolLabel = [[UILabel alloc] init];
            cholesterolLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            cholesterolLabel.textColor = [UIColor whiteColor];
            cholesterolLabel.text = @"CHOLEST";
            [cholesterolLabel sizeToFit];
            [cholesterolLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10 - 19, satFatLabel.frame.origin.y + satFatLabel.frame.size.height + 5, cholesterolLabel.frame.size.width, cholesterolLabel.frame.size.height)];
            
            UILabel *sodiumLabel = [[UILabel alloc] init];
            sodiumLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            sodiumLabel.textColor = [UIColor whiteColor];
            sodiumLabel.text = @"SODIUM";
            [sodiumLabel sizeToFit];
            [sodiumLabel setFrame:CGRectMake((nutritionView.frame.size.width/3) + 10 - 19, cholesterolLabel.frame.origin.y + cholesterolLabel.frame.size.height + 5, sodiumLabel.frame.size.width, sodiumLabel.frame.size.height)];
            
            UILabel *carbsLabel = [[UILabel alloc] init];
            carbsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            carbsLabel.textColor = [UIColor whiteColor];
            carbsLabel.text = @"CARBS";
            [carbsLabel sizeToFit];
            [carbsLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 10, 20, carbsLabel.frame.size.width, carbsLabel.frame.size.height)];
            if (is35) {
                [carbsLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 10, 17, carbsLabel.frame.size.width, carbsLabel.frame.size.height)];
            }
            
            UILabel *fiberLabel = [[UILabel alloc] init];
            fiberLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            fiberLabel.textColor = [UIColor grayColor];
            fiberLabel.text = @"FIBER";
            [fiberLabel sizeToFit];
            [fiberLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 20, carbsLabel.frame.origin.y + carbsLabel.frame.size.height + 5, fiberLabel.frame.size.width, fiberLabel.frame.size.height)];
            
            UILabel *sugarsLabel = [[UILabel alloc] init];
            sugarsLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            sugarsLabel.textColor = [UIColor grayColor];
            sugarsLabel.text = @"SUGAR";
            [sugarsLabel sizeToFit];
            [sugarsLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 20, fiberLabel.frame.origin.y + fiberLabel.frame.size.height + 5, sugarsLabel.frame.size.width, sugarsLabel.frame.size.height)];
            
            UILabel *proteinLabel = [[UILabel alloc] init];
            proteinLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            proteinLabel.textColor = [UIColor whiteColor];
            proteinLabel.text = @"PROTEIN";
            [proteinLabel sizeToFit];
            [proteinLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) + 10, sugarsLabel.frame.origin.y + sugarsLabel.frame.size.height + 5, proteinLabel.frame.size.width, proteinLabel.frame.size.height)];
            
            UIView *lineSeparatorView1 = [[UIView alloc] initWithFrame:CGRectMake(nutritionView.frame.size.width/3 - 19, 20, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20)];
            if (is35) {
                lineSeparatorView1.frame = CGRectMake(nutritionView.frame.size.width/3 - 19, 17, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20);
            }
            [lineSeparatorView1 setBackgroundColor:[UIColor whiteColor]];
            
            UIView *lineSeparatorView2 = [[UIView alloc] initWithFrame:CGRectMake((nutritionView.frame.size.width/3) * 2, 20, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20)];
            if (is35) {
                lineSeparatorView2.frame = CGRectMake((nutritionView.frame.size.width/3) * 2, 17, 1, sodiumLabel.frame.origin.y + sodiumLabel.frame.size.height - 20);
            }
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
            
            [cell.contentView addSubview:nutritionView];
            
            UILabel *prepMinLabel = [[UILabel alloc] init];
            prepMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
            prepMinLabel.textColor = [UIColor whiteColor];
            prepMinLabel.text = [NSString stringWithFormat:@"%@", [myRecipe objectForKey:@"prepTime"]];
            [prepMinLabel sizeToFit];
            
            UILabel *prepMinLabelLabel = [[UILabel alloc] init];
            prepMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
            prepMinLabelLabel.textColor = [UIColor whiteColor];
            prepMinLabelLabel.text = @" MIN";
            [prepMinLabelLabel sizeToFit];
            
            prepMinLabel.frame = CGRectMake( ((320/3)/2) - ((prepMinLabel.frame.size.width + prepMinLabelLabel.frame.size.width)/2), 100, prepMinLabel.frame.size.width, prepMinLabel.frame.size.height);
            prepMinLabelLabel.frame = CGRectMake(prepMinLabel.frame.origin.x
                                                 + prepMinLabel.frame.size.width, 110, prepMinLabelLabel.frame.size.width, prepMinLabelLabel.frame.size.height);
            if (is35) {
                prepMinLabel.frame = CGRectMake( ((320/3)/2) - ((prepMinLabel.frame.size.width + prepMinLabelLabel.frame.size.width)/2), 85, prepMinLabel.frame.size.width, prepMinLabel.frame.size.height);
                prepMinLabelLabel.frame = CGRectMake(prepMinLabel.frame.origin.x
                                                     + prepMinLabel.frame.size.width, 93, prepMinLabelLabel.frame.size.width, prepMinLabelLabel.frame.size.height);
            }
            
            
            UILabel *cookMinLabel = [[UILabel alloc] init];
            cookMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
            cookMinLabel.textColor = [UIColor whiteColor];
            cookMinLabel.text = [NSString stringWithFormat:@"%@", [myRecipe objectForKey:@"cookTime"]];
            [cookMinLabel sizeToFit];
            
            UILabel *cookMinLabelLabel = [[UILabel alloc] init];
            cookMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
            cookMinLabelLabel.textColor = [UIColor whiteColor];
            cookMinLabelLabel.text = @" MIN";
            [cookMinLabelLabel sizeToFit];
            
            cookMinLabel.frame = CGRectMake( ((320/3)/2) - ((cookMinLabel.frame.size.width + cookMinLabelLabel.frame.size.width)/2) + ((320/3) * 1), 100, cookMinLabel.frame.size.width, cookMinLabel.frame.size.height);
            cookMinLabelLabel.frame = CGRectMake(cookMinLabel.frame.origin.x
                                                 + cookMinLabel.frame.size.width, 110, cookMinLabelLabel.frame.size.width, cookMinLabelLabel.frame.size.height);
            if (is35) {
                cookMinLabel.frame = CGRectMake( ((320/3)/2) - ((cookMinLabel.frame.size.width + cookMinLabelLabel.frame.size.width)/2) + ((320/3) * 1), 85, cookMinLabel.frame.size.width, cookMinLabel.frame.size.height);
                cookMinLabelLabel.frame = CGRectMake(cookMinLabel.frame.origin.x
                                                     + cookMinLabel.frame.size.width, 93, cookMinLabelLabel.frame.size.width, cookMinLabelLabel.frame.size.height);
            }
            
            UILabel *totalMinLabel = [[UILabel alloc] init];
            totalMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
            totalMinLabel.textColor = [UIColor whiteColor];
            totalMinLabel.text = [NSString stringWithFormat:@"%@", @([[myRecipe objectForKey:@"cookTime"] intValue] + [[myRecipe objectForKey:@"prepTime"] intValue])];
            [totalMinLabel sizeToFit];
            
            UILabel *totalMinLabelLabel = [[UILabel alloc] init];
            totalMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
            totalMinLabelLabel.textColor = [UIColor whiteColor];
            totalMinLabelLabel.text = @" MIN";
            [totalMinLabelLabel sizeToFit];
            
            totalMinLabel.frame = CGRectMake( ((320/3)/2) - ((totalMinLabel.frame.size.width + totalMinLabelLabel.frame.size.width)/2) + ((320/3) * 2), 100, totalMinLabel.frame.size.width, totalMinLabel.frame.size.height);
            totalMinLabelLabel.frame = CGRectMake(totalMinLabel.frame.origin.x
                                                  + totalMinLabel.frame.size.width, 110, totalMinLabelLabel.frame.size.width, totalMinLabelLabel.frame.size.height);
            if (is35) {
                totalMinLabel.frame = CGRectMake( ((320/3)/2) - ((totalMinLabel.frame.size.width + totalMinLabelLabel.frame.size.width)/2) + ((320/3) * 2), 85, totalMinLabel.frame.size.width, totalMinLabel.frame.size.height);
                totalMinLabelLabel.frame = CGRectMake(totalMinLabel.frame.origin.x
                                                      + totalMinLabel.frame.size.width, 93, totalMinLabelLabel.frame.size.width, totalMinLabelLabel.frame.size.height);
            }
            
            [cell.contentView addSubview:prepMinLabel];
            [cell.contentView addSubview:prepMinLabelLabel];
            [cell.contentView addSubview:cookMinLabel];
            [cell.contentView addSubview:cookMinLabelLabel];
            [cell.contentView addSubview:totalMinLabel];
            [cell.contentView addSubview:totalMinLabelLabel];

            calorieValueLabel = [[UILabel alloc] init];
            calorieValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:25];
            calorieValueLabel.textColor = [UIColor whiteColor];
            calorieValueLabel.text = [NSString stringWithFormat:@"%.0f", [[myRecipe objectForKey:@"calories"] floatValue]];
            [calorieValueLabel sizeToFit];
            calorieValueLabel.textAlignment = NSTextAlignmentCenter;
            [calorieValueLabel setFrame:CGRectMake(25 - 19, calorieLabel.frame.origin.y + calorieLabel.frame.size.height + 5, nutritionView.frame.size.width/3 - 10, lineSeparatorView1.frame.size.height - (calorieLabel.frame.origin.y + calorieLabel.frame.size.height))];
            [calorieValueLabel sizeToFit];
            
            totalFatValueLabel = [[UILabel alloc] init];
            totalFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            totalFatValueLabel.textColor = [UIColor whiteColor];
            totalFatValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"fat"] floatValue]];
            [totalFatValueLabel sizeToFit];
            totalFatValueLabel.textAlignment = NSTextAlignmentCenter;
            [totalFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32 - 19, 20, 25 + 19, totalFatLabel.frame.size.height)];
            if (is35) {
                [totalFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32 - 19, 17, 25 + 19, totalFatLabel.frame.size.height)];
            }
            [totalFatValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            satFatValueLabel = [[UILabel alloc] init];
            satFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            satFatValueLabel.textColor = [UIColor whiteColor];
            satFatValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"saturatedFat"] floatValue]];
            [satFatValueLabel sizeToFit];
            satFatValueLabel.textAlignment = NSTextAlignmentCenter;
            [satFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32 - 19, satFatLabel.frame.origin.y, 25 + 19, totalFatLabel.frame.size.height)];
            [satFatValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            cholesterolValueLabel = [[UILabel alloc] init];
            cholesterolValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            cholesterolValueLabel.textColor = [UIColor whiteColor];
            cholesterolValueLabel.text = [NSString stringWithFormat:@"%.0fmg", [[myRecipe objectForKey:@"cholesterol"] floatValue]];
            [cholesterolValueLabel sizeToFit];
            cholesterolValueLabel.textAlignment = NSTextAlignmentCenter;
            [cholesterolValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32 - 19, cholesterolLabel.frame.origin.y, 25 + 19, cholesterolValueLabel.frame.size.height)];
            [cholesterolValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            sodiumValueLabel = [[UILabel alloc] init];
            sodiumValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            sodiumValueLabel.textColor = [UIColor whiteColor];
            sodiumValueLabel.text = [NSString stringWithFormat:@"%.0fmg", [[myRecipe objectForKey:@"sodium"] floatValue]];
            [sodiumValueLabel sizeToFit];
            sodiumValueLabel.textAlignment = NSTextAlignmentCenter;
            [sodiumValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32 - 19, sodiumLabel.frame.origin.y, 25 + 19, sodiumValueLabel.frame.size.height)];
            [sodiumValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            carbsValueLabel = [[UILabel alloc] init];
            carbsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            carbsValueLabel.textColor = [UIColor whiteColor];
            carbsValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"netCarbs"] floatValue]];
            [carbsValueLabel sizeToFit];
            carbsValueLabel.textAlignment = NSTextAlignmentCenter;
            [carbsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27 - 5, 20, 25 + 19, carbsLabel.frame.size.height)];
            if (is35) {
                [carbsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27 - 5, 17, 25 + 19, carbsLabel.frame.size.height)];
            }
            [carbsValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            fiberValueLabel = [[UILabel alloc] init];
            fiberValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            fiberValueLabel.textColor = [UIColor whiteColor];
            fiberValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"fiber"] floatValue]];
            [fiberValueLabel sizeToFit];
            fiberValueLabel.textAlignment = NSTextAlignmentCenter;
            [fiberValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27 - 5, fiberLabel.frame.origin.y, 25 + 19, fiberValueLabel.frame.size.height)];
            [fiberValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            sugarsValueLabel = [[UILabel alloc] init];
            sugarsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            sugarsValueLabel.textColor = [UIColor whiteColor];
            sugarsValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"sugar"] floatValue]];
            [sugarsValueLabel sizeToFit];
            sugarsValueLabel.textAlignment = NSTextAlignmentCenter;
            [sugarsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27 - 5, sugarsLabel.frame.origin.y, 25 + 19, sugarsValueLabel.frame.size.height)];
            [sugarsValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            proteinValueLabel = [[UILabel alloc] init];
            proteinValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
            proteinValueLabel.textColor = [UIColor whiteColor];
            proteinValueLabel.text = [NSString stringWithFormat:@"%.0fg", [[myRecipe objectForKey:@"protein"] floatValue]];
            [proteinValueLabel sizeToFit];
            proteinValueLabel.textAlignment = NSTextAlignmentCenter;
            [proteinValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27 - 5, proteinLabel.frame.origin.y, 25 + 19, proteinValueLabel.frame.size.height)];
            [proteinValueLabel setAdjustsFontSizeToFitWidth:YES];
            
            [nutritionView addSubview:calorieValueLabel];
            [nutritionView addSubview:totalFatValueLabel];
            [nutritionView addSubview:satFatValueLabel];
            [nutritionView addSubview:cholesterolValueLabel];
            [nutritionView addSubview:sodiumValueLabel];
            [nutritionView addSubview:carbsValueLabel];
            [nutritionView addSubview:fiberValueLabel];
            [nutritionView addSubview:sugarsValueLabel];
            [nutritionView addSubview:proteinValueLabel];
            
            [cell.contentView addSubview:dividerImageView];
            [cell.contentView addSubview:prepTimeLabel];
            [cell.contentView addSubview:cookTimeLabel];
            [cell.contentView addSubview:totalTimeLabel];
            break;}
        {case 1:
            NSLog(@"");
            UILabel *servingsLabel = [[UILabel alloc] init];
            servingsLabel.font = [UIFont fontWithName:@"Norican-Regular" size:16];
            servingsLabel.textColor = [UIColor whiteColor];
            servingsLabel.text = [NSString stringWithFormat:@"Makes %@ servings", [myRecipe objectForKey:@"numberOfServings"]];
            [servingsLabel sizeToFit];
            servingsLabel.frame = CGRectMake(54, 75, servingsLabel.frame.size.width, servingsLabel.frame.size.height);
            if (is35) {
                servingsLabel.frame = CGRectMake(54, 63, servingsLabel.frame.size.width, servingsLabel.frame.size.height);
            }
            
            UITextView *ingredientsTextView = [[UITextView alloc] init];
            ingredientsTextView.backgroundColor = [UIColor clearColor];
            ingredientsTextView.frame = CGRectMake(60, 110, 220, 135);
            if (is35) {
                [ingredientsTextView setFrame:CGRectMake(60, 93, 220, 114)];
            }
            ingredientsTextView.scrollEnabled = YES;
            ingredientsTextView.pagingEnabled = NO;
            ingredientsTextView.editable = NO;
            ingredientsTextView.userInteractionEnabled = YES;
            ingredientsTextView.font = [UIFont fontWithName:@"Oswald-light" size:12];
            ingredientsTextView.textColor = [UIColor whiteColor];
            
            for (int i = 0; i < [ingredientsArray count]; i++) {
                
                ingredientsTextView.text = [NSString stringWithFormat:@"%@ %@", ingredientsTextView.text, ingredientsArray[i]];
                ingredientsTextView.text = [NSString stringWithFormat:@"%@ \n", ingredientsTextView.text];
            }
            
            [cell.contentView addSubview:servingsLabel];
            [cell.contentView addSubview:ingredientsTextView];
            break;}
        {case 2:
            NSLog(@"");
                UILabel *preparationLabel = [[UILabel alloc] init];
                preparationLabel.font = [UIFont fontWithName:@"Norican-Regular" size:16];
                preparationLabel.textColor = [UIColor whiteColor];
                preparationLabel.text = @"Preparation";
                [preparationLabel sizeToFit];
                preparationLabel.frame = CGRectMake(59, 76, preparationLabel.frame.size.width, preparationLabel.frame.size.height);
            if (is35) {
                preparationLabel.frame = CGRectMake(59, 64, preparationLabel.frame.size.width, preparationLabel.frame.size.height);
            }
                
                UITextView *directionsTextView = [[UITextView alloc] init];
                directionsTextView.backgroundColor = [UIColor clearColor];
                directionsTextView.frame = CGRectMake(60, 110, 220, 135);
            if (is35) {
                directionsTextView.frame = CGRectMake(60, 93, 220, 114);
            }
                directionsTextView.scrollEnabled = YES;
                directionsTextView.pagingEnabled = NO;
                directionsTextView.editable = NO;;
                directionsTextView.userInteractionEnabled = YES;
                directionsTextView.font = [UIFont fontWithName:@"Oswald-Light" size:12];
                directionsTextView.textColor = [UIColor whiteColor];
                
                for (int i = 0; i < [directionsArray count]; i++) {
                    directionsTextView.text = [NSString stringWithFormat:@"%@ %@", directionsTextView.text, directionsArray[i]];
                    directionsTextView.text = [NSString stringWithFormat:@"%@ \n \n", directionsTextView.text];
                    NSLog(@"test");
                }
                
                [cell.contentView addSubview:preparationLabel];
                [cell.contentView addSubview:directionsTextView];
            
            break;}
        {default:
            break;}
    }
    
    
    if (isFirstTime) {
        cell.myImageView.image = [UIImage imageNamed:@"downArrow.png"];
        isFirstTime = NO;
    } else {
        cell.myImageView.image = [UIImage imageNamed:@"upArrow.png"];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFirstClick) {
        NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        SaraRecipeTableViewCell *cell = (SaraRecipeTableViewCell *)[tableView cellForRowAtIndexPath:myIndexPath];
        cell.myImageView.image = [UIImage imageNamed:@"downArrow.png"];
        isFirstClick = NO;
    }
    
    int row = (int)[indexPath row];
    currentSelection = row;
    
    SaraRecipeTableViewCell* cell = (SaraRecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"upArrow.png"];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SaraRecipeTableViewCell* cell = (SaraRecipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"downArrow.png"];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
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

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
