//
//  IntermittentFastingViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 11/10/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface IntermittentFastingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSArray *protocolArray;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)protocolHelpButtonTouched:(id)sender;
- (IBAction)startButtonTouched:(id)sender;

@end
