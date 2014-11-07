//
//  AVOS_IM_Manager.m
//  GameTalk
//
//  Created by Wang Li on 14-10-22.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "AVOS_IM_Manager.h"
#import "CommonManager.h"
static AVOS_IM_Manager *    s_AVOSIMManager = nil;

@implementation AVOS_IM_Manager
{
    AVSession * _session;
}
@synthesize m_AVUser;
- (void)dealloc
{
    
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_AVOSIMManager = [[AVOS_IM_Manager alloc] init];
    });
    return s_AVOSIMManager;
}


-(void) openIMSession
{
    if (_session!= nil) {
        return;
    }
    if (m_AVUser == nil || [m_AVUser.username length] <= 0) {
        NSLog(@"AVUser object is null");
        return;
    }
    [AVGroup setDefaultDelegate:self];
    if([_session isOpen]){
        _session = [AVSession  getSessionWithPeerId:m_AVUser.username];
    }else if (_session == nil) {
        _session = [[AVSession alloc] init];
        _session.sessionDelegate = s_AVOSIMManager;
        [_session openWithPeerId:m_AVUser.username];
    }
}


-(void) closeSession
{
    _session.sessionDelegate = nil;
    [_session close];
    _session = nil;
}

-(AVSession*) getAVSession
{
    return _session;
}





#pragma mark-
#pragma mark AVSessionDelegate
- (void)sessionOpened:(AVSession *)session
{
    NSLog(@"sessionOpened");
    
    //自动加入已关注的组
    
    //test
//    [_session watchPeerIds:@[@"leonfeifei0"]];
    NSLog(@"%@",[_session watchedPeerIds]);
    [self checkGroupRecordWhenInit];
    [self autoWatchJoinGroup:^{
        
    } failure:^{
        
    }];
//    [self addWatchGroup:@"5451c4c9e4b0e9dff2f9d053"];
//    [self createGroupName:@"同城捡肥皂" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
//    [self addWatchGroup:@"5459e2ade4b0ccf24ecd2c3a" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
//    [self addWatchPerson:@"leonfeifei0" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
//    [self addWatchPerson:@"leonfeifei0" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
//    [self unWatchPerson:@"leonfeifei0" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
    
//    [self unWatchGroup:@"同城捡肥皂" success:^{
//        
//    } failure:^(IMErrorType failType) {
//        
//    }];
}
- (void)sessionPaused:(AVSession *)session
{
    NSLog(@"sessionPaused");
}
- (void)sessionResumed:(AVSession *)session
{
    NSLog(@"sessionResumed");
}
- (void)sessionFailed:(AVSession *)session error:(NSError *)error
{
    NSLog(@"sessionFailed");
    [AVGroup setDefaultDelegate:nil];
}
- (void)session:(AVSession *)session didReceiveMessage:(AVMessage *)message
{
    NSLog(@"session:(AVSession *)session didReceiveMessage = %@",[message description]);
}
- (void)session:(AVSession *)session didReceiveStatus:(AVPeerStatus)status peerIds:(NSArray *)peerIds
{
    NSLog(@"session:(AVSession *)session didReceiveStatus");
}
- (void)session:(AVSession *)session messageSendFinished:(AVMessage *)message
{
    NSLog(@"session:(AVSession *)session messageSendFinished");
}
- (void)session:(AVSession *)session messageSendFailed:(AVMessage *)message error:(NSError *)error
{
    NSLog(@"session:(AVSession *)session messageSendFailed");
}
#pragma mark -
#pragma mark AVGroupDelegate
- (void)group:(AVGroup *)group didReceiveMessage:(AVMessage *)message
{
    NSLog(@"group:(AVGroup *)group didReceiveMessage:(AVMessage *)message");
}
- (void)group:(AVGroup *)group didReceiveEvent:(AVGroupEvent)event peerIds:(NSArray *)peerIds
{
    NSLog(@"group:(AVGroup *)group didReceiveEvent:(AVMessage *)message type = %d  peers =%@",(int)event,[peerIds description]);
    UIAlertView* tAlert =[[UIAlertView alloc] initWithTitle:@"group event" message:[NSString stringWithFormat:@"type =%d ,peers =%@",(int)event,[peerIds description]] delegate:nil cancelButtonTitle:@"close" otherButtonTitles: nil];
    [tAlert show];
}
- (void)group:(AVGroup *)group messageSendFinished:(AVMessage *)message
{
    NSLog(@"group:(AVGroup *)group messageSendFinished:(AVMessage *)message");
}
- (void)group:(AVGroup *)group messageSendFailed:(AVMessage *)message error:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"group:(AVGroup *)group messageSendFailed:(AVMessage *)message");
}

#pragma mark -
#pragma mark AVSignatureDelegate



#pragma mark -
#pragma mark 后台部分
/**
 *建立连接后自动默认加入已关注的组
 */
-(void) autoWatchJoinGroup:(void (^)())success
                   failure:(void (^)())failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure();
        return;
    }
    if ([m_AVUser.username length] <= 0) {
        
    }else{
        NSString* tCQLStr = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_UserWatchs,UserWatchs_KeyUserName,m_AVUser.username];
        [AVQuery doCloudQueryInBackgroundWithCQL:tCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
            if (error == nil) {
                for (AVObject* groupObject in result.results) {
                    AVObject* tGroupObject= [groupObject objectForKey:UserWatchs_KeyWatchGroup];
                    NSString* tInCQLStr = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_RealtimeGroups,Object_Id,tGroupObject.objectId];
                    [AVQuery doCloudQueryInBackgroundWithCQL:tInCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
                        if (error == nil) {
                            if ([result.results count] == 1) {
                                AVObject* tGroup = [result.results lastObject];
                                AVGroup* tExistGroup = [AVGroup getGroupWithGroupId:tGroup.objectId session:_session];
                                [tExistGroup join];
                            }else{
                                failure();
                            }
                        }else{
                            failure();
                        }
                    }];
                }
                success();
            }else{
                failure();
            }
        }];
    }

}

#pragma mark -
#pragma mark 好友和组控制
/**
 *用户是否存在
 @Param userName 查询的用户名称（唯一）
 @Param queryUser 查询出的结果
 */
-(void) userIsExist:(NSString*)userName
            success:(void (^)(AVUser* queryUser))success
            failure:(void (^)(IMErrorType failType))failure
{
    AVQuery* tUserQuery = [AVUser query];
    [tUserQuery whereKey:ObjectClass_User_userName equalTo:userName];
    [tUserQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if ([objects count] == 1) {
                success([objects lastObject]);
            }else if([objects count] > 1){
                failure(IMErrorType_QueryUserExistMoreOne);
            }else{
                failure(IMErrorType_QueryUserExistFail);
            }
        }else{
            failure(IMErrorType_QueryUserExistFail);
        }
    }];
}

/**
 *关注某个人
 @Param watchId 添加某人为好友
 */
-(void) addWatchPerson:(NSString*)watchId
               success:(void (^)())success
               failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    if ([m_AVUser.username length] <=0) {
        failure(IMErrorType_AddWatchSelfNone);
        return;
    }else if ([m_AVUser.username isEqualToString:watchId]) {
        failure(IMErrorType_AddWatchIsSelf);
        return;
    }
    
    [self userIsExist:watchId success:^(AVUser *queryUser) {
        NSString* tCQLStr = [NSString stringWithFormat:@"select count(*) from %@ where %@='%@' and %@=pointer('%@','%@')",ObjectClass_UserWatchs,UserWatchs_KeyUserName,m_AVUser.username,UserWatchs_KeyWatchUser,ObjectClass_User,queryUser.objectId];
        [AVQuery doCloudQueryInBackgroundWithCQL:tCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
            if (error == nil) {
                if (result.count == 0) {
                    AVObject* tUserWatchs = [AVObject objectWithClassName:ObjectClass_UserWatchs];
                    [tUserWatchs setObject:m_AVUser.username forKey:UserWatchs_KeyUserName];
                    [tUserWatchs setObject:queryUser forKey:UserWatchs_KeyWatchUser];
                    [tUserWatchs saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            if (error == nil) {
                                NSLog(@"save new UserWatchs class done %@",watchId);
                                success();
                            }else{
                                NSLog(@"save new UserWatchs class fail error:%@",[error description]);
                                failure(IMErrorType_AddWatchSaveFail);
                            }
                        }else{
                            NSLog(@"save new UserWatchs class fail error:%@",[error description]);
                            failure(IMErrorType_AddWatchSaveFail);
                        }
                    }];
                }else{
                    //已经存在
                    NSLog(@"watchId is existed");
                    failure(IMErrorType_AddWatchExist);
                }
            }else{
                NSLog(@"CQL error %@",[error description]);
                failure(IMErrorType_AddWatchQueryFail);
            }
        }];
    } failure:^(IMErrorType failType) {
        switch ((int)failType) {
            case IMErrorType_QueryUserExistMoreOne:
            {
                failure(IMErrorType_AddWatchQueryFail);
            }
                break;
            case IMErrorType_QueryUserExistFail:
            {
                failure(IMErrorType_AddWatchQueryFail);
            }
                break;
            case IMErrorType_AddWatchQueryUserNotExist:
            {
                failure(IMErrorType_AddWatchQueryUserNotExist);
            }
                break;
        }
    }];
}

/**
 *取消关注某个人
 @Param watchId 取消好友
 */
-(void) unWatchPerson:(NSString*)watchId
              success:(void (^)())success
              failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    if ([m_AVUser.username length] <=0) {
        failure(IMErrorType_AddWatchSelfNone);
        return;
    }
    
    [self userIsExist:watchId success:^(AVUser *queryUser) {
        NSString* tCQLStr = [NSString stringWithFormat:@"select include %@,* from %@ where %@='%@' and %@=pointer('%@','%@')",UserWatchs_KeyWatchUser,ObjectClass_UserWatchs,UserWatchs_KeyUserName,m_AVUser.username,UserWatchs_KeyWatchUser,ObjectClass_User,queryUser.objectId];
        [AVQuery doCloudQueryInBackgroundWithCQL:tCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
            if (error == nil) {
                if ([result.results count] == 1) {
                    AVObject* delObject =[result.results lastObject];
                    [delObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            if (error == nil) {
                                NSLog(@" delete UserWatchs class done %@",watchId);
                                success();
                            }else{
                                NSLog(@" delete UserWatchs class fail error:%@",[error description]);
                                failure(IMErrorType_UnWatchSaveFail);
                            }
                        }else{
                            NSLog(@" delete UserWatchs class fail error:%@",[error description]);
                            failure(IMErrorType_UnWatchSaveFail);
                        }
                    }];
                }else{
                    NSLog(@"watchId is not existed");
                    failure(IMErrorType_UnWatchNotExist);
                }
            }else{
                NSLog(@"CQL error %@",[error description]);
                failure(IMErrorType_UnWatchQueryFail);
            }
        }];
    } failure:^(IMErrorType failType) {
        switch ((int)failType) {
            case IMErrorType_QueryUserExistMoreOne:
            {
                failure(IMErrorType_UnWatchSaveFail);
            }
                break;
            case IMErrorType_QueryUserExistFail:
            {
                failure(IMErrorType_UnWatchSaveFail);
            }
                break;
            case IMErrorType_AddWatchQueryUserNotExist:
            {
                failure(IMErrorType_UnWatchNotExist);
            }
                break;
        }
    }];
    
    
}
/**
 *关注某个组
 @Param watchId 唯一的组ID
 */
-(void) addWatchGroup:(NSString*)groupId
              success:(void (^)())success
              failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    //组是否存在
    [self isGroupIdIsExisted:groupId queryRes:^(QueryResultType queryResult,AVObject* group) {
        switch (queryResult) {
            case QueryResult_Yes:
            {
                //是否已经在组内
                NSArray* tMembersArr = [group objectForKey:ObjectGroup_Member];
                if ([tMembersArr containsObject:m_AVUser.username]) {
                    failure(IMErrorType_AddWatchGroupHaved);
                }else{
                    AVObject* tUserWatchs = [AVObject objectWithClassName:ObjectClass_UserWatchs];
                    [tUserWatchs setObject:m_AVUser.username forKey:UserWatchs_KeyUserName];
                    [tUserWatchs setObject:group forKey:UserWatchs_KeyWatchGroup];
                    [tUserWatchs saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            if (error == nil) {
                                NSLog(@"save new GroupWatch class done %@",groupId);
                                //AVOSRealGroup 成员加入消息发出
                                AVGroup* tGroup= [AVGroup getGroupWithGroupId:group.objectId session:_session];
                                [tGroup join];
                                success();
                            }else{
                                NSLog(@"save new GroupWatch class fail error:%@",[error description]);
                                failure(IMErrorType_AddWatchSaveFail);
                            }
                        }else{
                            NSLog(@"save new UserWatchs class fail error:%@",[error description]);
                            failure(IMErrorType_AddWatchSaveFail);
                        }
                    }];
                }
            }
                break;
            case QueryResult_No:
            {
                failure(IMErrorType_AddWatchGroupNotExist);
            }
                break;
            case QueryResult_Fail:
            {
                failure(IMErrorType_AddWatchGroupFail);
            }
                break;
        }
    }];
}

/**
 *取消关注某个组(退出组)
 @Param groupName 唯一的组ID
 */
-(void) unWatchGroup:(NSString*)groupId
             success:(void (^)())success
             failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    //组是否存在
    [self isGroupIdIsExisted:groupId queryRes:^(QueryResultType queryResult,AVObject* group) {
        switch (queryResult) {
            case QueryResult_Yes:
            {
                if (group) {
                    //组是存在的
                    NSArray* tMembersArr = [group objectForKey:ObjectGroup_Member];
                    //是组的成员
                    if ([tMembersArr containsObject:m_AVUser.username]) {
                        NSString* tQueryUserWatchs = [NSString stringWithFormat:@"select * from %@ where %@='%@' and %@='%@'",ObjectClass_UserWatchs,UserWatchs_KeyWatchGroup,group.objectId,UserWatchs_KeyUserName,m_AVUser.username];
                        [AVQuery doCloudQueryInBackgroundWithCQL:tQueryUserWatchs callback:^(AVCloudQueryResult *result, NSError *error) {
                            if (error == nil) {
                                if ([result.results count] == 1) {
                                    //UserWatch 记录删除
                                    AVObject* tUserWatch = [result.results lastObject];
                                    [tUserWatch deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        if (error == nil && succeeded) {
                                            //AVOSRealGroup 成员退出消息发出
                                            AVGroup* tGroup= [AVGroup getGroupWithGroupId:group.objectId session:_session];
                                            [tGroup quit];
                                            success();
                                            NSLog(@"quit group success");
                                        }else{
                                            failure(IMErrorType_UnWatchGroupFail);
                                        }
                                    }];
                                }else{
                                    failure(IMErrorType_UnWatchGroupFail);
                                }
                            }else{
                                failure(IMErrorType_UnWatchGroupFail);
                            }
                        }];
                    }else{
                        //不是组的成员
                        failure(IMErrorType_UnWatchGroupUnNotMember);
                    }
                }else{
                    failure(IMErrorType_UnWatchGroupUnWatched);
                }
            }
                break;
            case QueryResult_No:
            {
                failure(IMErrorType_UnWatchGroupNotExist);
            }
                break;
            case QueryResult_Fail:
            {
                failure(IMErrorType_UnWatchGroupFail);
            }
                break;
        }
    }];
}

/**
 *创建一个组并且起个名字
 @Param name 群组名称
 */
-(void) createGroupName:(NSString*)name
                success:(void (^)())success
                failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    [AVGroup createGroupWithSession:_session groupDelegate:self callback:^(AVGroup *group, NSError *error) {
        if (error !=nil) {
            NSLog(@"create AVGroup fail");
            failure(IMErrorType_CreateGroupNameFail);
        }else{
            NSLog(@"create AVGroup ok %@",group.groupId);
            //save groupid
            NSString* tCQLStr = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_RealtimeGroups,Object_Id,group.groupId];
            [AVQuery doCloudQueryInBackgroundWithCQL:tCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
                if (error == nil) {
                    if ([result.results count] == 1) {
                        AVObject*  tPointerObject =[result.results lastObject];
                        [tPointerObject setObject:name forKey:RealtimeGroups_GroupName];
                        [tPointerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (error == nil&& succeeded) {
                                [tPointerObject refresh];
                                //增加关注记录
                                AVObject* tUserWatchs = [AVObject objectWithClassName:ObjectClass_UserWatchs];
                                [tUserWatchs setObject:m_AVUser.username forKey:UserWatchs_KeyUserName];
                                [tUserWatchs setObject:tPointerObject forKey:UserWatchs_KeyWatchGroup];
                                [tUserWatchs saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        if (error == nil) {
                                            success();
                                        }else{
                                            NSLog(@"save new GroupWatch class fail error:%@",[error description]);
                                            failure(IMErrorType_CreateGroupNameSaveFail);
                                        }
                                    }else{
                                        NSLog(@"save new UserWatchs class fail error:%@",[error description]);
                                        failure(IMErrorType_CreateGroupNameSaveFail);
                                    }
                                }];
                            }else{
                                failure(IMErrorType_CreateGroupNameSaveFail);
                            }
                        }];
                    }else{
                        NSLog(@"CQL error %@",[error description]);
                        failure(IMErrorType_CreateGroupNameQueryFail);
                    }
                }else{
                    NSLog(@"CQL error %@",[error description]);
                    failure(IMErrorType_CreateGroupNameQueryFail);
                }
            }];
        }
    }];
}

/**
 *邀请某人进入某小组
 @Param inviteUserName 被邀请人名称
 @Param toGroupName  小组名称
 */
-(void) inviteUserToGroup:(NSString*) inviteUserName
                GroupId:(NSString*) toGroupid
                  success:(void (^)())success
                  failure:(void (^)(IMErrorType failType))failure
{
    if ( _session != nil &&![_session isOpen]) {
        failure(IMErrorType_SessionNotOpen);
        return;
    }
    if ([inviteUserName isEqualToString:m_AVUser.username]) {
        failure(IMErrorType_InviteUserJoinGroup_IsSelf);
        return;
    }
    //用户是否存在
    [self userIsExist:inviteUserName success:^(AVUser *queryUser) {
        //小组存在并且用户未加入过
        [self isGroupIdIsExisted:toGroupid queryRes:^(QueryResultType queryResult, AVObject *group) {
            if (group) {
                NSArray* tMembersArr= [self queryGroupPeers:group.objectId];
                if ([tMembersArr containsObject:inviteUserName]) {
                    //已经在组内
                    failure(IMErrorType_InviteUserJoinGroup_UserExist);
                }else{
                    //保存邀请提醒
                    AVObject* tGroupRecord = [AVObject objectWithClassName:ObjectClass_GroupRecord];
                    [tGroupRecord setObject:m_AVUser.username forKey:GroupRecord_FromUserName];
                    [tGroupRecord setObject:inviteUserName forKey:GroupRecord_RecUserName];
                    [tGroupRecord setObject:toGroupid forKey:GroupRecord_GroupId];
                    [tGroupRecord saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded && error == nil) {
                            //发出邀请
                            AVGroup* tInviteGroup =[AVGroup getGroupWithGroupId:group.objectId session:_session];
                            [tInviteGroup invitePeerIds:@[inviteUserName]];
                            success();
                        }else{
                            failure(IMErrorType_InviteUserJoinGroup_Fail);
                        }
                    }];
                }
            }else{
                failure(IMErrorType_InviteUserJoinGroup_GroupNotExist);
            }
        }];
    } failure:^(IMErrorType failType) {
        if (failType == IMErrorType_QueryUserExistIsNot) {
            failure(IMErrorType_InviteUserJoinGroup_InviteNotExist);
        }else{
            failure(IMErrorType_InviteUserJoinGroup_Fail);
        }
        return ;
    }];
}

/**
 *获得某小组内的成员
 @Param groupId 已存在的groupId
 @Return 成员ID 数组(username)
 */
-(NSArray*) queryGroupPeers:(NSString*)groupId
{
    AVObject *groupObject = [AVObject objectWithoutDataWithClassName:ObjectClass_RealtimeGroups objectId:groupId];
    [groupObject fetch];
    NSArray *groupMembers = [groupObject objectForKey:@"m"];
    return groupMembers;
}

/**
 *群组是否存在
 @Param groupName 已存在的groupName
 @Return
 */
-(void) isGroupIdIsExisted:(NSString*)groupId
                queryRes:(void (^)(QueryResultType queryResult,AVObject* group))qResult
{
    
    NSString* tCQLStr = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_RealtimeGroups,Object_Id,groupId];
    [AVQuery doCloudQueryInBackgroundWithCQL:tCQLStr callback:^(AVCloudQueryResult *result, NSError *error) {
        if (error == nil) {
            if ([result.results count] == 1) {
                AVObject* tRealGroup = [result.results lastObject];
                qResult(QueryResult_Yes,tRealGroup);
            }else{
                qResult(QueryResult_No,nil);
            }
        }else{
            qResult(QueryResult_Fail,nil);
        }
    }];
}

/**
 *当session open 时候做整体check 群组的邀请记录
 */
-(void) checkGroupRecordWhenInit
{
    NSString* tGroupRecordCQL = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_GroupRecord,GroupRecord_RecUserName,m_AVUser.username];
    [AVQuery doCloudQueryInBackgroundWithCQL:tGroupRecordCQL callback:^(AVCloudQueryResult *result, NSError *error) {
        if (error == nil) {
            for (AVObject* tRecord in result.results) {
                NSString* tGroupIdStr = [tRecord objectForKey:GroupRecord_GroupId];
                NSString* tRealGroupCQL = [NSString stringWithFormat:@"select * from %@ where %@='%@'",ObjectClass_RealtimeGroups,Object_Id,tGroupIdStr];
                [AVQuery doCloudQueryInBackgroundWithCQL:tRealGroupCQL callback:^(AVCloudQueryResult *result, NSError *error) {
                    if (error == nil) {
                        if ([result.results count] == 1) {
                            AVObject* tUserWatchs = [AVObject objectWithClassName:ObjectClass_UserWatchs];
                            [tUserWatchs setObject:m_AVUser.username forKey:UserWatchs_KeyUserName];
                            [tUserWatchs setObject:[result.results lastObject] forKey:UserWatchs_KeyWatchGroup];
                            [tUserWatchs saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    if (error == nil) {
                                    }else{
                                        NSLog(@"%s save table %@ error",__PRETTY_FUNCTION__,ObjectClass_UserWatchs);
                                    }
                                }else{
                                    NSLog(@"%s save table %@ error",__PRETTY_FUNCTION__,ObjectClass_UserWatchs);                                }
                            }];
                        }
                    }else{
                        NSLog(@"%s query table %@ error",__PRETTY_FUNCTION__,ObjectClass_RealtimeGroups);
                    }
                }];
            }
        }else{
            NSLog(@"%s query table %@ error",__PRETTY_FUNCTION__,ObjectClass_GroupRecord);
        }
    }];
}

/**
 *查看用户所有的会话 (unused)
 */
-(void) getUserAllWatchs:(void (^)(NSArray* allWatchsArr))success
                 failure:(void (^)(IMErrorType failType))failure
{
    
}




@end
