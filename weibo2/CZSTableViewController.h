//
//  CZSTableViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSRetWeetViewController.h"
#import "CZSCommentViewController.h"

@interface CZSTableViewController : UITableViewController<UIScrollViewDelegate,achieveUserRetweetId,achieveUserCommentId>

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@end
