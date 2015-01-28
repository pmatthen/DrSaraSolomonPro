//
//  VideosWebViewController.h
//  MyProfile
//
//  Created by Apple on 10/01/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideosWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

- (IBAction)backButtonTouched:(id)sender;

@end
