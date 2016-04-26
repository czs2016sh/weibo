//
//  AppDelegate.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/7.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "CZSTableViewController.h"
#import "CZSViewController.h"
#import "CZSDataTools.h"
#import "CZSMainTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    因为删除了main.storyboard，所以这里需要手动写一些代码，之前也写过的，应该是分3步，
//    1.创建一个window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    2.设为keywindow并可见
    [self.window makeKeyAndVisible];
//    3.选择一个视图控制器并作为首个视图控制器（rootviewcontroller)
//        这里也是选择微博登录的页面还是选择已经登录后的页面，所以作用还是很大的，不可以马虎
//    测试数据加载是否正确
//    self.window.rootViewController = [[CZSTableViewController alloc]init];
    
//    测试登陆
//    self.window.rootViewController = [[CZSViewController alloc]initWithNibName:@"CZSViewController" bundle:nil];
    
//    判断是否登陆过来决定根视图控制器
    CZSOauchData *oauchData = [CZSDataTools oauchData];
    if (nil != oauchData ) {
//        已经登陆过
        
        self.window.rootViewController = [[CZSMainTabBarController alloc]init];
    }else {
        self.window.rootViewController = [[CZSViewController alloc]initWithNibName:@"CZSViewController" bundle:nil];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
