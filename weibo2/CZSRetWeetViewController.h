//
//  CZSRetWeetViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/14.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol achieveUserRetweetId <NSObject>

-(NSString *)achieveUserRetweetId;

@end

typedef void(^TypeBlock)(BOOL isSuccess);

@interface CZSRetWeetViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, assign) id<achieveUserRetweetId> delegate;

@property(nonatomic, copy)NSString *textViewInfo;

@property(nonatomic, strong)UITextView *textView;

@property(nonatomic, copy)NSString *cellInfo;

@property(nonatomic, strong)TypeBlock blockName;
@end
