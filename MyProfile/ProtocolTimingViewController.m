//
//  ProtocolTimingViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 24/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ProtocolTimingViewController.h"

@interface ProtocolTimingViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSMutableArray *hourArray;
@property NSMutableArray *minuteArray;

@end

@implementation ProtocolTimingViewController
@synthesize myEatingPickerView, myFastingPickerView, hourArray, minuteArray, protocolSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Cancel all Notifications

    UIApplication* app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
    
    // 1. Save data as NSDate.
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    [comp setHour: [myEatingPickerView selectedRowInComponent:0]];
    [comp setMinute: [myEatingPickerView selectedRowInComponent:1]];    
    NSDate *eatingDate = [[NSCalendar currentCalendar] dateFromComponents:comp];
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
    NSMutableArray *notificationArray = [NSMutableArray new];
    
    for (int i = 0; i < 13; i++) {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = eatingNotificationDate;
        localNotification.alertBody = @"Time to start eating";
        localNotification.alertAction = @"Ok";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [app scheduleLocalNotification:localNotification];
        
        UILocalNotification* fastingLocalNotification = [[UILocalNotification alloc] init];
        fastingLocalNotification.fireDate = fastingNotificationDate;
        fastingLocalNotification.alertBody = @"Time to start fasting";
        fastingLocalNotification.alertAction = @"Ok";
        fastingLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
        fastingLocalNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [app scheduleLocalNotification:fastingLocalNotification];
        
        eatingNotificationDate = [eatingNotificationDate dateByAddingTimeInterval:window];
        fastingNotificationDate = [fastingNotificationDate dateByAddingTimeInterval:window];
    }
    
    // 2. END
    
    // 3. Create a notification for the 14th day, that also informs the user to re-enter his/her settings
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = eatingNotificationDate;
    localNotification.alertBody = @"Time to start eating, also don't forget to re-enter your intermittent fasting notification settings.";
    localNotification.alertAction = @"Ok";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [app scheduleLocalNotification:localNotification];
    
    UILocalNotification* fastingLocalNotification = [[UILocalNotification alloc] init];
    fastingLocalNotification.fireDate = fastingNotificationDate;
    fastingLocalNotification.alertBody = @"Time to start fasting, also don't forget to re-enter your intermittent fasting notification settings.";
    fastingLocalNotification.alertAction = @"Ok";
    fastingLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    fastingLocalNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [app scheduleLocalNotification:fastingLocalNotification];
    
    // 3. END
    
    // Show an alert telling the user his settings have been entered and he will recieve notifications till fastingNotificationDate
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:fastingNotificationDate];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notifications Saved" message:[NSString stringWithFormat:@"Your settings have been entered, and you will recieve notifications till %@", dateString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
