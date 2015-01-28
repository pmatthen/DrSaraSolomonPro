//
//  ProtocolTimingViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 24/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtocolTimingViewController : UIViewController

@property int protocolSelection;

@property (weak, nonatomic) IBOutlet UIPickerView *myEatingPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *myFastingPickerView;

- (IBAction)backButtonTouched:(id)sender;
- (IBAction)updateSettingsButtonTouched:(id)sender;

@end
