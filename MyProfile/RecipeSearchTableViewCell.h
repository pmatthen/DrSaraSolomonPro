//
//  RecipeSearchTableViewCell.h
//  MyProfile
//
//  Created by Poulose Matthen on 14/08/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RecipeSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *myTableViewCellTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myTableViewCellImageView;
@property (weak, nonatomic) IBOutlet PFImageView *thumbnailImageView;

@end
