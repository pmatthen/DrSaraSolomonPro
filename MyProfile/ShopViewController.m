//
//  ShopViewController.m
//  MyProfile
//
//  Created by Poulose Matthen on 20/11/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopTableViewCell.h"
#import "ShopWebViewController.h"

@interface ShopViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *categoryArray;
@property int whichLink;
@property BOOL is35;

@end

@implementation ShopViewController
@synthesize categoryArray, myTableView, whichLink, is35;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    is35 = NO;
    
    CGRect bounds = self.view.bounds;
    CGFloat height = bounds.size.height;
    
    if (height == 480) {
        is35 = YES;
    }
    
    whichLink = 0;
    
    categoryArray = [NSArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Links"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            categoryArray = objects;
            [myTableView reloadData];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 9, 100, 40)];
    if (is35) {
        titleLabel.frame = CGRectMake(40, 8, 100, 34);
    }
    titleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"SHOP";

    [self.view addSubview:titleLabel];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopTableViewCell *cell = (ShopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ShopCell"];
    
    PFObject *tempObject = categoryArray[indexPath.row];
    
    cell.categoryTitleLabel.font = [UIFont fontWithName:@"Oswald-Light" size:14];
    cell.categoryTitleLabel.text = [tempObject[@"name"] uppercaseString
                                    ];
    cell.categoryTitleLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    whichLink = (int)indexPath.row;
    [self performSegueWithIdentifier:@"ShopWebViewSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *linkString  = [[NSString alloc] init];
    PFObject *tempObject = categoryArray[whichLink];
    
    linkString = [tempObject[@"url"] lowercaseString];
    
//    switch (whichLink) {
//        case 0:
//            linkString = @"http://www.drsarasolomon.com/join-now/";
//            break;
//        case 1:
//            linkString = @"http://www.bodybuilding.com/store/cyclone-cup/cyclone-cup.html?clickid=wXqQMRUa83Zm1UT2Xn0zaxv1UkT2foX5zWCW0o0&irpid=58948";
//            break;
//        case 2:
//            linkString = @"http://bit.ly/BSN-Supps";
//            break;
//        case 3:
//            linkString = @"http://bit.ly/Sara-Top4";
//            break;
//        case 4:
//            linkString = @"http://bit.ly/BBcom-Clothing";
//            break;
//        case 5:
//            linkString = @"http://bit.ly/PinkRope";
//            break;
//        case 6:
//            linkString = @"http://bit.ly/JumpRopeTrainer";
//            break;
//        case 7:
//            linkString = @"http://bit.ly/Quest-Nutrition-Bars";
//            break;
//        case 8:
//            linkString = @"http://bit.ly/Quest-Chips";
//            break;
//        case 9:
//            linkString = @"http://amzn.to/11hqUnn";
//            break;
//        case 10:
//            linkString = @"http://bit.ly/TeamSSRumbleRoller";
//            break;
//        case 11:
//            linkString = @"http://bit.ly/P28-High-Protein-Bread";
//            break;
//        case 12:
//            linkString = @"https://drsarasolomon.leadpages.net/eat-it-all/";
//            break;
//        case 13:
//            linkString = @"https://drsarasolomon-com.dpdcart.com/cart/add?product_id=73621&method_id=76324";
//            break;
//        case 14:
//            linkString = @"https://drsarasolomon.leadpages.net/omg-quest-recipes";
//            break;
//        case 15:
//            linkString = @"https://drsarasolomon.leadpages.net/fasting-tutorials-volume-1/";
//            break;
//        case 16:
//            linkString = @"https://drsarasolomon.leadpages.net/fasting-tutorials-volume-2/";
//            break;
//        default:
//            break;
//    }
    
    ShopWebViewController *myShopWebViewController = (ShopWebViewController *) segue.destinationViewController;
    
    myShopWebViewController.url = [NSURL URLWithString:linkString];
    myShopWebViewController.titleString = [tempObject[@"name"] lowercaseString];
}

- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
