//
//  MBProManager.m
//  GameTalk
//
//  Created by Wang Li on 14-10-28.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "MBProManager.h"
static MBProManager *    s_MBProManager = nil;
@implementation MBProManager
- (void)dealloc
{
    
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_MBProManager = [[MBProManager alloc] init];
    });
    return s_MBProManager;
}


/**
 *显示一个提示X秒后消失
 @Param  content 内容
 @Param  title  标题
 @Param  dissTime 消失的秒数
 @Param  view 承载的视图
 */
-(void) showHubAutoDiss:(NSString*) content
              titleText:(NSString*) title
               AferTime:(float) dissTime
          containerView:(UIView *)view
{
    MBProgressHUD* tMBHud = [[MBProgressHUD alloc] initWithView:view];
    tMBHud.mode = MBProgressHUDModeText;
    tMBHud.labelText = title;
    tMBHud.detailsLabelText =content;
    tMBHud.delegate = self;
    [view addSubview:tMBHud];
    [tMBHud show:YES];
    [tMBHud hide:YES afterDelay:dissTime];
}


#pragma mark-
#pragma mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    hud = nil;
}
@end
