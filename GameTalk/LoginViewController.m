//
//  LoginViewController.m
//  GameTalk
//
//  Created by Wang Li on 14-10-24.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "LoginViewController.h"
#import <AVOSCloud/AVUser.h>
#import "AppDelegate.h"
#import "AVOS_IM_Manager.h"
@implementation LoginViewController
{
    
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UITextField *userNameField;
}
-(void) viewDidLoad
{
    userNameField.text =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
}

-(IBAction) loginBttPressed:(id)sender
{
    AppDelegate* tAppDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([userNameField.text length] <= 6) {
        [[MBProManager shareInstance] showHubAutoDiss:@"用户名不能小于6位" AferTime:3 containerView:tAppDel.window];
        return;
    }
    
    if ([passwordField.text length] <= 6) {
        [[MBProManager shareInstance] showHubAutoDiss:@"密码不能小于6位" AferTime:3 containerView:tAppDel.window];
        return;
    }
    
    [SVProgressHUD show];
    [AVUser logInWithUsernameInBackground:userNameField.text password:passwordField.text block:^(AVUser *user, NSError *error) {
        if (user) {
            //Login success
            [[NSUserDefaults standardUserDefaults] setObject:userNameField.text forKey:KEY_USERNAME];
            NSLog(@"Login success");
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                
            }];
        } else {
            //Something bad has ocurred
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            long errorCode = [[[error userInfo] objectForKey:@"code"] longValue];
            AppDelegate* tAppDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
            if (errorCode == 210) {
                [[MBProManager shareInstance] showHubAutoDiss:@"输入的密码错误" AferTime:3 containerView:tAppDel.window];
            } else if (errorCode == 211) {
                [[MBProManager shareInstance] showHubAutoDiss:@"用户不存在" AferTime:3 containerView:tAppDel.window];
            }
        }
        [SVProgressHUD dismiss];
    }];
}

-(IBAction) cancelLoginView:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}
@end
