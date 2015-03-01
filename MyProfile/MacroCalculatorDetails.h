//
//  MacroCalculatorDetails.h
//  Dr Sara Solomon Pro
//
//  Created by Apple on 17/02/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MacroCalculatorDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * activityLevel;
@property (nonatomic, retain) NSNumber * bodyfat;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * fats;
@property (nonatomic, retain) NSNumber * proteinCalculation;
@property (nonatomic, retain) NSNumber * results;
@property (nonatomic, retain) NSNumber * latestWeight;

@end
