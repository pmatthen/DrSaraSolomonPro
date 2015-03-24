//
//  RecordedWeight.h
//  Dr Sara Solomon Pro
//
//  Created by Poulose Matthen on 21/03/15.
//  Copyright (c) 2015 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecordedWeight : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * weight;

@end
