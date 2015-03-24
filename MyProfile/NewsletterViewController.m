//
//  NewsletterViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 01/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "NewsletterViewController.h"
#import <TDOAuth.h>

@interface NewsletterViewController ()
{
    NSString *token;
    NSString *tokenSecret;
    BOOL is35;
}
@end

@implementation NewsletterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"NEWSLETTER";
    
    [self.view addSubview:titleLabel];
    
    //TDOAuth code
    
    [self getRequestToken];
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

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)joinButtonTouched:(id)sender {
}

- (void) getRequestToken {
    //withings additional params
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"oob" forKey:@"oauth_callback"];
    
    //init request
    NSURLRequest *rq = [TDOAuth URLRequestForPath:@"/request_token" GETParameters:dict scheme:@"https" host:@"aweber_api/aweber_api.php" consumerKey:@"AkvOUVruFXN9VgOanp0bPP9m" consumerSecret:@"S1IVJH9WnXtBAuK9HwhbFmSqYqbBpfHu7Q4OCHnH" accessToken:nil tokenSecret:nil];
    
    //fire request
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:rq  returningResponse:&response error:&error];
    NSString *s = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"s = %@", s);
    //parse result
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *split = [s componentsSeparatedByString:@"&"];
    for (NSString *str in split){
        NSArray *split2 = [str componentsSeparatedByString:@"="];
        [params setObject:split2[1] forKey:split2[0]];
    }
    
    token = params[@"oauth_token"];
    tokenSecret = params[@"oauth_token_secret"];
    
    NSLog(@"token = %@", token);
    NSLog(@"token secret = %@", tokenSecret);
}

@end
