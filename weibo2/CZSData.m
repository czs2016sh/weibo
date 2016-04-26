//
//  CZSData.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSData.h"

@implementation CZSData
//多参数赋值KVC
-(NSString *)description{
    return @"*********";
}


//-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
//    
//}

//-(id)valueForUndefinedKey:(NSString *)key{
//    
//}

//主要就是这个方法，重写就好了，傻傻都不用干
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end
