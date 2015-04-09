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

@import EventKit;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *iconImagepathArray;
@property BOOL is35;

@property NSArray *reminders;

@property NSDictionary *nextReminderDictionary;
@property NSTimeInterval secondsBetween;
@property NSString *intermittentImageName;

// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@property (strong, nonatomic) EKCalendar *calendar;

@end

@implementation MenuViewController
@synthesize myTableView, categoryArray, iconImagepathArray, is35, nextReminderDictionary, secondsBetween, intermittentImageName;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
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
       
        [self updateAuthorizationStatusToAccessEventStore];
        [self fetchReminders];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    categoryArray = @[@"MY PROFILE", @"FEAST TRACKER", @"INTERMITTENT FASTING", @"SARA'S RECIPES", @"MORE"];
    iconImagepathArray = [[NSMutableArray alloc] initWithArray:@[@"myprofile_icon@2x.png", @"dailytracker_icon@2x.png", @"intermittent.png", @"recipes_icon@2x.png", @"more_icon@2x.png"]];
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

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak MenuViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                });
                                            }];
            break;
        }
    }
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = @"IFCalendar";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = @"IFCalendar";
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (void)fetchReminders {
    if (self.isAccessToEventStoreGranted) {
        // 1
        NSPredicate *predicate =
        [self.eventStore predicateForRemindersInCalendars:@[self.calendar]];
        
        // 2
        [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
            // 3
            dispatch_async(dispatch_get_main_queue(), ^{
                self.reminders = [self sortReminders:reminders];
                nextReminderDictionary = [self determineTimeandTypeOfNextReminder:self.reminders];
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                
                NSLog(@"The time of the next reminder is %@", [gregorianCalendar dateFromComponents:[nextReminderDictionary objectForKey:@"dateComponents"]]);
                NSLog(@"The type of the next reminder is %@", [nextReminderDictionary objectForKey:@"type"]);
                
                if ([[nextReminderDictionary objectForKey:@"type"] isEqualToString:@"eating"]) {
                    intermittentImageName = @"intermittent_fastingtimer_active@2x.png";
                } else if ([[nextReminderDictionary objectForKey:@"type"] isEqualToString:@"fasting"]) {
                    intermittentImageName = @"intermittent_eatingtimer_active@2x.png";
                } else {
                    intermittentImageName = @"intermittent.png";
                }
                
                [iconImagepathArray setObject:intermittentImageName atIndexedSubscript:2];
                
                NSLog(@"%@", iconImagepathArray);
                
                [myTableView reloadData];
            });
        }];
    }
}

-(NSArray *) sortReminders:(NSArray *)reminderArray {
    NSArray *sortedArray;
    
    sortedArray = [reminderArray sortedArrayUsingComparator:^NSComparisonResult(EKReminder *a, EKReminder *b) {
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *firstDateComponent = a.dueDateComponents;
        NSDateComponents *secondDateComponent = b.dueDateComponents;
        
        NSDate *first = [gregorianCalendar dateFromComponents:firstDateComponent];
        NSDate *second = [gregorianCalendar dateFromComponents:secondDateComponent];
        return [first compare:second];
    }];
    
    return sortedArray;
}

-(NSDictionary *) determineTimeandTypeOfNextReminder:(NSArray *)reminderArray {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentMoment = [NSDate date];
    
    EKReminder *nextReminder = [[EKReminder alloc] init];
    nextReminder = nil;
    
    for (int i = 0; i < [reminderArray count]; i++) {
        EKReminder *tempReminder = reminderArray[i];
        NSDate *tempReminderDate = [gregorianCalendar dateFromComponents:tempReminder.dueDateComponents];
        NSDate *nextReminderDate = [gregorianCalendar dateFromComponents:nextReminder.dueDateComponents];
        
        if ([currentMoment compare:tempReminderDate] == NSOrderedAscending) {
            if (nextReminder == nil) {
                nextReminder = tempReminder;
            } else if ([nextReminderDate compare:tempReminderDate] == NSOrderedDescending) {
                nextReminder = tempReminder;
            }
        }
    }
    
    NSDateComponents *reminderDueDateComponents = [[NSDateComponents alloc] init];
    if (nextReminder) {
        reminderDueDateComponents = nextReminder.dueDateComponents;
    }
    
    NSString *reminderType = [[NSString alloc] init];
    reminderType = nil;
    if (nextReminder) {
        if ([nextReminder.title isEqualToString:@"Time to start eating"]) {
            reminderType = @"eating";
        } else if ([nextReminder.title isEqualToString:@"Time to start fasting"]) {
            reminderType = @"fasting";
        }
    }
    
    NSDictionary *reminderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:reminderType, @"type", reminderDueDateComponents, @"dateComponents", nil];
    
    return reminderDictionary;
}

@end
