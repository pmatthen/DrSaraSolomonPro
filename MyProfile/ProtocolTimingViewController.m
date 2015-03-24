//
//  ProtocolTimingViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 24/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ProtocolTimingViewController.h"
#import "MenuViewController.h"

@import EventKit;

@interface ProtocolTimingViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSMutableArray *hourArray;
@property NSMutableArray *minuteArray;

// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@property (strong, nonatomic) EKCalendar *calendar;

@end

@implementation ProtocolTimingViewController
@synthesize myEatingPickerView, myFastingPickerView, hourArray, minuteArray, protocolSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateAuthorizationStatusToAccessEventStore];
    
    hourArray = [NSMutableArray new];
    for (int i = 0; i < 24; i++) {
        [hourArray addObject:[NSNumber numberWithInt:i]];
    }
    
    minuteArray = [NSMutableArray new];
    for (int i = 0; i < 60; i++) {
        [minuteArray addObject:[NSNumber numberWithInt:i]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    int eatingWindow = 0;
    switch (protocolSelection) {
        case 1:
            eatingWindow = 4;
            break;
        case 2:
            eatingWindow = 8;
            break;
        case 3:
            eatingWindow = 12;
            break;
        default:
            break;
    }
    
    [myFastingPickerView selectRow:(([myEatingPickerView selectedRowInComponent:0] + eatingWindow) % 24) inComponent:0 animated:YES];
    [myFastingPickerView selectRow:[myEatingPickerView selectedRowInComponent:1] inComponent:1 animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [hourArray count];
    }
    
    return [minuteArray count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component){
        case 0:
            return 60.0f;
        case 1:
            return 60.0f;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [hourArray description];
    }
    
    return [minuteArray description];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Oswald" size:26];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        if ([hourArray[row] integerValue] < 10) {
            label.text = [NSString stringWithFormat:@"0%@", hourArray[row]];
        } else {
            label.text = [NSString stringWithFormat:@"%@", hourArray[row]];
        }
    } else {
        if ([minuteArray[row] integerValue] < 10) {
            label.text = [NSString stringWithFormat:@"0%@", minuteArray[row]];
        } else {
            label.text = [NSString stringWithFormat:@"%@", minuteArray[row]];
        }
    }
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int fastingWindow = 0;
    int eatingWindow = 0;
    switch (protocolSelection) {
        case 1:
            fastingWindow = 20;
            eatingWindow = 4;
            break;
        case 2:
            fastingWindow = 16;
            eatingWindow = 8;
            break;
        case 3:
            fastingWindow = 36;
            eatingWindow = 12;
            break;
        default:
            break;
    }
    
    if (pickerView == myEatingPickerView) {
        [myFastingPickerView selectRow:(([myEatingPickerView selectedRowInComponent:0] + eatingWindow) % 24) inComponent:0 animated:YES];
        [myFastingPickerView selectRow:[myEatingPickerView selectedRowInComponent:1] inComponent:1 animated:YES];
    } else {
        [myEatingPickerView selectRow:(([myFastingPickerView selectedRowInComponent:0] + fastingWindow) % 24) inComponent:0 animated:YES];
        [myEatingPickerView selectRow:[myFastingPickerView selectedRowInComponent:1] inComponent:1 animated:YES];
    }
}

- (NSDate *) saveCustomNSDate:(int)hour minute:(int)minutes {
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:[currentComponents year]];
    [components setYear:[currentComponents month]];
    [components setYear:[currentComponents day]];
    [components setYear:[currentComponents hour]];
    [components setYear:[currentComponents minute]];
    [components setYear:[currentComponents second]];
    
    return [calendar dateFromComponents:components];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateSettingsButtonTouched:(id)sender {
    //
    if (!self.isAccessToEventStoreGranted)
        return;
    
    // 1. Save data as NSDate.
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *today = [gregorianCalendar components:unitFlags fromDate:[NSDate date]];

    [today setHour: [myEatingPickerView selectedRowInComponent:0]];
    [today setMinute: [myEatingPickerView selectedRowInComponent:1]];
    [today setSecond:0];
    
    NSDate *eatingDate = [[NSCalendar currentCalendar] dateFromComponents:today];
    NSLog(@"eating date = %@", eatingDate);
    NSDate *fastingDate = [[NSDate alloc] init];
    
    // 1. END
    
    // 2. Make a for loop that creates notifications that last 13 days
    
    int window = 0;
    switch (protocolSelection) {
        case 1:
            window = 24*60*60;
            fastingDate = [eatingDate dateByAddingTimeInterval:4*60*60];
            break;
        case 2:
            window = 24*60*60;
            fastingDate = [eatingDate dateByAddingTimeInterval:8*60*60];
            break;
        case 3:
            window = 48*60*60;
            fastingDate = [eatingDate dateByAddingTimeInterval:12*60*60];
            break;
        default:
            break;
    }
    
    NSDate *eatingNotificationDate = eatingDate;
    NSDate *fastingNotificationDate = fastingDate;
    
    for (int i = 0; i < 13; i++) {
        //
        EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
        reminder.title = @"Time to start eating";
        reminder.calendar = self.calendar;
        reminder.dueDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit  fromDate:eatingDate];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:eatingNotificationDate];
        [reminder addAlarm:alarm];
        
        //
        NSError *error = nil;
        BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
        if (!success) {
            // Handle error.
        }
        
        EKReminder *reminderFasting = [EKReminder reminderWithEventStore:self.eventStore];
        reminder.title = @"Time to start fasting";
        reminder.calendar = self.calendar;
        reminder.dueDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit  fromDate:fastingDate];
        alarm = [EKAlarm alarmWithAbsoluteDate:fastingNotificationDate];
        [reminderFasting addAlarm:alarm];
        
        //
        error = nil;
        success = [self.eventStore saveReminder:reminderFasting commit:YES error:&error];
        if (!success) {
            // Handle error.
        }
        
        eatingNotificationDate = [eatingNotificationDate dateByAddingTimeInterval:window];
        fastingNotificationDate = [fastingNotificationDate dateByAddingTimeInterval:window];
    }
    
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = @"Time to start eating";
    reminder.calendar = self.calendar;
    reminder.dueDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit  fromDate:eatingDate];
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:eatingNotificationDate];
    [reminder addAlarm:alarm];
    
    //
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (!success) {
        // Handle error.
    }
    
    EKReminder *reminderFasting = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = @"Time to start fasting";
    reminder.calendar = self.calendar;
    reminder.dueDateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit  fromDate:fastingDate];
    alarm = [EKAlarm alarmWithAbsoluteDate:fastingNotificationDate];
    [reminderFasting addAlarm:alarm];
    
    //
    error = nil;
    success = [self.eventStore saveReminder:reminderFasting commit:YES error:&error];
    if (!success) {
        // Handle error.
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:fastingNotificationDate];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notifications Saved" message:[NSString stringWithFormat:@"Your settings have been entered, and you will recieve notifications till %@", dateString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    [self goToDailyTrackerViewController];
}

- (void) goToDailyTrackerViewController {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[MenuViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
        }
    }
}

// 1
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
            __weak ProtocolTimingViewController *weakSelf = self;
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

@end
