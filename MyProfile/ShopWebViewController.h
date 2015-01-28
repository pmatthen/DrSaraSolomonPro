//
//  ShopWebViewController.h
//  MyProfile
//
//  Created by Poulose Matthen on 20/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopWebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property NSURL *url;
@property NSString *titleString;

- (IBAction)backButtonTouched:(id)sender;

@end
