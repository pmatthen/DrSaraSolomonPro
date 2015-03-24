//
//  ViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 05/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuViewTableViewCell.h"
#import "InitialViewController.h"
#import "CoreDataStack.h"
#import "User.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *iconImagepathArray;
@property BOOL is35;

@end

@implementation MenuViewController
@synthesize myTableView, categoryArray, iconImagepathArray, is35;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    NSString *storyBoardName = @"iPhone4";
    if (is35) {
        storyBoardName = @"iPhone35";
    }
    
    if (![PFUser currentUser]) {
        UINavigationController *myInitialNavigationController = [UINavigationController new];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
        myInitialNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitialNavigationController"];
        
        [self presentViewController:myInitialNavigationController animated:animated completion:nil];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[PFUser currentUser] objectId] forKey:@"loggedOnUserID"];
        [defaults synchronize];
        
        [self initializeCoreDataUser];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    categoryArray = @[@"MY PROFILE", @"FEAST TRACKER", @"INTERMITTENT FASTING", @"SARA'S RECIPES", @"MORE"];
    iconImagepathArray = @[@"myprofile_icon@2x.png", @"dailytracker_icon@2x.png", @"intermittent.png", @"recipes_icon@2x.png", @"more_icon@2x.png"];
}

- (void) initializeCoreDataUser {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]];
    
    NSError *error = nil;
    NSUInteger count = [coreDataStack.managedObjectContext countForFetchRequest:request error:&error];

    if (count > 0) {
        NSLog(@"User exists and count = %lu", (unsigned long)count);
    } else {
        NSLog(@"User nil");
        User *currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:coreDataStack.managedObjectContext];
        currentUser.objectId = [[PFUser currentUser] objectId];
        currentUser.dateCreated = [[PFUser currentUser] createdAt];
        currentUser.name = [[PFUser currentUser] objectForKey:@"name"];
        currentUser.activityFactor = [[PFUser currentUser] objectForKey:@"neat"];
        currentUser.email = [[PFUser currentUser] objectForKey:@"email"];
        currentUser.height = [[PFUser currentUser] objectForKey:@"height"];
        currentUser.initialWeight = [[PFUser currentUser] objectForKey:@"weight"];
        currentUser.age = [[PFUser currentUser] objectForKey:@"age"];
        currentUser.username = [[PFUser currentUser] objectForKey:@"username"];
        currentUser.gender = [[PFUser currentUser] objectForKey:@"gender"];
        currentUser.protocolTypeSelected = 0;
        currentUser.initialBeginFastingTime = [NSDate date];
        currentUser.fNotifications = [NSNumber numberWithBool:NO];
        currentUser.eNotifications = [NSNumber numberWithBool:NO];

        [coreDataStack saveContext];
        
        NSLog(@"createdAt = %@", currentUser.dateCreated);
    }
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [signUpController dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"sender = %@", sender);
}

#pragma mark - tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuViewTableViewCell *cell = (MenuViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    cell.categoryTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    cell.categoryTitleLabel.text = categoryArray[indexPath.row];
    cell.categoryTitleLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(255, 41, 43, 48)];
    if (is35) {
        arrowImageView.frame = CGRectMake(262, 35, 36, 41);
    }
    arrowImageView.image = [UIImage imageNamed:@"MainMenu - arrow@2x.png"];
    [cell addSubview:arrowImageView];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_rectangle@2x.png"]];
    cell.myImageView.image = [UIImage imageNamed:iconImagepathArray[indexPath.row]];
    cell.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"MyProfileSegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"DailyTrackerSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"IntermittentFastingSegue" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"RecipeSearchSegue" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"MoreSegue" sender:self];
            break;
        default:
            break;
    }
}

@end
