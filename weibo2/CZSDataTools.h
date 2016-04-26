//
//  CZSDataTools.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/9.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CZSOauchData;

@interface CZSDataTools : NSObject

/**
 *  返回存储的账号信息
 *
 *  @return 账号信息
 */

+(CZSOauchData *)oauchData;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */

+ (void)saveData:(CZSOauchData *)oauchData;

@end
