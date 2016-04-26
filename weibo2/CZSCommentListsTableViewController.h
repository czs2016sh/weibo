//
//  CZSCommentListsTableViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSCommentListsTableViewController : UITableViewController

@property(nonatomic, copy)NSString *userId;

@property(nonatomic, strong)NSMutableArray *dataArray;

@end
