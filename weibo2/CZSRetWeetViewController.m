//
//  CZSRetWeetViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/14.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSRetWeetViewController.h"
#import "CZSDataTools.h"
#import "CZSOauchData.h"
#import "CZSNetworkRequest.h"

#define RETWEET @"https://api.weibo.com/2/statuses/repost.json"


@interface CZSRetWeetViewController ()

@end

@implementation CZSRetWeetViewController{
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 构造界面
-(void)setupInterface{
//    左按钮
    self.navigationItem.title = @"转发微博";
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    右按钮
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"转发" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    添加textview
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, 320, 200)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.textColor = [UIColor redColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.center = CGPointMake(160, 100);
    _textView.backgroundColor = [UIColor colorWithRed:0.86 green:0.76 blue:0.75 alpha:1];
    [_textView becomeFirstResponder];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _label.center = CGPointMake(163, 16);
    [_label setText:@"不想说点什么吗..."];
    _label.enabled = NO;
    [_textView addSubview:_label];
    _textView.delegate = self;

    [self.view addSubview:_textView];
//    添加一个cell，用来存放内容
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.text = self.cellInfo;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor greenColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    CGSize cellInfoSize = [label.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    label.frame = CGRectMake(0, 0, 300, cellInfoSize.height + 10);
    cell.frame = CGRectMake(10, 210, 300, cellInfoSize.height+10);
//    cell.center = CGPointMake(160, 200);
    [cell.contentView addSubview:label];

    [self.view addSubview:cell];
    
}

#pragma mark - 按钮事件
-(void)clickCancelButton{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_textView resignFirstResponder];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)clickSureButton{
    [self repeatTweet];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textview的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    if (0 != textView.text.length) {
        [_label setText:@""];
    }else {
        [_label setText:@"不想说点什么吗..."];
    }
}

#pragma mark - 单击空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.6 animations:^{
        [self.textView resignFirstResponder];
    }];
}

#pragma mark - 转发微博
-(void)repeatTweet{
    self.textViewInfo = self.textView.text;
    CZSOauchData *data = [CZSDataTools oauchData];
    NSString *userId = [self.delegate achieveUserRetweetId];
    NSDictionary *dic = @{
                          @"access_token" : data.access_token,
                          @"id" : userId,
                          @"status" : self.textViewInfo
                          };
    [CZSNetworkRequest networkRequestPOST:RETWEET dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"网络不是很好！");
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (200 == httpResponse.statusCode) {
//            调用block
            NSLog(@"blockName;%@",self.blockName);
            self.blockName(YES);
            NSLog(@"转发成功!!");
//            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"data:%@",jsonDic);
        }else {
            NSLog(@"error:%@",error.localizedDescription);
        }
        [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        } completion:nil];

    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
