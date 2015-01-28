//
//  RecipeSampleViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 10/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "RecipeSampleViewController.h"
#import "RecipeSampleTableViewCell.h"
#import <FatSecretKit/FSClient.h>
#import <FatSecretKit/FSRecipeDirections.h>
#import <FatSecretKit/FSRecipeIngredients.h>
#import <FatSecretKit/FSRecipeServings.h>

@interface RecipeSampleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property int currentSelection;
@property BOOL isFirstTime;
@property BOOL isFirstClick;

@property UILabel *calorieValueLabel;
@property UILabel *totalFatValueLabel;
@property UILabel *satFatValueLabel;
@property UILabel *cholesterolValueLabel;
@property UILabel *sodiumValueLabel;
@property UILabel *carbsValueLabel;
@property UILabel *fiberValueLabel;
@property UILabel *sugarsValueLabel;
@property UILabel *proteinValueLabel;

@end

@implementation RecipeSampleViewController
@synthesize categoryArray, currentSelection, myTableView, isFirstTime, isFirstClick, myRecipe, myImageView, calorieValueLabel, totalFatValueLabel, satFatValueLabel, cholesterolValueLabel, sodiumValueLabel, carbsValueLabel, fiberValueLabel, sugarsValueLabel, proteinValueLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    categoryArray = @[@"OVERVIEW", @"INGREDIENTS", @"DIRECTIONS"];
    
    isFirstTime = YES;
    isFirstClick = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"RECIPES";
    
    [self.view addSubview:titleLabel];
    
    myImageView.contentMode = UIViewContentModeScaleAspectFill;
    myImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    myImageView.layer.cornerRadius = myImageView.frame.size.height/2;
    myImageView.clipsToBounds = YES;
    [myImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [myImageView.layer setBorderWidth:2.0];
    
    [self downloadImageWithURL:[NSURL URLWithString:myRecipe.imageUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            myImageView.image = image;
        }
    }];
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
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
    RecipeSampleTableViewCell *cell = (RecipeSampleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RecipeSampleCell"];
    
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
            titleBoxImageView.image = [UIImage imageNamed:@"title_rectangle@2x.png"];
            
            UILabel *foodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 100, 40)];
            foodNameLabel.font = [UIFont fontWithName:@"Oswald" size:13];
            foodNameLabel.textColor = [UIColor whiteColor];
            foodNameLabel.text = [myRecipe.name uppercaseString];
            [foodNameLabel sizeToFit];
            foodNameLabel.frame = CGRectMake((320 - foodNameLabel.frame.size.width)/2, 8, foodNameLabel.frame.size.width, foodNameLabel.frame.size.height);
            
            [cell.contentView addSubview:titleBoxImageView];
            [titleBoxImageView addSubview:foodNameLabel];
            
            UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 320, 10)];
            dividerImageView.image = [UIImage imageNamed:@"divider@2x.png"];
            
            UILabel *prepTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 150, 60, 40)];
            prepTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            prepTimeLabel.textColor = [UIColor whiteColor];
            prepTimeLabel.text = @"PREP TIME";
            [prepTimeLabel sizeToFit];
            prepTimeLabel.frame = CGRectMake( (((320/3)/2) - prepTimeLabel.frame.size.width/2) , 140, prepTimeLabel.frame.size.width, prepTimeLabel.frame.size.height);
            
            UILabel *cookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(136, 150, 60, 40)];
            cookTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            cookTimeLabel.textColor = [UIColor whiteColor];
            cookTimeLabel.text = @"COOK TIME";
            [cookTimeLabel sizeToFit];
            cookTimeLabel.frame = CGRectMake( (((320/3)/2) - cookTimeLabel.frame.size.width/2) + ((320/3) * 1) , 140, cookTimeLabel.frame.size.width, cookTimeLabel.frame.size.height);
            
            UILabel *totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(236, 150, 60, 40)];
            totalTimeLabel.font = [UIFont fontWithName:@"Oswald-Light" size:12];
            totalTimeLabel.textColor = [UIColor whiteColor];
            totalTimeLabel.text = @"TOTAL TIME";
            [totalTimeLabel sizeToFit];
            totalTimeLabel.frame = CGRectMake( (((320/3)/2) - totalTimeLabel.frame.size.width/2) + ((320/3) * 2) , 140, totalTimeLabel.frame.size.width, totalTimeLabel.frame.size.height);
            
            UIView *nutritionView = [[UIView alloc] initWithFrame:CGRectMake(20, 151, 280, 129)];
            [nutritionView setBackgroundColor:[UIColor clearColor]];
            
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
            
            [cell.contentView addSubview:nutritionView];
            
            [[FSClient sharedClient] getRecipe:myRecipe.identifier completion:^(FSRecipe *recipe) {
                UILabel *prepMinLabel = [[UILabel alloc] init];
                prepMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
                prepMinLabel.textColor = [UIColor whiteColor];
                prepMinLabel.text = [NSString stringWithFormat:@"%li", (long)recipe.preparationTimeMin];
                [prepMinLabel sizeToFit];
                
                UILabel *prepMinLabelLabel = [[UILabel alloc] init];
                prepMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
                prepMinLabelLabel.textColor = [UIColor whiteColor];
                prepMinLabelLabel.text = @" MIN";
                [prepMinLabelLabel sizeToFit];
                
                prepMinLabel.frame = CGRectMake( ((320/3)/2) - ((prepMinLabel.frame.size.width + prepMinLabelLabel.frame.size.width)/2), 100, prepMinLabel.frame.size.width, prepMinLabel.frame.size.height);
                prepMinLabelLabel.frame = CGRectMake(prepMinLabel.frame.origin.x
                                                     + prepMinLabel.frame.size.width, 110, prepMinLabelLabel.frame.size.width, prepMinLabelLabel.frame.size.height);
                
                UILabel *cookMinLabel = [[UILabel alloc] init];
                cookMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
                cookMinLabel.textColor = [UIColor whiteColor];
                cookMinLabel.text = [NSString stringWithFormat:@"%li", (long)recipe.cookingTimeMin];
                NSLog(@"cooking time = %li", (long)recipe.cookingTimeMin);
                [cookMinLabel sizeToFit];
                
                UILabel *cookMinLabelLabel = [[UILabel alloc] init];
                cookMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
                cookMinLabelLabel.textColor = [UIColor whiteColor];
                cookMinLabelLabel.text = @" MIN";
                [cookMinLabelLabel sizeToFit];
                
                cookMinLabel.frame = CGRectMake( ((320/3)/2) - ((cookMinLabel.frame.size.width + cookMinLabelLabel.frame.size.width)/2) + ((320/3) * 1), 100, cookMinLabel.frame.size.width, cookMinLabel.frame.size.height);
                cookMinLabelLabel.frame = CGRectMake(cookMinLabel.frame.origin.x
                                                     + cookMinLabel.frame.size.width, 110, cookMinLabelLabel.frame.size.width, cookMinLabelLabel.frame.size.height);
                
                UILabel *totalMinLabel = [[UILabel alloc] init];
                totalMinLabel.font = [UIFont fontWithName:@"Oswald" size:22];
                totalMinLabel.textColor = [UIColor whiteColor];
                totalMinLabel.text = [NSString stringWithFormat:@"%li", ((long)recipe.cookingTimeMin + (long)recipe.preparationTimeMin)];
                [totalMinLabel sizeToFit];
                
                UILabel *totalMinLabelLabel = [[UILabel alloc] init];
                totalMinLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
                totalMinLabelLabel.textColor = [UIColor whiteColor];
                totalMinLabelLabel.text = @" MIN";
                [totalMinLabelLabel sizeToFit];
                
                totalMinLabel.frame = CGRectMake( ((320/3)/2) - ((totalMinLabel.frame.size.width + totalMinLabelLabel.frame.size.width)/2) + ((320/3) * 2), 100, totalMinLabel.frame.size.width, totalMinLabel.frame.size.height);
                totalMinLabelLabel.frame = CGRectMake(totalMinLabel.frame.origin.x
                                                     + totalMinLabel.frame.size.width, 110, totalMinLabelLabel.frame.size.width, totalMinLabelLabel.frame.size.height);

                [cell.contentView addSubview:prepMinLabel];
                [cell.contentView addSubview:prepMinLabelLabel];
                [cell.contentView addSubview:cookMinLabel];
                [cell.contentView addSubview:cookMinLabelLabel];
                [cell.contentView addSubview:totalMinLabel];
                [cell.contentView addSubview:totalMinLabelLabel];
                
                if ([recipe.servings count] != 0) {
                    FSRecipeServings *recipeServings = recipe.servings[0];
                    
                    calorieValueLabel = [[UILabel alloc] init];
                    calorieValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:25];
                    calorieValueLabel.textColor = [UIColor whiteColor];
                    calorieValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.caloriesValue];
                    [calorieValueLabel sizeToFit];
                    calorieValueLabel.textAlignment = NSTextAlignmentCenter;
                    [calorieValueLabel setFrame:CGRectMake(25, calorieLabel.frame.origin.y + calorieLabel.frame.size.height + 5, nutritionView.frame.size.width/3 - 10, lineSeparatorView1.frame.size.height - (calorieLabel.frame.origin.y + calorieLabel.frame.size.height))];
                    [calorieValueLabel sizeToFit];
                    
                    totalFatValueLabel = [[UILabel alloc] init];
                    totalFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    totalFatValueLabel.textColor = [UIColor whiteColor];
                    totalFatValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.fatValue];
                    [totalFatValueLabel sizeToFit];
                    totalFatValueLabel.textAlignment = NSTextAlignmentCenter;
                    [totalFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, 20, 25, totalFatLabel.frame.size.height)];
                    [totalFatValueLabel sizeToFit];
                    
                    satFatValueLabel = [[UILabel alloc] init];
                    satFatValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    satFatValueLabel.textColor = [UIColor whiteColor];
                    satFatValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.saturatedFatValue];
                    [satFatValueLabel sizeToFit];
                    satFatValueLabel.textAlignment = NSTextAlignmentCenter;
                    [satFatValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, satFatLabel.frame.origin.y, 25, totalFatLabel.frame.size.height)];
                    [satFatValueLabel sizeToFit];
                    
                    cholesterolValueLabel = [[UILabel alloc] init];
                    cholesterolValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    cholesterolValueLabel.textColor = [UIColor whiteColor];
                    cholesterolValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.cholesterolValue];
                    [cholesterolValueLabel sizeToFit];
                    cholesterolValueLabel.textAlignment = NSTextAlignmentCenter;
                    [cholesterolValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, cholesterolLabel.frame.origin.y, 25, cholesterolValueLabel.frame.size.height)];
                    [cholesterolValueLabel sizeToFit];
                    
                    sodiumValueLabel = [[UILabel alloc] init];
                    sodiumValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    sodiumValueLabel.textColor = [UIColor whiteColor];
                    sodiumValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.sodiumValue];
                    [sodiumValueLabel sizeToFit];
                    sodiumValueLabel.textAlignment = NSTextAlignmentCenter;
                    [sodiumValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 2) - 32, sodiumLabel.frame.origin.y, 25, sodiumValueLabel.frame.size.height)];
                    [sodiumValueLabel sizeToFit];
                    
                    carbsValueLabel = [[UILabel alloc] init];
                    carbsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    carbsValueLabel.textColor = [UIColor whiteColor];
                    carbsValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.carbohydrateValue];
                    [carbsValueLabel sizeToFit];
                    carbsValueLabel.textAlignment = NSTextAlignmentCenter;
                    [carbsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, 20, 25, carbsLabel.frame.size.height)];
                    [carbsValueLabel sizeToFit];
                    
                    fiberValueLabel = [[UILabel alloc] init];
                    fiberValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    fiberValueLabel.textColor = [UIColor whiteColor];
                    fiberValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.fiberValue];
                    [fiberValueLabel sizeToFit];
                    fiberValueLabel.textAlignment = NSTextAlignmentCenter;
                    [fiberValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, fiberLabel.frame.origin.y, 25, fiberValueLabel.frame.size.height)];
                    [fiberValueLabel sizeToFit];
                    
                    sugarsValueLabel = [[UILabel alloc] init];
                    sugarsValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    sugarsValueLabel.textColor = [UIColor whiteColor];
                    sugarsValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.sugarValue];
                    [sugarsValueLabel sizeToFit];
                    sugarsValueLabel.textAlignment = NSTextAlignmentCenter;
                    [sugarsValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, sugarsLabel.frame.origin.y, 25, sugarsValueLabel.frame.size.height)];
                    [sugarsValueLabel sizeToFit];
                    
                    proteinValueLabel = [[UILabel alloc] init];
                    proteinValueLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
                    proteinValueLabel.textColor = [UIColor whiteColor];
                    proteinValueLabel.text = [NSString stringWithFormat:@"%.1f", recipeServings.proteinValue];
                    [proteinValueLabel sizeToFit];
                    proteinValueLabel.textAlignment = NSTextAlignmentCenter;
                    [proteinValueLabel setFrame:CGRectMake(((nutritionView.frame.size.width/3) * 3) - 27, proteinLabel.frame.origin.y, 25, proteinValueLabel.frame.size.height)];
                    [proteinValueLabel sizeToFit];
                    
                    [nutritionView addSubview:calorieValueLabel];
                    [nutritionView addSubview:totalFatValueLabel];
                    [nutritionView addSubview:satFatValueLabel];
                    [nutritionView addSubview:cholesterolValueLabel];
                    [nutritionView addSubview:sodiumValueLabel];
                    [nutritionView addSubview:carbsValueLabel];
                    [nutritionView addSubview:fiberValueLabel];
                    [nutritionView addSubview:sugarsValueLabel];
                    [nutritionView addSubview:proteinValueLabel];
                    
                    //                    UILabel *caloriesLabel = [[UILabel alloc] init];
//                    caloriesLabel.font = [UIFont fontWithName:@"Oswald" size:30];
//                    caloriesLabel.textColor = [UIColor whiteColor];
//                    caloriesLabel.text = [NSString stringWithFormat:@"%.f", recipeServings.caloriesValue];
//                    [caloriesLabel sizeToFit];
//                    caloriesLabel.frame = CGRectMake(40 - (caloriesLabel.frame.size.width/2), 181, caloriesLabel.frame.size.width, caloriesLabel.frame.size.height);
//                    
//                    UILabel *proteinsLabel = [[UILabel alloc] init];
//                    proteinsLabel.font = [UIFont fontWithName:@"Oswald" size:30];
//                    proteinsLabel.textColor = [UIColor whiteColor];
//                    proteinsLabel.text = [NSString stringWithFormat:@"%.f", recipeServings.proteinValue];
//                    [proteinsLabel sizeToFit];
//                    
//                    UILabel *proteinsLabelLabel = [[UILabel alloc] init];
//                    proteinsLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
//                    proteinsLabelLabel.textColor = [UIColor whiteColor];
//                    proteinsLabelLabel.text = @" g";
//                    [proteinsLabelLabel sizeToFit];
//                    
//                    proteinsLabel.frame = CGRectMake(120 - ((proteinsLabel.frame.size.width + proteinsLabelLabel.frame.size.width)/2), 181, proteinsLabel.frame.size.width, proteinsLabel.frame.size.height);
//                    proteinsLabelLabel.frame = CGRectMake(proteinsLabel.frame.origin.x + proteinsLabel.frame.size.width, 200, proteinsLabelLabel.frame.size.width, proteinsLabelLabel.frame.size.height);
//                    
//                    UILabel *carbsLabel = [[UILabel alloc] init];
//                    carbsLabel.font = [UIFont fontWithName:@"Oswald" size:30];
//                    carbsLabel.textColor = [UIColor whiteColor];
//                    carbsLabel.text = [NSString stringWithFormat:@"%.f", recipeServings.carbohydrateValue];
//                    [carbsLabel sizeToFit];
//                    
//                    UILabel *carbsLabelLabel = [[UILabel alloc] init];
//                    carbsLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
//                    carbsLabelLabel.textColor = [UIColor whiteColor];
//                    carbsLabelLabel.text = @" g";
//                    [carbsLabelLabel sizeToFit];
//                    
//                    carbsLabel.frame = CGRectMake(200 - ((carbsLabel.frame.size.width + carbsLabelLabel.frame.size.width)/2), 181, carbsLabel.frame.size.width, carbsLabel.frame.size.height);
//                    carbsLabelLabel.frame = CGRectMake(carbsLabel.frame.origin.x + carbsLabel.frame.size.width, 200, carbsLabelLabel.frame.size.width, carbsLabelLabel.frame.size.height);
//                    
//                    UILabel *fatsLabel = [[UILabel alloc] init];
//                    fatsLabel.font = [UIFont fontWithName:@"Oswald" size:30];
//                    fatsLabel.textColor = [UIColor whiteColor];
//                    fatsLabel.text = [NSString stringWithFormat:@"%.f", recipeServings.fatValue];
//                    [fatsLabel sizeToFit];
//                    
//                    UILabel *fatsLabelLabel = [[UILabel alloc] init];
//                    fatsLabelLabel.font = [UIFont fontWithName:@"Oswald" size:14];
//                    fatsLabelLabel.textColor = [UIColor whiteColor];
//                    fatsLabelLabel.text = @" g";
//                    [fatsLabelLabel sizeToFit];
//                    
//                    fatsLabel.frame = CGRectMake(280 - ((fatsLabel.frame.size.width + fatsLabelLabel.frame.size.width)/2), 181, fatsLabel.frame.size.width, fatsLabel.frame.size.height);
//                    fatsLabelLabel.frame = CGRectMake(fatsLabel.frame.origin.x + fatsLabel.frame.size.width, 200, fatsLabelLabel.frame.size.width, fatsLabelLabel.frame.size.height);
                    
//                    [cell.contentView addSubview:caloriesLabel];
//                    [cell.contentView addSubview:proteinsLabel];
//                    [cell.contentView addSubview:proteinsLabelLabel];
//                    [cell.contentView addSubview:carbsLabel];
//                    [cell.contentView addSubview:carbsLabelLabel];
//                    [cell.contentView addSubview:fatsLabel];
//                    [cell.contentView addSubview:fatsLabelLabel];
                }
            }];
            
            [cell.contentView addSubview:dividerImageView];
            [cell.contentView addSubview:prepTimeLabel];
            [cell.contentView addSubview:cookTimeLabel];
            [cell.contentView addSubview:totalTimeLabel];
            break;}
        {case 1:
            NSLog(@"");
            [[FSClient sharedClient] getRecipe:myRecipe.identifier completion:^(FSRecipe *recipe) {
                UILabel *servingsLabel = [[UILabel alloc] init];
                servingsLabel.font = [UIFont fontWithName:@"Norican-Regular" size:16];
                servingsLabel.textColor = [UIColor whiteColor];
                servingsLabel.text = [NSString stringWithFormat:@"Makes %li servings", (long)recipe.numberOfServings];
                [servingsLabel sizeToFit];
                servingsLabel.frame = CGRectMake(54, 75, servingsLabel.frame.size.width, servingsLabel.frame.size.height);
                
                UITextView *ingredientsTextView = [[UITextView alloc] init];
                ingredientsTextView.backgroundColor = [UIColor clearColor];
                ingredientsTextView.frame = CGRectMake(60, 110, 220, 135);
                ingredientsTextView.scrollEnabled = YES;
                ingredientsTextView.pagingEnabled = NO;
                ingredientsTextView.editable = NO;
                ingredientsTextView.userInteractionEnabled = YES;
                ingredientsTextView.font = [UIFont fontWithName:@"Oswald-light" size:12];
                ingredientsTextView.textColor = [UIColor whiteColor];
                
                for (int i = 0; i < [recipe.ingredients count]; i++) {
                    FSRecipeIngredients *recipeIngredients = recipe.ingredients[i];
                    
                    ingredientsTextView.text = [NSString stringWithFormat:@"%@ %@", ingredientsTextView.text, recipeIngredients.ingredientDescription];
                    ingredientsTextView.text = [NSString stringWithFormat:@"%@ \n", ingredientsTextView.text];
                }
                
                [cell.contentView addSubview:servingsLabel];
                [cell.contentView addSubview:ingredientsTextView];
            }];
            break;}
        {case 2:
            NSLog(@"");
            [[FSClient sharedClient] getRecipe:myRecipe.identifier completion:^(FSRecipe *recipe) {
                UILabel *preparationLabel = [[UILabel alloc] init];
                preparationLabel.font = [UIFont fontWithName:@"Norican-Regular" size:16];
                preparationLabel.textColor = [UIColor whiteColor];
                preparationLabel.text = @"Preparation";
                [preparationLabel sizeToFit];
                preparationLabel.frame = CGRectMake(59, 76, preparationLabel.frame.size.width, preparationLabel.frame.size.height);
                
                UITextView *directionsTextView = [[UITextView alloc] init];
                directionsTextView.backgroundColor = [UIColor clearColor];
                directionsTextView.frame = CGRectMake(60, 110, 220, 135);
                directionsTextView.scrollEnabled = YES;
                directionsTextView.pagingEnabled = NO;
                directionsTextView.editable = NO;;
                directionsTextView.userInteractionEnabled = YES;
                directionsTextView.font = [UIFont fontWithName:@"Oswald-Light" size:12];
                directionsTextView.textColor = [UIColor whiteColor];
                
                for (int i = 0; i < [recipe.directions count]; i++) {
                    FSRecipeDirections *recipeDirections = recipe.directions[i];
                    directionsTextView.text = [NSString stringWithFormat:@"%@ %@", directionsTextView.text, recipeDirections.directionDescription];
                    directionsTextView.text = [NSString stringWithFormat:@"%@ \n \n", directionsTextView.text];
                    NSLog(@"test");
                }
                
                [cell.contentView addSubview:preparationLabel];
                [cell.contentView addSubview:directionsTextView];
            }];

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
        RecipeSampleTableViewCell *cell = (RecipeSampleTableViewCell *)[tableView cellForRowAtIndexPath:myIndexPath];
        cell.myImageView.image = [UIImage imageNamed:@"downArrow.png"];
        isFirstClick = NO;
    }
    
    int row = (int)[indexPath row];
    currentSelection = row;
    
    RecipeSampleTableViewCell* cell = (RecipeSampleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"upArrow.png"];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeSampleTableViewCell* cell = (RecipeSampleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.myImageView.image = [UIImage imageNamed:@"downArrow.png"];
    cell.myTitleLabel.text = categoryArray[indexPath.row];
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == currentSelection) {
        return 269;
    }
    else {
        return 55;
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
