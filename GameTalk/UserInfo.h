//
//  UserInfo.h
//  GameTalk
//
//  Created by WangLi on 14/11/12.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * userArea;
@property (nonatomic, retain) NSString * userBlood;
@property (nonatomic, retain) NSDate * userBorn;
@property (nonatomic, retain) NSString * userCity;
@property (nonatomic, retain) NSString * userHeadImg;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPhoneNum;
@property (nonatomic, retain) NSString * userPro;
@property (nonatomic, retain) NSNumber * userSex;
@property (nonatomic, retain) NSString * userSign;

@end
