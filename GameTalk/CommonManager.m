//
//  CommonManager.m
//  GameTalk
//
//  Created by Wang Li on 14-10-29.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "CommonManager.h"
static CommonManager *    s_CommManager = nil;
@implementation CommonManager
- (void)dealloc
{
    
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_CommManager = [[CommonManager alloc] init];
    });
    return s_CommManager;
}

///本地抛出一条消息
-(void) postNotification:(NSString*) notificationName
{
    NSNotification* tNewNoti = [NSNotification notificationWithName:notificationName object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:tNewNoti];

}
@end
