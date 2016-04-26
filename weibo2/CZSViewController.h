//
//  CZSViewController.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/7.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZSViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIWebView *userWebView;

@end
