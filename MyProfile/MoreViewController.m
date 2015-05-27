//
//  MoreViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 12/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ShopWebViewController.h"
#import "User.h"

@interface MoreViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property BOOL is35;

@end

@implementation MoreViewController
@synthesize myTableView, categoryArray, is35;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    categoryArray = @[@"WORKOUTS", @"GOODIES", @"HOW TO VIDEO", @"ABOUT", @"PRIVACY POLICY", @"TERMS OF SERVICE"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"MORE";
    
    [self.view addSubview:titleLabel];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *login = [PFLogInViewController new];
        login.delegate = self;
        login.signUpController.delegate = self;
        [self presentViewController:login animated:animated completion:nil];
    }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
    
    cell.categoryTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:20];
    cell.categoryTitleLabel.text = categoryArray[indexPath.row];
    cell.categoryTitleLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"so touched");
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"VideoSegue" sender:self];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"ShopSegue" sender:self];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"HowToSegue" sender:self];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"AboutSegue" sender:self];
    }
    if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"PrivacySegue" sender:self];
    }
    if (indexPath.row == 5) {
        [self performSegueWithIdentifier:@"TermsSegue" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PrivacySegue"]) {
        ShopWebViewController *myShopeWebViewController = (ShopWebViewController *) segue.destinationViewController;
        myShopeWebViewController.url = [NSURL URLWithString:@"http://www.drsarasolomon.com/privacy/"];
        myShopeWebViewController.titleString = @"PRIVACY POLICY";
    }
    if ([segue.identifier isEqualToString:@"TermsSegue"]) {
        ShopWebViewController *myShopeWebViewController = (ShopWebViewController *) segue.destinationViewController;
        myShopeWebViewController.url = [NSURL URLWithString:@"http://www.drsarasolomon.com/terms-of-service/"];
        myShopeWebViewController.titleString = @"TERMS OF SERVICE";
    }
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)logoutButtonTouched:(id)sender {
    [PFUser logOut];
    
    NSString *storyBoardName = @"iPhone4";
    if (is35) {
        storyBoardName = @"iPhone35";
    }
    
    UINavigationController *myInitialNavigationController = [UINavigationController new];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyBoardName bundle: nil];
    myInitialNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitialNavigationController"];
    
    [self presentViewController:myInitialNavigationController animated:NO completion:nil];
}

- (IBAction)resetDataButtonTouched:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete existing data?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        //
    } else {
        CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
        
        NSFetchRequest *recordedWeightfetchRequest = [[NSFetchRequest alloc] init];
        [recordedWeightfetchRequest setEntity:[NSEntityDescription entityForName:@"RecordedWeight" inManagedObjectContext:coreDataStack.managedObjectContext]];
        
        NSError *error = nil;
        NSArray *recordedWeightfetchRequestArray = [coreDataStack.managedObjectContext executeFetchRequest:recordedWeightfetchRequest error:&error];
        
        for (int i = 0; i < [recordedWeightfetchRequestArray count]; i++) {
            [coreDataStack.managedObjectContext deleteObject:recordedWeightfetchRequestArray[i]];
        }
        
        [coreDataStack.managedObjectContext save:&error];
        
        NSFetchRequest *macroCalculatorfetchRequest = [[NSFetchRequest alloc] init];
        [macroCalculatorfetchRequest setEntity:[NSEntityDescription entityForName:@"MacroCalculatorDetails" inManagedObjectContext:coreDataStack.managedObjectContext]];
        
        NSArray *macroCalculatorfetchRequestArray = [coreDataStack.managedObjectContext executeFetchRequest:macroCalculatorfetchRequest error:&error];
        
        for (int i = 0; i < [macroCalculatorfetchRequestArray count]; i++) {
            [coreDataStack.managedObjectContext deleteObject:macroCalculatorfetchRequestArray[i]];
        }
        
        [coreDataStack.managedObjectContext save:&error];
        
        NSFetchRequest *foodTrackerfetchRequest = [[NSFetchRequest alloc] init];
        [foodTrackerfetchRequest setEntity:[NSEntityDescription entityForName:@"FoodTrackerItem" inManagedObjectContext:coreDataStack.managedObjectContext]];
        
        NSArray *foodTrackerfetchRequestArray = [coreDataStack.managedObjectContext executeFetchRequest:foodTrackerfetchRequest error:&error];
        
        for (int i = 0; i < [foodTrackerfetchRequestArray count]; i++) {
            [coreDataStack.managedObjectContext deleteObject:foodTrackerfetchRequestArray[i]];
        }
        
        [coreDataStack.managedObjectContext save:&error];
        
        NSFetchRequest *userFetchRequest = [[NSFetchRequest alloc] init];
        [userFetchRequest setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:coreDataStack.managedObjectContext]];
        
        NSArray *userFetchRequestArray = [coreDataStack.managedObjectContext executeFetchRequest:userFetchRequest error:&error];
        
        for (int i = 0; i < [userFetchRequestArray count]; i++) {
            User *user = userFetchRequestArray[i];
            [user setUserPhoto:nil];
        }
        
        [coreDataStack.managedObjectContext save:&error];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Reset" message:@"All user data has been deleted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
