//
//  CZSMainTabBarController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSMainTabBarController.h"
#import "CZSTableViewController.h"
#import "CZSMainNavigationViewController.h"
#import "CZSMessageViewController.h"
#import "CZSOthersViewController.h"
#import "CZSFindViewController.h"
#import "CZSMeTableViewController.h"


@interface CZSMainTabBarController ()

@end

@implementation CZSMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"222");
    [self setupAllChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupAllChildViewControllers{
//    添加子视图控制器
//    首页
    CZSTableViewController *homeController = [[CZSTableViewController alloc]init];
    [self setupChildViewController:homeController title:@"首页" imageName:@"tabbar_home" selectImageName:@"tabbar_home_selected"];
    
//    消息
    UIStoryboard *messageSb = [UIStoryboard storyboardWithName:@"CZSMessageStoryboard" bundle:nil];
    CZSMessageViewController *messageController = [messageSb instantiateViewControllerWithIdentifier:@"czs"];
    [self setupChildViewController:messageController title:@"消息" imageName:@"tabbar_message_center" selectImageName:@"tabbar_message_center_selected"];
    
//    中间占位
    CZSOthersViewController *othersController = [[CZSOthersViewController alloc]init];
//    othersController.title = @"发布微博";
//    othersController.view.backgroundColor = [UIColor whiteColor];
//    UINavigationController *othersNavC = [[UINavigationController alloc]initWithRootViewController:othersController];
//    
    [self addChildViewController:othersController];
    
//    发现
    UIStoryboard *findSb = [UIStoryboard storyboardWithName:@"CZSFindStoryboard" bundle:nil];
    CZSFindViewController *findController = [findSb instantiateViewControllerWithIdentifier:@"czs"];
    [self setupChildViewController:findController title:@"发现" imageName:@"tabbar_discover" selectImageName:@"tabbar_discover_selected"];
    
//    我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CZSMeStoryboard" bundle:[NSBundle mainBundle]];
    CZSMeTableViewController *meController = [storyboard instantiateViewControllerWithIdentifier:@"czs"];
    [self setupChildViewController:meController title:@"我" imageName:@"tabbar_profile" selectImageName:@"tabbar_profile_selected"];
    
//    添加中间的加号
    [self setupCenterButton];
    
//    配置tab bar
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
}


//配置单个navigation view controller
-(void)setupChildViewController:(UIViewController *)viewController title:(NSString *)title imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName{
//    设置属性
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    viewController.view.backgroundColor = [UIColor whiteColor];
    
//    包装一个导航控制器加入到tab bar controller中
    CZSMainNavigationViewController *navi = [[CZSMainNavigationViewController alloc]initWithRootViewController: viewController];
    [self addChildViewController:navi];
}


//配置中间的加号按钮
-(void)setupCenterButton{
    [self.tabBar.items[2] setEnabled:YES];
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.bounds.size.width/5-10,self.tabBar.bounds.size.height-8);
    centerButton.frame = CGRectMake(origin.x-buttonSize.height/2, origin.y-buttonSize.height/2, buttonSize.height, buttonSize.height);
    centerButton.backgroundColor = [UIColor whiteColor];
    [centerButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
    
    [self.tabBar addSubview:centerButton];
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
