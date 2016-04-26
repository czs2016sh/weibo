//
//  CZSNetworkRequest.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/16.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSNetworkRequest.h"

@implementation CZSNetworkRequest

//GET方式请求
+(void)networkRequestGET:(NSString *)string dic:(NSDictionary *)dic completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler{

//    获取参数
    NSMutableString *parameStr = [NSMutableString string];
    NSArray *keyArray = [dic allKeys];
    for (int i = 0; i < keyArray.count; i ++) {
        NSString *key = keyArray[i];
        NSString *value = [dic valueForKey:key];
        NSString *tempStr;
        if (i == keyArray.count - 1) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,value];
        }else {
            tempStr = [NSString stringWithFormat:@"%@=%@&",key,value];
        }
        [parameStr appendString:tempStr];
    }
//    构建URL
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",string,parameStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
//    考虑到要使用网络很好的情况下进行提示，使用request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSLog(@"timeout:%f",request.timeoutInterval);
//    构建会话
    NSURLSession *session = [NSURLSession sharedSession];
//    构建data task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completionHandler];
    
    [dataTask resume];
}


//POST方法请求数据
+(void)networkRequestPOST:(NSString *)string dic:(NSDictionary *)dic completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler{
//    构建参数字符串
    NSString *temp;
    NSMutableString *parameStr = [NSMutableString string];
    NSArray *keyArray = [dic allKeys];
    for (int i = 0; i < keyArray.count; i ++) {
        NSString *key = keyArray[i];
        NSString *value = [dic valueForKey: key];
        NSString *tempStr;
        if (i == keyArray.count - 1) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,value];
        }else {
            tempStr = [NSString stringWithFormat:@"%@=%@&",key,value];
        }
        [parameStr appendString:tempStr];
    }
    temp = parameStr;
//    构建rul
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:string];
//    构建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"POST";
    temp = [temp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    request.HTTPBody = [NSData dataWithBytes:temp.UTF8String length:parameStr.length];
//    构建会话
    NSURLSession *session = [NSURLSession sharedSession];
//    构建data task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:completionHandler];
    
    [dataTask resume];
}

@end
