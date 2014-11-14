//
//  CDataManager.h
//  GameTalk
//
//  Created by WangLi on 14/11/13.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UpdateInfo;
@class UserInfo;
@class GroupInfo;
@class GroupMembers;
@interface CDataManager : NSObject
+ (id)shareInstance;
/**
 *查询最近联系的会话对象
 */
-(NSArray*) queryRecentSessionData;
/**
 *查询所有联系人
 */
-(NSArray*) queryAllContactData;
/**
 *查询所有群组
 */
-(NSArray*) queryAllGroupData;
/**
 *查询本地同步时间记录
 */
-(UpdateInfo*) queryUpdateInfo;
/**
 *创建UpdateInfo的新数据
 @Param dataDic 数据保存 @{"propertyName":(NSDate),"",.....}
 */
-(UpdateInfo*) createUpdateInfo:(NSDictionary*)dataDic;

/**
 *创建一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(UserInfo*)createUserInfo:(NSDictionary*)dataDic;
/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Return 存在返回记录对象，不存在为 nil
 */
-(UserInfo*)queryUserInfo:(NSString*)idStr;
/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateUserInfo 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateUserInfo:(NSDictionary*) updateDic
          updateObject:(UserInfo*) updateUserInfo;

/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Return 存在返回记录对象，不存在为 nil
 */
-(GroupInfo*)queryGroupInfo:(NSString*)idStr;

/**
 *创建UserInfo一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(GroupInfo*)createGroupInfo:(NSDictionary*)dataDic;

/**
 *删除GroupInfo里的成员
 @Param groupInfo 群组对象
 @Param delMember 删除的成员
 @Return 成功或者失败
 */
-(BOOL)deleteGroupInfoMember:(GroupInfo*) groupInfo
                   delMember:(GroupMembers*) delMember;

/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateUserInfo 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateGroupInfo:(NSDictionary*) updateDic
           updateObject:(GroupInfo*) updateGroupInfo;
/**
 *创建GroupMembers一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(GroupMembers*)createGroupMember:(NSDictionary*)dataDic;

/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Param groupId 对应的群组的ID
 @Return 存在返回记录对象，不存在为 nil
 */
-(GroupMembers*)queryGroupMember:(NSString*)nameStr
                         InGroup:(NSString*)groupId;
/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateGroupMember 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateGroupMember:(NSDictionary*) updateDic
             updateObject:(GroupMembers*) updateGroupMember;
@end
