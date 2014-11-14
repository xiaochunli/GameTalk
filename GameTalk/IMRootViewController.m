//
//  IMRootViewController.m
//  GameTalk
//
//  Created by WangLi on 14/11/7.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "IMRootViewController.h"
#import "CDataManager.h"
#import "UpdateInfo.h"
#import "AVOS_IM_Manager.h"
#import "MBProManager.h"

#define IDentifierLoginRegist  @"IMPesent"

typedef enum ShowStatus{
    SStatus_Recent=0x10,
    SStatus_All,
    SStatus_Group
}ShowStatus;

@interface IMRootViewController ()

@end

@implementation IMRootViewController
{
    
    __weak IBOutlet UIButton *         bottomBttRecent;
    __weak IBOutlet UIButton *         bottomBttGroup;
    __weak IBOutlet UIView *           bottomView;
    __weak IBOutlet UIButton *         bottomBttAll;
    __weak IBOutlet UITableView *      tableView;
    
    ShowStatus                          _NowStatus;
    
    NSArray*                            _RecentArr;//最近联系人
    NSArray*                            _AllContactsArr;//所有联系人
    NSArray*                            _GroupArr;//群组数据
    AVUser*                             _currentUser;
    BOOL                                _IsNeedInitFriendGroup;//是否本界面重新初始化下
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _IsNeedInitFriendGroup = YES;
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated
{
    if ((_currentUser =[AVUser currentUser]) == nil) {
        //需要登录
        UIStoryboard *story = [UIStoryboard  storyboardWithName:@"Main" bundle:nil];
        UINavigationController* tLoginNav = [story instantiateViewControllerWithIdentifier:IDentifierLoginRegist];
        [self presentViewController:tLoginNav animated:YES completion:^{}];
    }else{
        AVOS_IM_Manager* tIMManager = [AVOS_IM_Manager shareInstance];
        tIMManager.m_AVUser =_currentUser;
        [self initIMListView];
    }
}

-(void) initIMListView
{
    if (_IsNeedInitFriendGroup) {
        _IsNeedInitFriendGroup = NO;
        [[AVOS_IM_Manager shareInstance] openIMSession];
        [self updateLocalData];
    }
}


- (void)viewDidLoad{
    [bottomView addSubview:bottomBttRecent];
    [bottomView addSubview:bottomBttGroup];
    [bottomView addSubview:bottomBttAll];
    // Do any additional setup after loading the view.
    NSDictionary *viewsDictionary = @{@"bttRec":bottomBttRecent,@"bttGroup":bottomBttGroup,@"bttAll":bottomBttAll};
    NSArray* HConts = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bttRec(bttGroup,bttAll)]-0-[bttAll]-0-[bttGroup]-0-|" options:0 metrics:nil views:viewsDictionary];
    [bottomView addConstraints:HConts];
    
    _NowStatus =SStatus_Recent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *更新本地数据
 */
-(void) updateLocalData
{
    CDataManager* tCDataManager = [CDataManager shareInstance];
    UpdateInfo* tUpdateInfo = [tCDataManager queryUpdateInfo];
    if (tUpdateInfo == nil) {
        NSDate* tNowDate = [NSDate date];
        tUpdateInfo = [tCDataManager createUpdateInfo:@{@"userInfoDate":tNowDate,@"groupInfoDate":tNowDate}];
    }
    AVOS_IM_Manager* tIMManager = [AVOS_IM_Manager shareInstance];
    [tIMManager queryUserWatchedContacts:/*tUpdateInfo.userInfoDate*/nil success:^(NSArray *resultDataArr) {
        for (AVObject* tUserObject in resultDataArr) {
            id tWatchIdStr = nil;
            if ((tWatchIdStr = [tUserObject objectForKey:UserWatchs_KeyWatchUser]) != nil) {
                //关注是用户
                AVUser* tUser = (AVUser*)tWatchIdStr;
                UserInfo* tUserInfo = [tCDataManager queryUserInfo:tUser.objectId];
                if (tUserInfo== nil) {
                    //新增
                    [tCDataManager createUserInfo:@{@"userId":tUser.objectId,@"userName":tUser.username}];
                }else{
                    //更新
                    [tCDataManager updateUserInfo:@{@"userId":tUser.objectId,@"userName":tUser.username} updateObject:tUserInfo];
                }
            }else if((tWatchIdStr = [tUserObject objectForKey:UserWatchs_KeyWatchGroup])!= nil){
                //关注是群组
                AVObject* tGroup = (AVObject*)tWatchIdStr;
                GroupInfo* tGroupInfo = [tCDataManager queryGroupInfo:tGroup.objectId];
                if (tGroupInfo== nil) {
                    //新增
                    [tCDataManager createGroupInfo:@{@"groupName":[tGroup objectForKey:RealtimeGroups_GroupName],@"groupId":tGroup.objectId,@"groupImg":@"",@"membersRS":[tGroup objectForKey:ObjectGroup_Member]}];
                }else{
                    //更新
                    [tCDataManager updateGroupInfo:@{@"groupName":[tGroup objectForKey:RealtimeGroups_GroupName],@"groupId":tGroup.objectId,@"groupImg":@"",@"membersRS":[tGroup objectForKey:ObjectGroup_Member]} updateObject:tGroupInfo];
                }
            }
        }
    } failure:^(IMErrorType failType) {
        [(MBProManager*)[MBProManager shareInstance] showHubAutoDiss:@"" titleText:@"请求失败，请稍后再试" AferTime:3 containerView:self.navigationController.view];
    }];
}

/**
 *加载当前视图显示的数据
 */
-(void) readDataFromCoreData
{
    CDataManager* tCDataManager = [CDataManager shareInstance];
    switch (_NowStatus) {
        case SStatus_Recent:
        {
            _RecentArr = [tCDataManager queryRecentSessionData];
        }
            break;
        case SStatus_All:
        {
            _AllContactsArr = [tCDataManager queryAllContactData];
        }
            break;
        case SStatus_Group:
        {
            _GroupArr = [tCDataManager queryAllGroupData];
        }
            break;
        default:
            break;
    }
}

/**
 *切换显示模式
 */
-(IBAction)changeStatus:(UIButton*)sender
{
    switch (sender.tag) {
        case 1://最近联系
        {
            
        }
            break;
        case 2://我的所有联系人
        {
            
        }
            break;
        case 3://群组显示
        {
            
        }
            break;
        default:
            break;
    }
    [tableView reloadData];
}

#pragma mark-
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView* tHeaderImg = (UIImageView*)[cell.contentView viewWithTag:11];
    UILabel* tUnreadLab = (UILabel*) [cell.contentView viewWithTag:10];
    UILabel* tRoomLab = (UILabel*) [cell.contentView viewWithTag:12];
    UILabel* tLastDataLab = (UILabel*) [cell.contentView viewWithTag:13];
    tUnreadLab.layer.cornerRadius = 10.5;
    tUnreadLab.layer.masksToBounds = YES;
}
#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_NowStatus) {
        case SStatus_Recent:
        {
            return [_RecentArr count];
        }
            break;
        case SStatus_All:
        {
            return [_AllContactsArr count];
        }
            break;
        case SStatus_Group:
        {
            return [_GroupArr count];
        }
            break;
        default:
        {
            return 0;
        }
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)IntableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tChatCellName = @"recentcell";
    UITableViewCell*  tCell = [IntableView dequeueReusableCellWithIdentifier:tChatCellName];
    if (tCell == nil) {
        NSLog(@"xib IMTableViewController error cell is nil");
    }else{
        
    }
    return tCell;
}

@end
