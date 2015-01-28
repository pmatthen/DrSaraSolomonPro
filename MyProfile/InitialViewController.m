//
//  InitialViewController.m
//  MyProfile
//
//  Created by Vanaja Matthen on 14/05/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "InitialViewController.h"
#import "InitialViewControlllerTableViewCell.h"
#import "ParseSignUpViewControllerStep1.h"

#define DURATION_BEFORE_SLIDE_TRANSITION 2.0

@interface InitialViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation InitialViewController
@synthesize myImage, myImageView, myImageViewArray, myScrollView, myPageControl, myTableView, choiceArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    choiceArray = @[@"SIGN UP TODAY", @"Already have an account? Log in here"];
    
    CGFloat width = 0.0;
    
    myImageViewArray = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]], [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]], [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    
    int i = 0;
    for (UIImageView *tempImageView in myImageViewArray) {
        tempImageView.frame = CGRectMake(width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [tempImageView setBackgroundColor:[UIColor clearColor]];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(77, 97, 169, 176)];
        UILabel *iconTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 279, 80, 40)];
        UILabel *iconSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 321, 80, 40)];
        
        switch (i) {
            case 0:
                iconImageView.image = [UIImage imageNamed:@"ss_logo.png"];
                iconTitleLabel.font = [UIFont fontWithName:@"Norican-Regular" size:31];
                iconTitleLabel.textColor = [UIColor whiteColor];
                iconTitleLabel.text = @"Intermittent Fasting";
                [iconTitleLabel sizeToFit];
                iconSubTitleLabel.font = [UIFont fontWithName:@"Oswald" size:12];
                iconSubTitleLabel.textColor = [UIColor whiteColor];
                iconSubTitleLabel.text = @"AN APP BY DR. SARA SOLOMON";
                [iconSubTitleLabel sizeToFit];
                break;
            case 1:
                iconImageView.image = [UIImage imageNamed:@"track_calories_icon.png"];
                iconTitleLabel.font = [UIFont fontWithName:@"Norican-Regular" size:28];
                iconTitleLabel.frame = CGRectMake(62, 283, 80, 40);
                iconTitleLabel.textColor = [UIColor whiteColor];
                iconTitleLabel.text = @"Track your calories";
                [iconTitleLabel sizeToFit];
                iconSubTitleLabel.font = [UIFont fontWithName:@"Oswald" size:12];
                iconSubTitleLabel.frame = CGRectMake(80, 321, 80, 40);
                iconSubTitleLabel.textColor = [UIColor whiteColor];
                iconSubTitleLabel.text = @"VIA SARA'S RECIPES OR YOUR OWN";
                [iconSubTitleLabel sizeToFit];
                break;
            case 2:
                iconImageView.image = [UIImage imageNamed:@"reachgoals_icon.png"];
                iconTitleLabel.font = [UIFont fontWithName:@"Norican-Regular" size:28];
                iconTitleLabel.frame = CGRectMake(72, 283, 80, 40);
                iconTitleLabel.textColor = [UIColor whiteColor];
                iconTitleLabel.text = @"Reach your goals";
                [iconTitleLabel sizeToFit];
                iconSubTitleLabel.font = [UIFont fontWithName:@"Oswald" size:12];
                iconSubTitleLabel.frame = CGRectMake(93, 321, 80, 40);
                iconSubTitleLabel.textColor = [UIColor whiteColor];
                iconSubTitleLabel.text = @"WHETHER WEIGHT OR HEALTH";
                [iconSubTitleLabel sizeToFit];
                break;
            default:
                break;
        }
        i += 1;
        [tempImageView addSubview:iconTitleLabel];
        [tempImageView addSubview:iconSubTitleLabel];
        [tempImageView addSubview:iconImageView];
        [myScrollView addSubview:tempImageView];
        width += tempImageView.frame.size.width;
    }
    
    myScrollView.contentSize = CGSizeMake(width, myScrollView.frame.size.height);
    
    [self performSelector:@selector(nextSlide:) withObject:nil afterDelay:DURATION_BEFORE_SLIDE_TRANSITION];
}

-(void)viewDidAppear:(BOOL)animated {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextSlide:) object:nil];
    [myScrollView setContentOffset:CGPointMake(0, myScrollView.contentOffset.y) animated:YES];
    [self performSelector:@selector(nextSlide:) withObject:nil afterDelay:DURATION_BEFORE_SLIDE_TRANSITION];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = myScrollView.frame.size.width;
    int page = (myScrollView.contentOffset.x + (0.5f * pageWidth))/pageWidth;
    myPageControl.currentPage = page;
    
    if (scrollView.isDragging) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextSlide:) object:nil];
        [self performSelector:@selector(nextSlide:) withObject:nil afterDelay:DURATION_BEFORE_SLIDE_TRANSITION];
    }
}

-(InitialViewControlllerTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InitialViewControlllerTableViewCell *cell = (InitialViewControlllerTableViewCell *)[myTableView dequeueReusableCellWithIdentifier:@"ChoiceCell"];
    
    cell.choiceTitleLabel.text = choiceArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 17, 20, 20)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_small_right@2x.png"];
    [cell addSubview:arrowImageView];
    
    if (indexPath.row == 0) {
        [cell.choiceTitleLabel setFont:[UIFont fontWithName:@"Oswald" size:14]];
        cell.choiceTitleLabel.textColor = [UIColor whiteColor];

        [cell.initialViewControllerTableViewCellImageView setImage:[UIImage imageNamed:@"signup_button.png"]];
    } else {
        UIFont *oswaldLightFont = [UIFont fontWithName:@"Oswald-Light" size:14];
        UIFont *oswaldFont = [UIFont fontWithName:@"Oswald" size:14];
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:oswaldLightFont, NSFontAttributeName, nil];
        NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:oswaldFont, NSFontAttributeName, nil];
        
        const NSRange range = NSMakeRange(25, 11);
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cell.choiceTitleLabel.text attributes:attrs];
        [attributedText setAttributes:subAttrs range:range];
        
        [cell.choiceTitleLabel setAttributedText:attributedText];
        cell.choiceTitleLabel.textColor = [UIColor whiteColor];        

        [cell.initialViewControllerTableViewCellImageView setImage:[UIImage imageNamed:@"login_button.png"]];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [choiceArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LogInSegue" sender:self];        
    }
}

-(IBAction)nextSlide:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextSlide:) object:nil];
    
    if (myScrollView.contentOffset.x < 640) {
         [myScrollView setContentOffset:CGPointMake(myScrollView.contentOffset.x + 320, myScrollView.contentOffset.y) animated:YES];
        [self performSelector:@selector(nextSlide:) withObject:nil afterDelay:DURATION_BEFORE_SLIDE_TRANSITION];
    } else {
        [myScrollView setContentOffset:CGPointMake(0, myScrollView.contentOffset.y) animated:YES];
        [self performSelector:@selector(nextSlide:) withObject:nil afterDelay:DURATION_BEFORE_SLIDE_TRANSITION];
    }
}

@end