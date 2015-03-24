//
//  RecipeSearchViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 14/08/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "RecipeSearchViewController.h"
#import "RecipeSearchTableViewCell.h"
#import "RecipeSampleViewController.h"
#import <FatSecretKit/FSClient.h>
#import <FatSecretKit/FSRecipe.h>

@interface RecipeSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *resultsArray;
@property (nonatomic, strong) FSRecipe *recipeToSend;
@property BOOL is35;

@end

@implementation RecipeSearchViewController
@synthesize myTableView, resultsArray, recipeToSend, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    resultsArray = [NSArray new];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"RECIPES";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Recipe"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            resultsArray = objects;
            [myTableView reloadData];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [self.view addSubview:titleLabel];
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
    RecipeSearchTableViewCell *cell = (RecipeSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecipeSearchCell"];

    PFObject *tempObject = resultsArray[indexPath.row];
    
    cell.myTableViewCellTextLabel.textColor = [UIColor whiteColor];
    cell.myTableViewCellTextLabel.font = [UIFont fontWithName:@"Oswald-Light" size:15];
    cell.myTableViewCellTextLabel.text = [tempObject[@"name"] lowercaseString];
    
    PFFile *thumbnail = [tempObject objectForKey:@"image"];
    cell.thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    cell.thumbnailImageView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
    cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.height/2;
    cell.thumbnailImageView.clipsToBounds = YES;
    [cell.thumbnailImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cell.thumbnailImageView.layer setBorderWidth:1.0];
    cell.thumbnailImageView.file = thumbnail;
    [cell.thumbnailImageView loadInBackground];
    
    cell.myTableViewCellImageView.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    recipeToSend = resultsArray[indexPath.row];
    [self performSegueWithIdentifier:@"RecipeSampleSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RecipeSampleViewController *recipeSampleViewController = (RecipeSampleViewController *) segue.destinationViewController;
    
    recipeSampleViewController.myRecipe = recipeToSend;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    [self searchButtonPressed:self];
    
    return YES;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchButtonPressed:(id)sender {
    //
}

@end
