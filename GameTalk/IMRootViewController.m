//
//  IMRootViewController.m
//  GameTalk
//
//  Created by WangLi on 14/11/7.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "IMRootViewController.h"

@interface IMRootViewController ()

@end

@implementation IMRootViewController
{
    
    __weak IBOutlet UIButton *bottomBttRecent;
    __weak IBOutlet UIButton *bottomBttGroup;
    __weak IBOutlet UIView *bottomView;
    __weak IBOutlet UIButton *bottomBttAll;
    __weak IBOutlet UITableView *tableView;
    
    NSArray*     _RecentArr;//最近联系人
    NSArray*     _AllContactsArr;//所有联系人
    NSArray*     _GroupArr;//群组数据
}
- (void)viewDidLoad{
    [bottomView addSubview:bottomBttRecent];
    [bottomView addSubview:bottomBttGroup];
    [bottomView addSubview:bottomBttAll];
    // Do any additional setup after loading the view.
    NSDictionary *viewsDictionary = @{@"bttRec":bottomBttRecent,@"bttGroup":bottomBttGroup,@"bttAll":bottomBttAll};
    NSArray* HConts = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bttRec(bttGroup,bttAll)]-0-[bttAll]-0-[bttGroup]-0-|" options:0 metrics:nil views:viewsDictionary];
    [bottomView addConstraints:HConts];
    
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
    return 10;
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
