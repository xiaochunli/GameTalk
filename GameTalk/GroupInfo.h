//
//  GroupInfo.h
//  GameTalk
//
//  Created by WangLi on 14/11/12.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupMembers;

@interface GroupInfo : NSManagedObject

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupId;
@property (nonatomic, retain) NSString * groupImg;
@property (nonatomic, retain) NSSet *membersRS;
@end

@interface GroupInfo (CoreDataGeneratedAccessors)

- (void)addMembersRSObject:(GroupMembers *)value;
- (void)removeMembersRSObject:(GroupMembers *)value;
- (void)addMembersRS:(NSSet *)values;
- (void)removeMembersRS:(NSSet *)values;

@end
