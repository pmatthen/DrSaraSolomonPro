//
//  FoodTrackerItem.h
//  MyProfile
//
//  Created by Apple on 02/01/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FoodTrackerItem : NSManagedObject

@property (nonatomic, retain) NSNumber * caloriesPerServing;
@property (nonatomic, retain) NSNumber * carbsPerServing;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * fatsPerServing;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * isToday;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numberOfServings;
@property (nonatomic, retain) NSNumber * proteinsPerServing;
@property (nonatomic, retain) NSString * servingSize;

@end
