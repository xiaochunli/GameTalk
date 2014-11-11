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
#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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

@end
