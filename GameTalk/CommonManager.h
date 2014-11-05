//
//  CommonManager.h
//  GameTalk
//
//  Created by Wang Li on 14-10-29.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonManager : NSObject
+ (id)shareInstance;

///本地抛出一条消息
-(void) postNotification:(NSString*) notificationName;
@end
