//
//  CZSCommentViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol achieveUserCommentId <NSObject>

-(NSString *)achieveUserCommentId;

@end

typedef void(^BloakType)(BOOL isSuccess);

@interface CZSCommentViewController : UIViewController<UITextViewDelegate>


@property(nonatomic, assign) id<achieveUserCommentId> delegate;
@property(nonatomic, copy) NSString *textViewInfo;
@property(nonatomic, strong) UITextView *textView;

@property(nonatomic, strong)BloakType blockName;

@end
