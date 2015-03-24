//
//  ShopTableViewCell.h
//  MyProfile
//
//  Created by Poulose Matthen on 20/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ShopTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (strong, nonatomic) IBOutlet PFImageView *myImageView;

@end
