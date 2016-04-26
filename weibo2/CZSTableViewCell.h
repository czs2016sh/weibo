//
//  CZSTableViewCell.h
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZSData.h"

@interface CZSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *source;

@property (weak, nonatomic) IBOutlet UIButton *retWeetButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *retWeetlabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;


@property (weak, nonatomic) IBOutlet UIView *timeLineView;

@property (strong, nonatomic) CZSData *data;
//初始化
-(void)setData:(CZSData *)data;


@end
