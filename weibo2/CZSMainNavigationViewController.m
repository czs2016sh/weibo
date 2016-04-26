//
//  CZSMainNavigationViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSMainNavigationViewController.h"

@interface CZSMainNavigationViewController ()

@end

@implementation CZSMainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//第一次使用这个类的时候会调用，（1个类只会调用一次）,解释为：这个类在接受到第一个消息时会被调用
+(void)initialize{
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

//设置导航栏主题
+(void)setupNavigationBarTheme{
//    取出导航栏外观(appearance)
    UINavigationBar *naviBar = [UINavigationBar appearance];
    
//    设置背景,这个背景应该不会出来的
//    [naviBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    
//    设置标题属性,可以是字体，颜色，和阴影，这个需要一个存放字符串的字典进行初始化
//    NSMutableDictionary *textAttrs1 = @{
//                                       @"NSForegroundColorAttributeName":@"[UIColor blackColor]"
//                                       };
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:14];
    naviBar.titleTextAttributes = textAttrs;
//    [naviBar setTitleTextAttributes:textAttrs];
    
}

//设置导航栏按钮主题
+(void)setupBarButtonItemTheme{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
//    设置背景
    [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
//    设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:10];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateNormal];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
