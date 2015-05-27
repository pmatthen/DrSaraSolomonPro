//
//  HowToViewController.m
//  Dr Sara Solomon Pro
//
//  Created by Poulose Matthen on 13/04/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "HowToViewController.h"

@interface HowToViewController ()

@end

@implementation HowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(void)playMovie:(id)sender
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"HowTo" ofType:@"m4v"]];
    
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    [[_moviePlayer view] setFrame:CGRectMake(0, 55, 320, 513)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

@end
