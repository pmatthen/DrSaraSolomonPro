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

@interface MoreViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *categoryArray;

@end

@implementation MoreViewController
@synthesize myTableView, categoryArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categoryArray = @[@"WORKOUTS", @"SHOP", @"ABOUT", @"PRIVACY POLICY", @"TERMS OF SERVICE"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
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
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"VideoSegue" sender:self];
    }
    if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"ShopSegue" sender:self];
    }
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"AboutSegue" sender:self];
    }
    if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"PrivacySegue" sender:self];
    }
    if (indexPath.row == 4) {
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
    UINavigationController *myInitialNavigationController = [UINavigationController new];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    myInitialNavigationController = [mainStoryboard instantiateViewControllerWithIdentifier:@"InitialNavigationController"];
    
    [self presentViewController:myInitialNavigationController animated:NO completion:nil];
}

- (IBAction)resetDataButtonTouched:(id)sender {
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Reset" message:@"All user data has been deleted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [logInController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
