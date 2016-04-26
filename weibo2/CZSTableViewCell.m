//
//  CZSTableViewCell.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSTableViewCell.h"
#import "CZSRetWeetViewController.h"
#import "AppDelegate.h"

@implementation CZSTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(CZSData *)data{
    self.nameLabel.text = data.name;
    self.lastTextLabel.text = data.text;
    self.imgView.layer.cornerRadius = 25;
    self.imgView.image = [UIImage imageNamed:@"avatar_default"];
    self.timeLabel.textColor = [UIColor orangeColor];
    self.lastTextLabel.textColor = [UIColor redColor];
    self.source.text = data.scourceStr;
    if (0 == data.reposts_count) {
        self.retWeetlabel.text = @"转发";
    }else {
        self.retWeetlabel.text = [NSString stringWithFormat:@"%d", data.reposts_count];
    }
    if (0 == data.comments_count) {
        self.commentLabel.text = @"评论";
    }else {
        self.commentLabel.text = [NSString stringWithFormat:@"%d", data.comments_count];
    }
    if (0 == data.attitudes_count) {
        self.likeLabel.text = @"赞";
    }else {
        self.likeLabel.text = [NSString stringWithFormat:@"%d", data.attitudes_count];
    }
    
    if (0 == data.like_count % 2) {
        [self.likeButton setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
//        self.likeButton.imageView.image = [UIImage imageNamed:@"timeline_icon_unlike"];
    }else {
        [self.likeButton setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateNormal];
//        self.likeButton.imageView.image = [UIImage imageNamed:@"timeline_icon_like"];
    }
    
   
    
    
//    时间转换为正常显示
    NSDate *nowDate = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEE-MMM-dd HH:mm:ss ZZZ yyyy";
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en-US"];
    NSDate *createdAtDate = [dateFormatter dateFromString:data.created_at];
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitYear |  NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:nowDate options:0];
    
     if (cmps.year <= 1){
        if (cmps.month < 1) {
            if (cmps.weekday < 7) {
                if (cmps.day < 3) {
                    if (cmps.day < 2) {
                        if (cmps.day < 1) {
                            if (cmps.hour < 1) {
                                if (cmps.minute <= 1) {
                                    self.timeLabel.text = @"刚刚";
                                }else {
                                    self.timeLabel.text = [NSString stringWithFormat:@"%d分钟前",cmps.minute];
                                }
                            }else {
                                self.timeLabel.text = [NSString stringWithFormat:@"%d小时前",cmps.hour];
                            }
                        }else {
                            dateFormatter.dateFormat = @"昨天 HH:mm:ss";
                            self.timeLabel.text = [dateFormatter stringFromDate:createdAtDate];
                        }
                    }else {
                        dateFormatter.dateFormat = @"前天 HH:mm:ss";
                        self.timeLabel.text = [dateFormatter stringFromDate:createdAtDate];
                    }
                }else {
                    dateFormatter.dateFormat = [NSString stringWithFormat:@"%ld HH:mm:ss",(long)cmps.weekday];
                    self.timeLabel.text = [dateFormatter stringFromDate:createdAtDate];
                }
            }else {
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.timeLabel.text = [dateFormatter stringFromDate:createdAtDate];
            }
        }else {
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.timeLabel.text = [dateFormatter stringFromDate:createdAtDate];
        }
     }else {
         self.timeLabel.text = @"long long time ago";
     }
    
//    获取一个全局队列（这个队列是并行的），活着创建一个并行队列
    dispatch_queue_t queue = dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    异步方法
    dispatch_async(queue, ^{
        data.profile_image = [data.profile_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:data.profile_image];
        NSData *imgData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithData:imgData];
        });
    });
}



@end
