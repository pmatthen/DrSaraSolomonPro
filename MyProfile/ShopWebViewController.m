//
//  ShopWebViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 20/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ShopWebViewController.h"

@interface ShopWebViewController ()

@property BOOL is35;

@end

@implementation ShopWebViewController
@synthesize myWebView, url, titleString, is35;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 250, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 250, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = titleString;
    
    [self.view addSubview:titleLabel];

    NSURLRequest *myURLRequest = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:myURLRequest];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
