//
//  CZSOthersViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSOthersViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, copy) NSString *textViewInfo;
@property (nonatomic, strong) UITextView *textView;

@end
