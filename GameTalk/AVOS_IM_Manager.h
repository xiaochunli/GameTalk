//
//  AVOS_IM_Manager.h
//  GameTalk
//
//  Created by Wang Li on 14-10-22.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    QueryResult_Yes =1,//查询结果YES
    QueryResult_No,   //查询结果NO
    QueryResult_Fail  //查询失败
}QueryResultType;

typedef enum{
    IMErrorType_SessionNotOpen = 5, //会话未建立
    
    IMErrorType_CreateGroupNameSaveFail =10,//创建的组--保存失败
    IMErrorType_CreateGroupNameExist,   //创建的组 -- 存在
    IMErrorType_CreateGroupNameQueryFail, //创建的组 -- 查询失败
    IMErrorType_CreateGroupNameFail, //创建的组 -- 失败
    
    IMErrorType_AddWatchSaveFail,//添加好友--保存失败
    IMErrorType_AddWatchExist,   //添加好友 -- 存在
    IMErrorType_AddWatchQueryFail, //添加好友 -- 查询失败
    IMErrorType_AddWatchQueryUserNotExist, //添加好友 -- 添加对象不存在
    IMErrorType_AddWatchSelfNone, //添加好友 -- 自身对象为空
    IMErrorType_AddWatchIsSelf, //添加好友 -- 关注自身不允许
    
    
    IMErrorType_UnWatchSaveFail,//删除好友--保存失败
    IMErrorType_UnWatchNotExist,   //删除好友 -- 不存在
    IMErrorType_UnWatchQueryFail, //删除好友 -- 查询失败
    IMErrorType_UnWatchSelfNone, //删除好友 -- 自身对象为空
    
    IMErrorType_AddWatchGroupNotExist,//关注群组--群不存在
    IMErrorType_AddWatchGroupFail,//关注群组--失败
    IMErrorType_AddWatchGroupHaved,//关注群组--已关注过
    
    IMErrorType_UnWatchGroupNotExist,//取消群关注--群不存在
    IMErrorType_UnWatchGroupFail,//取消群关注--失败
    IMErrorType_UnWatchGroupUnWatched,//取消群关注--未关注
    IMErrorType_UnWatchGroupUnNotMember,//取消群关注--不是组成员
    
    IMErrorType_QueryUserExistFail,//查询用户是否存在--失败
    IMErrorType_QueryUserExistMoreOne,//查询用户是否存在--多个用户
    IMErrorType_QueryUserExistIsNot,//查询用户是否存在--不存在
    
    IMErrorType_InviteUserJoinGroup_GroupNotExist,//邀请用户加入群--群不存在
    IMErrorType_InviteUserJoinGroup_UserExist,//邀请用户加入群--已在群内
    IMErrorType_InviteUserJoinGroup_IsSelf,//邀请用户加入群--不可邀请自己
    IMErrorType_InviteUserJoinGroup_InviteNotExist,//邀请用户加入群--被邀请用户不存在
    IMErrorType_InviteUserJoinGroup_Fail,//邀请用户加入群--失败
}IMErrorType;

@interface AVOS_IM_Manager : NSObject<AVSessionDelegate,AVGroupDelegate,AVSignatureDelegate>
{
    
}
@property (strong,nonatomic) AVUser*  m_AVUser;


+ (id)shareInstance;

-(void) openIMSession;
-(void) closeSession;
-(AVSession*) getAVSession;


/**
 *用户是否存在
 @Param userName 查询的用户名称（唯一）
 @Param queryUser 查询出的结果
 */
-(void) userIsExist:(NSString*)userName
            success:(void (^)(AVUser* queryUser))success
            failure:(void (^)(IMErrorType failType))failure;

/**
 *关注某个人
 @Param watchId 添加某人为好友
 */
-(void) addWatchPerson:(NSString*)watchId
               success:(void (^)())success
               failure:(void (^)(IMErrorType failType))failure;


/**
 *取消关注某个人
 @Param watchId 取消好友
 */
-(void) unWatchPerson:(NSString*)watchId
              success:(void (^)())success
              failure:(void (^)(IMErrorType failType))failure;

/**
 *创建一个组并且起个名字
 @Param name 群组名称
 */
-(void) createGroupName:(NSString*)name
                success:(void (^)())success
                failure:(void (^)(IMErrorType failType))failure;


/**
 *群组是否存在
 @Param groupName 已存在的groupName
 */
-(void) isGroupIdIsExisted:(NSString*)groupId
                  queryRes:(void (^)(QueryResultType queryResult,AVObject* group))qResult;

/**
 *获得某小组内的成员
 @Param groupId 已存在的groupId
 @Return 成员ID 数组(username)
 */
-(NSArray*) queryGroupPeers:(NSString*)groupId;


/**
 *关注某个组
 @Param groupId 唯一的组ID
 */
-(void) addWatchGroup:(NSString*)groupId
              success:(void (^)())success
              failure:(void (^)(IMErrorType failType))failure;

/**
 *取消关注某个组
 @Param groupId 唯一的组ID
 */
-(void) unWatchGroup:(NSString*)groupId
             success:(void (^)())success
             failure:(void (^)(IMErrorType failType))failure;

/**
 *邀请加入某小组
 @Param inviteUserName 被邀请人名称
 @Param toGroupName  小组名称
 */
-(void) inviteUserToGroup:(NSString*) inviteUserName
                GroupId:(NSString*) toGroupid
                  success:(void (^)())success
                  failure:(void (^)(IMErrorType failType))failure;

/**
 *查看用户所有的会话
 */
-(void) getUserAllWatchs:(void (^)(NSArray* allWatchsArr))success
                 failure:(void (^)(IMErrorType failType))failure;
@end


