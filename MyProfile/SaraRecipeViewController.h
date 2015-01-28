//
//  SaraRecipeViewController.h
//  MyProfile
//
//  Created by Apple on 05/01/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SaraRecipeViewController : UIViewController

@property (nonatomic, strong) PFObject *myRecipe;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet PFImageView *myPFImageView;

- (IBAction)backButtonTouched:(id)sender;

@end
