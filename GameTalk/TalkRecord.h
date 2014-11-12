//
//  TalkRecord.h
//  GameTalk
//
//  Created by WangLi on 14/11/12.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserSession;

@interface TalkRecord : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * contentType;
@property (nonatomic, retain) NSString * fromUserName;
@property (nonatomic, retain) NSDate * receiveTime;
@property (nonatomic, retain) NSString * recordId;
@property (nonatomic, retain) NSString * toGroupId;
@property (nonatomic, retain) NSString * toUserName;
@property (nonatomic, retain) UserSession *sessionRS;

@end
