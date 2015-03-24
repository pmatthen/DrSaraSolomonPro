//
//  RecipeViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 24/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipeTableViewCell.h"

@interface RecipeViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property BOOL is35;

@end

@implementation RecipeViewController
@synthesize categoryArray, myTableView, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"RECIPES";
    
    UILabel *mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 97, 100, 100)];
    if (is35) {
        mainTitleLabel.frame = CGRectMake(124, 82, 100, 85);
    }
    mainTitleLabel.font = [UIFont fontWithName:@"Oswald" size:23];
    mainTitleLabel.textColor = [UIColor whiteColor];
    mainTitleLabel.text = @"RECIPES";
    [mainTitleLabel sizeToFit];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:mainTitleLabel];
    
    categoryArray = @[@"SORT BY MEAL", @"SORT BY NAME", @"SEARCH FOR FOOD", @"SEARCH FOR RECIPES"];
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
    RecipeTableViewCell *cell = (RecipeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.myImageView.image = [UIImage imageNamed:@"arrow@2x.png"];
    
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 45, 100, 50)];
    if (is35) {
        cellTitleLabel.frame = CGRectMake(38, 38, 100, 42);
    }
    cellTitleLabel.font = [UIFont fontWithName:@"Oswald" size:18];
    cellTitleLabel.textColor = [UIColor whiteColor];
    cellTitleLabel.text = categoryArray[indexPath.row];
    [cellTitleLabel sizeToFit];
    
    [cell addSubview:cellTitleLabel];
        
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"test");
    
    switch (indexPath.row) {
        case 0:
            NSLog(@"test");
            break;
        case 1:
            NSLog(@"test");
            break;
        case 2:
            NSLog(@"test");
            break;
        case 3:
            [self performSegueWithIdentifier:@"RecipeSearchSegue" sender:self];
            NSLog(@"test");
            break;
        default:
            break;
    }
    
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
