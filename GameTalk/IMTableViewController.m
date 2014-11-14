//
//  IMTableViewController.m
//  GameTalk
//
//  Created by Wang Li on 14-10-28.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "IMTableViewController.h"
#import "AVOS_IM_Manager.h"

#define IDentifierLoginRegist  @"IMPesent"
#define InviteAlertViewTag  20


@implementation IMTableViewController
{
    
    NSArray*  _AttentionArr;//关注的所有的东西
    
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{

}


-(IBAction) inviteUser:(id)sender
{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController* tAlertController  = [UIAlertController alertControllerWithTitle:@"邀请用户" message:@"请输入被邀请的用户名：" preferredStyle:UIAlertControllerStyleAlert];
        [tAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.frame =CGRectMake(10, 30, 200, 30);
        }];
        [self presentViewController:tAlertController animated:YES completion:^{
            
        }];
        UIAlertAction* tCancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        UIAlertAction* tInviteAction = [UIAlertAction actionWithTitle:@"发出邀请" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UITextField* tInviteField = [tAlertController.textFields lastObject];
            if ([tInviteField.text length] <=6) {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"邀请的用户名称错误" titleText:@"错误" AferTime:3 containerView:self.view];
            }else{
                [self funcInviteGroupOper:tInviteField.text  GroupName:@"5459e29fe4b0b14db2b72a04"];
            }
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [tAlertController addAction:tCancelAction];
        [tAlertController addAction:tInviteAction];
    }else{
        UIAlertView* tInputView = [[UIAlertView alloc] initWithTitle:@"邀请用户" message:@"请输入被邀请的用户名：" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送邀请", nil];
        tInputView.tag =InviteAlertViewTag;
        tInputView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [tInputView show];
    }
}
#pragma mark-
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == InviteAlertViewTag) {
        if (buttonIndex == 0) {
            //取消
            
        }else if(buttonIndex == 1){
            //发送邀请
            UITextField* tInputField = [alertView textFieldAtIndex:0];
            if ([tInputField.text length] <=6) {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"邀请的用户名称错误" titleText:@"错误" AferTime:3 containerView:self.view];
            }else{
                [self funcInviteGroupOper:tInputField.text  GroupName:@"同城捡肥皂"];
            }
        }
        alertView.delegate =nil;
    }
}


#pragma mark-
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_AttentionArr count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tChatCellName = @"chatCell";
    UITableViewCell*  tCell = [tableView dequeueReusableCellWithIdentifier:tChatCellName];
    if (tCell == nil) {
        NSLog(@"xib IMTableViewController error cell is nil");
    }else{
        UIImageView* tHeaderImg = (UIImageView*)[tCell.contentView viewWithTag:11];
        UILabel* tUnreadLab = (UILabel*) [tCell.contentView viewWithTag:10];
        UILabel* tRoomLab = (UILabel*) [tCell.contentView viewWithTag:12];
        UILabel* tLastDataLab = (UILabel*) [tCell.contentView viewWithTag:13];
    }
    return tCell;
}

/**
 *处理邀请进组操作
 @Param userName   用户名
 @Param groupName  群组名
 */
-(void) funcInviteGroupOper:(NSString*) userName
                  GroupName:(NSString*) groupName
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [[AVOS_IM_Manager shareInstance] inviteUserToGroup:userName GroupId:groupName success:^{
        [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:nil titleText:@"邀请成功" AferTime:3 containerView:self.view];
    } failure:^(IMErrorType failType) {
        switch ((int)failType) {
            case IMErrorType_InviteUserJoinGroup_GroupNotExist:
            {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"群组不存在" titleText:@"错误" AferTime:3 containerView:self.view];
            }
                break;
            case IMErrorType_InviteUserJoinGroup_UserExist:
            {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"用户已近加入该群" titleText:@"错误" AferTime:3 containerView:self.view];
            }
                break;
            case IMErrorType_InviteUserJoinGroup_IsSelf:
            {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"不可邀请自己" titleText:@"错误" AferTime:3 containerView:self.view];
            }
                break;
            case IMErrorType_InviteUserJoinGroup_InviteNotExist:
            {
                [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"用户不存在" titleText:@"错误" AferTime:3 containerView:self.view];
            }
                break;
                
        }
    }];
}

@end
