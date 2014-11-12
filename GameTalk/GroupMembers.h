//
//  GroupMembers.h
//  GameTalk
//
//  Created by WangLi on 14/11/12.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GroupMembers : NSManagedObject

@property (nonatomic, retain) NSString * memberName;
@property (nonatomic, retain) NSString * memberId;
@property (nonatomic, retain) NSString * memberImg;
@property (nonatomic, retain) NSNumber * memberType;
@property (nonatomic, retain) NSManagedObject *gourpInfoRS;

@end
