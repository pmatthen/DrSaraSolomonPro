//
//  MacroCalculatorDetails.h
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MacroCalculatorDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * bodyfat;
@property (nonatomic, retain) NSNumber * activityLevel;
@property (nonatomic, retain) NSNumber * unitType;
@property (nonatomic, retain) NSNumber * results;
@property (nonatomic, retain) NSNumber * proteinCalculation;
@property (nonatomic, retain) NSNumber * fats;
@property (nonatomic, retain) NSDate * date;

@end
