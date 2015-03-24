//
//  MacroCalculatorDetails.h
//  Dr Sara Solomon Pro
//
//  Created by Poulose Matthen on 21/03/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MacroCalculatorDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * activityLevel;
@property (nonatomic, retain) NSNumber * bodyfat;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * fats;
@property (nonatomic, retain) NSNumber * latestWeight;
@property (nonatomic, retain) NSNumber * proteinCalculation;
@property (nonatomic, retain) NSNumber * results;

@end
