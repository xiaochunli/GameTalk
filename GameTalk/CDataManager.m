//
//  CDataManager.m
//  GameTalk
//
//  Created by WangLi on 14/11/13.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "CDataManager.h"
#import "AppDelegate.h"

#import "UserSession.h"
#import "GroupInfo.h"
#import "GroupMembers.h"
#import "TalkRecord.h"
#import "UserInfo.h"
#import "UpdateInfo.h"

static CDataManager *    s_CDataManager = nil;
@interface CDataManager(privateFun)
/**
 *把字典数据赋值给对象
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToUserInfo:(NSDictionary*)dic
                   object:(UserInfo*) tUserInfo;
/**
 *把字典数据赋值给对象 (GroupInfo )
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToGroupInfo:(NSDictionary*)dic
                    object:(GroupInfo*) tGroupInfo;
/**
 *把字典数据赋值给对象 (GroupMembers)
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToGroupMember:(NSDictionary*)dic
                      object:(GroupMembers*) tGroupMember;
@end

@implementation CDataManager
{
    NSManagedObjectContext*             _mainContext;
}
- (void)dealloc
{
    
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CDataManager = [[CDataManager alloc] init];
        [s_CDataManager getContext];
    });
    return s_CDataManager;
}

/**
 *获得CoreData的 main的 上下文
 */
-(NSManagedObjectContext*) getContext
{
    if (_mainContext == nil) {
        AppDelegate* tAppDelegate =InstanceAPPDelegate;
        _mainContext = tAppDelegate.managedObjectContext;
    }
    return _mainContext;
}


#pragma mark-
#pragma mark 联系人相关
/**
 *查询最近联系的会话对象
 */
-(NSArray*) queryRecentSessionData
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserSession class])];
    NSError* tError = nil;
    return [_mainContext executeFetchRequest:tFectchRequest error:&tError];
}

/**
 *查询所有联系人
 */
-(NSArray*) queryAllContactData
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserInfo class])];
    NSError* tError = nil;
    return [_mainContext executeFetchRequest:tFectchRequest error:&tError];
}

/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Return 存在返回记录对象，不存在为 nil
 */
-(UserInfo*)queryUserInfo:(NSString*)idStr
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UserInfo class])];
    NSPredicate* tPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"userId == '%@'",idStr]];
    tFectchRequest.predicate = tPredicate;
    NSError* tError = nil;
    NSArray* tResultArr = [_mainContext executeFetchRequest:tFectchRequest error:&tError];
    if (tError != nil) {
        NSLog(@"%s error:%@",__PRETTY_FUNCTION__,[tError description]);
    }
    return [tResultArr lastObject];
}

/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateUserInfo 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateUserInfo:(NSDictionary*) updateDic
          updateObject:(UserInfo*) updateUserInfo
{
    if (updateUserInfo != nil) {
        [self dicDataToUserInfo:updateDic object:updateUserInfo];
        NSError* tError = nil;
        [_mainContext save:&tError];
        if (tError == nil) {
            return YES;
        }else{
            NSLog(@"%s  save UpdateInfo error:%@",__PRETTY_FUNCTION__,[tError description]);
            return NO;
        }
    }else{
        NSLog(@"%s Param updateUserInfo is nil",__PRETTY_FUNCTION__);
        return NO;
    }
}

/**
 *创建UserInfo一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(UserInfo*)createUserInfo:(NSDictionary*)dataDic
{
    UserInfo* tNewUserInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([UserInfo class]) inManagedObjectContext:_mainContext];
    [self dicDataToUserInfo:dataDic object:tNewUserInfo];
    NSError* tError = nil;
    [_mainContext save:&tError];
    if (tError == nil) {
        return tNewUserInfo;
    }else{
        NSLog(@"save UpdateInfo error:%@",[tError description]);
        return nil;
    }
}

/**
 *把字典数据赋值给对象 (UserInfo )
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToUserInfo:(NSDictionary*)dic
                   object:(UserInfo*) tUserInfo
{
    NSArray* keys = [dic allKeys];
    for (NSString* keyStr in keys) {
        /*
         userArea;      地区
         userBlood;     血型
         userBorn;      出生
         userCity;      城市
         userHeadImg;   头像
         userId;        唯一ID
         userName;      用户名称 (也是唯一)
         userPhoneNum;  电话
         userPro;       省份
         userSex;       性别
         userSign;      签名
         */
        if ([keyStr isEqualToString:@"userArea"]) {
            tUserInfo.userArea = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userBlood"]) {
            tUserInfo.userBlood = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userBorn"]) {
            tUserInfo.userBorn = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userCity"]) {
            tUserInfo.userCity = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userHeadImg"]) {
            tUserInfo.userHeadImg = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userId"]) {
            tUserInfo.userId = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userName"]) {
            tUserInfo.userName = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userPhoneNum"]) {
            tUserInfo.userPhoneNum = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userPro"]) {
            tUserInfo.userPro = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userSex"]) {
            tUserInfo.userSex = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userSign"]) {
            tUserInfo.userSign = [dic objectForKey:keyStr];
        }
    }
}

/**
 *创建UpdateInfo的新数据
 @Param dataDic 数据保存 @{"propertyName":(NSDate),"",.....}
 */
-(UpdateInfo*) createUpdateInfo:(NSDictionary*)dataDic
{
    UpdateInfo* tNewUpdateInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([UpdateInfo class]) inManagedObjectContext:_mainContext];
    NSArray* keys = [dataDic allKeys];
    for (NSString* keyStr in keys) {
        if ([keyStr isEqualToString:@"groupInfoDate"]) {
            tNewUpdateInfo.groupInfoDate = [dataDic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"userInfoDate"]) {
            tNewUpdateInfo.userInfoDate = [dataDic objectForKey:keyStr];
        }
    }
    NSError* tError = nil;
    [_mainContext save:&tError];
    if (tError == nil) {
        return tNewUpdateInfo;
    }else{
        NSLog(@"save UpdateInfo error:%@",[tError description]);
        return nil;
    }
}

#pragma mark-
#pragma mark 群组相关

/**
 *查询所有群组
 */
-(NSArray*) queryAllGroupData
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([GroupInfo class])];
    NSError* tError = nil;
    return [_mainContext executeFetchRequest:tFectchRequest error:&tError];
}


/**
 *查询本地同步时间记录
 */
-(UpdateInfo*) queryUpdateInfo
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([UpdateInfo class])];
    NSError* tError = nil;
    return [[_mainContext executeFetchRequest:tFectchRequest error:&tError] lastObject];
}

/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Return 存在返回记录对象，不存在为 nil
 */
-(GroupInfo*)queryGroupInfo:(NSString*)idStr
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([GroupInfo class])];
    NSPredicate* tPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"groupId == '%@'",idStr]];
    tFectchRequest.predicate = tPredicate;
    NSError* tError = nil;
    NSArray* tResultArr = [_mainContext executeFetchRequest:tFectchRequest error:&tError];
    if (tError != nil) {
        NSLog(@"%s error:%@",__PRETTY_FUNCTION__,[tError description]);
    }
    return [tResultArr lastObject];
}

/**
 *创建UserInfo一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(GroupInfo*)createGroupInfo:(NSDictionary*)dataDic
{
    GroupInfo* tNewGroupInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GroupInfo class]) inManagedObjectContext:_mainContext];
    [self dicDataToGroupInfo:dataDic object:tNewGroupInfo];
    NSError* tError = nil;
    [_mainContext save:&tError];
    if (tError == nil) {
        return tNewGroupInfo;
    }else{
        NSLog(@"save UpdateGroupInfo error:%@",[tError description]);
        return nil;
    }
}


/**
 *把字典数据赋值给对象 (GroupInfo )
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToGroupInfo:(NSDictionary*)dic
                   object:(GroupInfo*) tGroupInfo
{
    NSArray* keys = [dic allKeys];
    for (NSString* keyStr in keys) {
        /*
            groupName;   群组名称
            groupId;     唯一ID
            groupImg;    群组img
            membersRS;   成员
         */
        if ([keyStr isEqualToString:@"groupName"]) {
            tGroupInfo.groupName = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"groupId"]) {
            tGroupInfo.groupId = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"groupImg"]) {
            tGroupInfo.groupImg = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"membersRS"]) {
            id tMembersArr = [dic objectForKey:keyStr];
            NSMutableSet* tMemberSet = [NSMutableSet set];
            if (OBJECT_IS(tMembersArr,[NSArray class])) {
                for (NSString* tMemberName in tMembersArr) {
                    GroupMembers* tNewMember = [self createGroupMember:@{@"memberName":tMemberName,@"gourpInfoRS":tGroupInfo}];
                    [tMemberSet addObject:tNewMember];
                }
            }else{
                NSLog(@"%s type is wrong",__PRETTY_FUNCTION__);
            }
            tGroupInfo.membersRS = tMemberSet;
        }
    }
}

/**
 *删除GroupInfo里的成员
 @Param groupInfo 群组对象
 @Param delMember 删除的成员
 @Return 成功或者失败
 */
-(BOOL)deleteGroupInfoMember:(GroupInfo*) groupInfo
               delMember:(GroupMembers*) delMember
{
    [groupInfo removeMembersRSObject:delMember];
    NSError* tError = nil;
    [_mainContext save:&tError];
    if (tError == nil) {
        return YES;
    }else{
        NSLog(@"delete GroupInfo member error:%@",[tError description]);
        return NO;
    }
}


/**
 *把字典数据赋值给对象 (GroupMembers)
 @Param dic         新数据
 @Param tUserInfo   目标对象
 */
-(void) dicDataToGroupMember:(NSDictionary*)dic
                    object:(GroupMembers*) tGroupMember
{
    NSArray* keys = [dic allKeys];
    for (NSString* keyStr in keys) {
        /*
          memberName;   //成员名称 （唯一）
          memberId;     //成员ID  （唯一）
          memberImg;    //成员头像
          memberType;   //成员权限
          gourpInfoRS;  //对应关系的群组记录
         */
        if ([keyStr isEqualToString:@"memberName"]) {
            tGroupMember.memberName = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"memberId"]) {
            tGroupMember.memberId = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"memberImg"]) {
            tGroupMember.memberImg = [dic objectForKey:keyStr];
        }else if ([keyStr isEqualToString:@"gourpInfoRS"]) {
            tGroupMember.gourpInfoRS =[dic objectForKey:keyStr];
        }
    }
}

/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateUserInfo 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateGroupInfo:(NSDictionary*) updateDic
          updateObject:(GroupInfo*) updateGroupInfo
{
    if (updateGroupInfo != nil) {
        [self dicDataToGroupInfo:updateDic object:updateGroupInfo];
        NSError* tError = nil;
        [_mainContext save:&tError];
        if (tError == nil) {
            return YES;
        }else{
            NSLog(@"%s  save GroupInfo error:%@",__PRETTY_FUNCTION__,[tError description]);
            return NO;
        }
    }else{
        NSLog(@"%s Param updateGroupInfo is nil",__PRETTY_FUNCTION__);
        return NO;
    }
}



/**
 *查询ID 本地是否有记录
 @Param idStr 是否本已经已有记录
 @Param groupId 对应的群组的ID
 @Return 存在返回记录对象，不存在为 nil
 */
-(GroupMembers*)queryGroupMember:(NSString*)nameStr
                         InGroup:(NSString*)groupId
{
    NSFetchRequest* tFectchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([GroupMembers class])];
    NSPredicate* tPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(memberName == '%@') AND (gourpInfoRS.groupId == '%@')",nameStr,groupId]];
    tFectchRequest.predicate = tPredicate;
    NSError* tError = nil;
    NSArray* tResultArr = [_mainContext executeFetchRequest:tFectchRequest error:&tError];
    if (tError != nil) {
        NSLog(@"%s error:%@",__PRETTY_FUNCTION__,[tError description]);
    }
    return [tResultArr lastObject];
}

/**
 *创建GroupMembers一条新记录
 @Param dataDic @{(key):(data)....}
 */
-(GroupMembers*)createGroupMember:(NSDictionary*)dataDic
{
    GroupMembers* tNewGroupMember = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([GroupMembers class]) inManagedObjectContext:_mainContext];
    [self dicDataToGroupMember:dataDic object:tNewGroupMember];
    NSError* tError = nil;
    [_mainContext save:&tError];
    if (tError == nil) {
        return tNewGroupMember;
    }else{
        NSLog(@"save UpdateGroupInfo error:%@",[tError description]);
        return nil;
    }
}


/**
 *查询ID 本地是否有记录
 @Param updateDic 更新的数据 @{(key):(data)....}
 @Param updateGroupMember 更新的对象
 @Return 成功或者失败
 */
-(BOOL) updateGroupMember:(NSDictionary*) updateDic
           updateObject:(GroupMembers*) updateGroupMember
{
    if (updateGroupMember != nil) {
        [self dicDataToGroupMember:updateDic object:updateGroupMember];
        NSError* tError = nil;
        [_mainContext save:&tError];
        if (tError == nil) {
            return YES;
        }else{
            NSLog(@"%s  save GroupInfo error:%@",__PRETTY_FUNCTION__,[tError description]);
            return NO;
        }
    }else{
        NSLog(@"%s Param updateGroupInfo is nil",__PRETTY_FUNCTION__);
        return NO;
    }
}

@end
