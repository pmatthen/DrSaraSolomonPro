//
//  HowToViewController.h
//  Dr Sara Solomon Pro
//
//  Created by Poulose Matthen on 13/04/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface HowToViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

- (IBAction)playMovie:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
