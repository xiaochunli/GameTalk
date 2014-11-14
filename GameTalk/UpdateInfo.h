//
//  UpdateInfo.h
//  GameTalk
//
//  Created by WangLi on 14/11/13.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UpdateInfo : NSManagedObject

@property (nonatomic, retain) NSDate * groupInfoDate;
@property (nonatomic, retain) NSDate * userInfoDate;
@end
