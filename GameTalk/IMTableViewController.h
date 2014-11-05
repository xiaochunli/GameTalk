//
//  IMTableViewController.h
//  GameTalk
//
//  Created by Wang Li on 14-10-28.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


-(IBAction) inviteUser:(id)sender;
@end
