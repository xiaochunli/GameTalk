//
//  APPCommonDefine.h
//  GameTalk
//
//  Created by Wang Li on 14-10-22.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#ifndef GameTalk_APPCommonDefine_h
#define GameTalk_APPCommonDefine_h

#define AVOSAppID @"9aimd70480ily4xvkiccj0ivn9en6iidifg7x4o02aafjh6g"
#define AVOSAppKey @"y37n2u6anf8cx796zuyiqn5mz4404tshc75t2xjds41fpjsy"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgb) [UIColor colorWithRed:((rgb) & 0xFF0000 >> 16)/255.0 green:((rgb) & 0xFF00 >> 8)/255.0 blue:((rgb) & 0xFF)/255.0 alpha:1.0]

//userdefault  保存KEY
#define KEY_USERNAME @"KEY_USERNAME"


//AVObject-Name
#define Object_Id @"objectId"
#define Object_CreatedAt @"createdAt"
#define Object_UpdatedAt @"updatedAt"
#define ObjectGroup_Member @"m"


/*_User class
 用户名称表
 */
#define ObjectClass_User @"_User"
#define ObjectClass_User_userName @"username"

/*AVOSRealtimeGroups class
 群组名称表
 */
#define ObjectClass_RealtimeGroups @"AVOSRealtimeGroups"
#define RealtimeGroups_GroupName @"GName"


/*GroupRecord class
 群组名称表
 */
#define ObjectClass_GroupRecord @"GroupRecord"
#define GroupRecord_FromUserName @"FromUserName"
#define GroupRecord_RecUserName @"RecUserName"
#define GroupRecord_GroupId @"GroupId"

/*UserWatchs class
 用户关注表
 */
#define ObjectClass_UserWatchs @"UserWatchs"
#define UserWatchs_KeyUserName @"userName"
#define UserWatchs_KeyWatchUser @"watchUser"
#define UserWatchs_KeyWatchGroup @"watchGroup"


//Notification
//#define Notif_CreateGroupNameSuccess  @"CreateGroupNameFailError"//新创建群组成功
//#define Notif_CreateGroupNameFail_Existed  @"CreateGroupNameFailExisted"//已存在新创建群组失败
//#define Notif_CreateGroupNameFail_Error  @"CreateGroupNameFailError"//新创建群组失败


#endif
