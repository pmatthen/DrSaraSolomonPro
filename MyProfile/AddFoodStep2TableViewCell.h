//
//  AddFoodStep2TableViewCell.h
//  MyProfile
//
//  Created by Poulose Matthen on 15/09/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFoodStep2TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *myTableViewCellTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectionButtonImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectionHighlightImageView;
@property (strong, nonatomic) IBOutlet UITextField *servingsTextField;
@property (strong, nonatomic) IBOutlet UILabel *servingSizeLabel;

@property BOOL isCellSelected;
@property int numberOfServings;

@end
