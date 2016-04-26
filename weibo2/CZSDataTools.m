//
//  CZSDataTools.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/9.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSDataTools.h"
#import "CZSOauchData.h"

#define PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CZSData.data"]

@implementation CZSDataTools

+ (CZSOauchData *)oauchData {
    // 取出账号
    CZSOauchData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH];
    
    // 判断账号是否过期
    NSDate *now = [NSDate date];
    if ([now compare:data.expiresTime] == NSOrderedAscending) {
        // 还没过期
        NSLog(@"meiguo qi ");
        return data;
    } else {
        // 过期
        NSLog(@"guoqi");
        return nil;
    }
}


+ (void)saveData:(CZSOauchData *)oauchData {
    // 计算过期时间
    NSDate *now = [NSDate date];
    oauchData.expiresTime = [now dateByAddingTimeInterval:oauchData.expires_in];
    NSLog(@"---%@",oauchData);
    [NSKeyedArchiver archiveRootObject:oauchData toFile:PATH];
    NSLog(@"***%@",oauchData);
}


@end
