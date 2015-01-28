//
//  InitialViewController.h
//  MyProfile
//
//  Created by Vanaja Matthen on 14/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *myPageControl;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property UIImageView *myImageView;
@property UIImage *myImage;
@property NSArray *myImageViewArray;
@property (nonatomic, strong) NSArray *choiceArray;

@end
