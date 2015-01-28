//
//  MyProfileViewController.h
//  MyProfile
//
//  Created by Vanaja Matthen on 06/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@interface MyProfileViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property UIPickerView *myPickerView;
@property NSMutableArray *weightArray;
@property (strong, nonatomic) IBOutlet UIButton *myCameraButton;

-(IBAction)backButtonTouched:(id)sender;
- (IBAction)cameraButtonTouched:(id)sender;

@end
