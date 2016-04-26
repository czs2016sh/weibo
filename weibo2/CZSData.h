//
//  CZSData.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZSData : NSObject

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *created_at;
@property(nonatomic, copy)NSString *profile_image;
@property(nonatomic, copy)NSString *text;
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, copy)NSString *scourceStr;
@property(nonatomic, assign)NSInteger reposts_count;
@property(nonatomic, assign)NSInteger comments_count;
@property(nonatomic, assign)NSInteger attitudes_count;
@property(nonatomic, assign)NSInteger like_count;

@end
