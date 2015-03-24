//
//  BarcodeViewController.h
//  Dr Sara Solomon Pro
//
//  Created by Apple on 02/03/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@property (strong, nonatomic) NSMutableArray * foundBarcodes;

@end
