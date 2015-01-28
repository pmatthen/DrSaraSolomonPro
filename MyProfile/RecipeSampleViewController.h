//
//  RecipeSampleViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 10/06/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FatSecretKit/FSRecipe.h>
#import <Parse/Parse.h>

@interface RecipeSampleViewController : UIViewController

@property (nonatomic, strong) FSRecipe *myRecipe;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

- (IBAction)backButtonTouched:(id)sender;

@end
