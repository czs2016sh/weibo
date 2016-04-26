//
//  CZSCommentViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSCommentViewController.h"
#import "CZSDataTools.h"
#import "CZSOauchData.h"
#import "CZSNetworkRequest.h"
#import "CZSCommentListsTableViewController.h"

#define COMMENT @"https://api.weibo.com/2/comments/create.json"
#define SHOWCOMENT @"https://api.weibo.com/2/comments/show.json"

@interface CZSCommentViewController ()

@end

@implementation CZSCommentViewController{
    UILabel *_label;
    UIToolbar *_toolbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInterface];
    [self setupKVO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 配置界面
-(void)setupInterface{
    self.navigationItem.title = @"发表评论";
    UIButton *leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self
                   action:@selector(clickCancelButton)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(clickSureButton)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    //    添加textview
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.textColor = [UIColor redColor];
    [_textView setBackgroundColor:[UIColor grayColor]];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.center = CGPointMake(160, 100);
    _textView.backgroundColor = [UIColor colorWithRed:0.86 green:0.76 blue:0.75 alpha:1];
    [_textView becomeFirstResponder];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _label.center = CGPointMake(163, 16);
    [_label setText:@"请输入评论内容..."];
    _label.enabled = NO;
    [_textView addSubview:_label];
    _textView.delegate = self;
    
    [self.view addSubview:_textView];
//    添加toolbar
    _toolbar = [[UIToolbar alloc]init];
    _toolbar.frame = CGRectMake(0, 0, 320, 40);
    _toolbar.center = CGPointMake(160, 548);
//    添加按钮
    UIButton *showConmmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [showConmmentButton setTitle:@"查询回复列表" forState:UIControlStateNormal];
    showConmmentButton.frame = CGRectMake(0, 0, 150, 30);
    [showConmmentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *showButt = [[UIBarButtonItem alloc]initWithCustomView:showConmmentButton];
    showButt.image = [UIImage imageNamed:@"navigationbar_button_background"];
    NSArray *tempArray = [NSArray array];
    NSArray *array = [tempArray arrayByAddingObject:showButt];
    [_toolbar setItems:array];
    [showConmmentButton addTarget:self action:@selector(clickShowCommentButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_toolbar];
}

#pragma mark - textview的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    if (0 != textView.text.length) {
        [_label setText:@""];
    }else {
        [_label setText:@"请输入评论内容..."];
    }
}

#pragma mark - 为button添加事件
-(void)clickCancelButton{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_textView resignFirstResponder];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
}

-(void)clickSureButton{
    
    [self commentTweet];
}

-(void)clickShowCommentButton{
    
    CZSCommentListsTableViewController *tableVC = [[CZSCommentListsTableViewController alloc]init];
    tableVC.userId = [self.delegate achieveUserCommentId];;
    [self.navigationController pushViewController:tableVC animated:YES];
}

#pragma mark - 点击空白处键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        [self.textView resignFirstResponder];
    }];
}

#pragma mark - 工具栏随键盘自动上升,通过KVO监听键盘的动作，这个在信息中心会有记录，所以它是非常简单的监听，不需要自己去设置监听对象和取消监听，只有监听的过程
-(void)setupKVO{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    // Register notification when the keyboard will be show
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    CGSize keyb = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint toolbarCenter = _toolbar.center;
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.center = CGPointMake(toolbarCenter.x, toolbarCenter.y - keyb.height);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    
    _toolbar.center = CGPointMake(160, 548);
}

#pragma mark - 发布评论
-(void)commentTweet{
    self.textViewInfo = self.textView.text;
    if (0 != self.textViewInfo.length) {
        CZSOauchData *data = [CZSDataTools oauchData];
        NSString *userId = [self.delegate achieveUserCommentId];
        NSDictionary *dic = @{
                              @"access_token" : data.access_token,
                              @"id" : userId,
                              @"comment" : self.textViewInfo
                              };
        [CZSNetworkRequest networkRequestPOST:COMMENT dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error.code == NSURLErrorTimedOut) {
                NSLog(@"网络不是很好！");
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (200 == httpResponse.statusCode) {
//                调用block
                self.blockName(YES);
                NSLog(@"评论成功");
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
        NSLog(@"评论内容不可为空！");
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
