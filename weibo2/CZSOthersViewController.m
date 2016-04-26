//
//  CZSOthersViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSOthersViewController.h"
#import "CZSDataTools.h"
#import "CZSOauchData.h"
#import "CZSNetworkRequest.h"

#define SEND_URL @"https://api.weibo.com/2/statuses/update.json"

@interface CZSOthersViewController ()

@end

@implementation CZSOthersViewController{
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

#pragma mark - 配置控制器
-(void)setupInterface{
    self.navigationItem.title = @"发布微博";
//    左按钮
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(clickCancelButton)
         forControlEvents:UIControlEventTouchUpInside];
    leftButton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
//    右按钮
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    添加textviewx
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, 320, 200)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.textColor = [UIColor redColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.center = CGPointMake(160, 100);
    [_textView becomeFirstResponder];
    _textView.backgroundColor = [UIColor colorWithRed:0.86 green:0.76 blue:0.75 alpha:1];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _label.text = @"请输入要发表的微博信息...";
    _label.enabled = NO;
    _label.center = CGPointMake(163, 16);
    [_textView addSubview:_label];
    _textView.delegate = self;

    [self.view addSubview:_textView];
}

#pragma mark - textView的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    if (0 == textView.text.length) {
        _label.text = @"请输入要发表的微博信息...";
    }else {
        _label.text = @"";
    }
}

#pragma mark - button事件
-(void)clickCancelButton{
    [self.textView resignFirstResponder];
    self.view.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickSureButton{
    NSLog(@"11111");
    [self sendTweet];
}

#pragma mark - 点击空白处键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.6 animations:^{
        [self.textView resignFirstResponder];
    }];
}

#pragma mark - 发微博
-(void)sendTweet{
    self.textViewInfo = self.textView.text;
    if (0 != self.textViewInfo.length) {
        CZSOauchData *data = [CZSDataTools oauchData];

        NSDictionary *dic = @{
                              @"access_token" : data.access_token,
                              @"status" : self.textViewInfo
                              };
        [CZSNetworkRequest networkRequestPOST:SEND_URL dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode) {
                NSLog(@"发布微博成功！！！");
//                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"data:%@",jsonDic);
            }else {
                NSLog(@"error:%@",error.localizedDescription);
            }
            [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            } completion:nil];
        }];
    }else {
        NSLog(@"发布内容不可为空");
    }
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
