//
//  MBProManager.h
//  GameTalk
//
//  Created by Wang Li on 14-10-28.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProManager : NSObject<MBProgressHUDDelegate>
+ (id)shareInstance;
-(void) showHubAutoDiss:(NSString*) content AferTime:(float) dissTime containerView:(UIView *)view;
@end
