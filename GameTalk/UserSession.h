//
//  UserSession.h
//  GameTalk
//
//  Created by WangLi on 14/11/12.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserSession : NSManagedObject

@property (nonatomic, retain) NSString * sessionImg;
@property (nonatomic, retain) NSString * sessionName;
@property (nonatomic, retain) NSString * sessionShow;
@property (nonatomic, retain) NSString * sessionTargetId;
@property (nonatomic, retain) NSNumber * sessionType;
@property (nonatomic, retain) NSSet *talkRecordRS;
@end

@interface UserSession (CoreDataGeneratedAccessors)

- (void)addTalkRecordRSObject:(NSManagedObject *)value;
- (void)removeTalkRecordRSObject:(NSManagedObject *)value;
- (void)addTalkRecordRS:(NSSet *)values;
- (void)removeTalkRecordRS:(NSSet *)values;

@end
