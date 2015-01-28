//
//  VideosWebViewController.m
//  MyProfile
//
//  Created by Apple on 10/01/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "VideosWebViewController.h"

@interface VideosWebViewController ()

@end

@implementation VideosWebViewController
@synthesize myWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"VIDEOS";
    
    [self.view addSubview:titleLabel];
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.youtube.com/user/ssolom9/videos"];
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
