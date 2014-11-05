//
//  RegistViewController.m
//  GameTalk
//
//  Created by Wang Li on 14-10-24.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"
#import "AVOS_IM_Manager.h"
#import "MBProManager.h"
@implementation RegistViewController
{
    
    __weak IBOutlet UITextField *repeatPWField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *userNameField;
}

-(IBAction)registAccountRequest:(id)sender
{
    AppDelegate* tAppDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([userNameField.text length] <= 6) {
        [[MBProManager shareInstance] showHubAutoDiss:@"用户名不能小于6位" titleText:@"输入错误" AferTime:3 containerView:tAppDel.window];
        return;
    }
    
    if ([passwordField.text length] <= 6) {
        [[MBProManager shareInstance] showHubAutoDiss:@"密码不能小于6位" titleText:@"输入错误" AferTime:3 containerView:tAppDel.window];
        return;
    }
    
    if (![passwordField.text isEqualToString:repeatPWField.text]) {
        [[MBProManager shareInstance] showHubAutoDiss:@"密码输入的不同" titleText:@"输入错误" AferTime:3 containerView:tAppDel.window];
        return;
    }
    
    
    AVUser *user = [AVUser user];
    user.username = userNameField.text;
    user.password = passwordField.text;
    [SVProgressHUD show];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Register success
            NSLog(@"Register success");
            [[NSUserDefaults standardUserDefaults] setObject:userNameField.text forKey:KEY_USERNAME];
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            AppDelegate* tAppDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [[MBProManager shareInstance] showHubAutoDiss:errorString titleText:@"登录错误" AferTime:3 containerView:tAppDel.window];
        }
        [SVProgressHUD dismiss];
    }];
}

@end
