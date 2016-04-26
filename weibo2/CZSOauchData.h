//
//  CZSOauchData.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/9.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZSOauchData : NSObject

//access_token	string	用于调用access_token，接口获取授权后的access token。
//expires_in	string	access_token的生命周期，单位是秒数。
//remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
//uid	string	当前授权用户的UID。

//令牌
@property(nonatomic, copy)NSString *access_token;

//令牌的生命周期
@property(nonatomic, assign)long long expires_in;

//令牌的生命周期
@property(nonatomic, assign)long long remind_in;

//当前授权用户的uid
@property(nonatomic, assign)long long uid;

//date
@property(nonatomic, copy)NSDate *expiresTime;

//用户名
@property(nonatomic, copy)NSString *name;

//初始化
-(CZSOauchData *)initWithDictionary:(NSDictionary *)dic;

//工厂方法
+(id)dataWithDictionary:(NSDictionary *)dic;

@end
