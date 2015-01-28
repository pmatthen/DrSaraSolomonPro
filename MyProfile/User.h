//
//  User.h
//  MyProfile
//
//  Created by Apple on 12/12/14.
//  Copyright (c) 2014 Dr. Sara Solomon Fitness. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * activityFactor;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * eNotifications;
@property (nonatomic, retain) NSNumber * fNotifications;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSDate * initialBeginFastingTime;
@property (nonatomic, retain) NSNumber * initialWeight;
@property (nonatomic, retain) NSNumber * maintenenceCalorieLevel;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * protocolTypeSelected;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSData * userPhoto;

@end
