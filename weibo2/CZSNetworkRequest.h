//
//  CZSNetworkRequest.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/16.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZSNetworkRequest : NSObject


+ (void)networkRequestGET:(NSString *)string dic:(NSDictionary *)dic completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

+ (void)networkRequestPOST:(NSString *)string dic:(NSDictionary *)dic completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
