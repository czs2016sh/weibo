//
//  CZSViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/7.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSViewController.h"
#import "CZSOauchData.h"
#import "CZSDataTools.h"
#import "CZSTableViewController.h"
#import "CZSMainTabBarController.h"

#define kAPP_KEY @"1446500734"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"
#define kRedirectURI1 @"https://api.weibo.com/oauth2/authorize"
#define kAPP_SECRET @"9990265305272982e2e007938d6f5f60"
#define kGRANT_TYPE @"authorization_code"

@interface CZSViewController ()

@end

@implementation CZSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",kRedirectURI1,kAPP_KEY,kRedirectURI];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
//    创建链接
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    加载请求,网上说是在加载本地文件，这个应该不是本地的吧
    [self.userWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理方法

//webview开始请求时调用
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];

}

//webview请求完毕时调用
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];

}

//加载失败时打印错误信息
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"-----error:%@",error.localizedDescription);
    [self.activityIndicator stopAnimating];

}

//当webview发送一个请求前，都会调用该方法，询问代理是否加载该页面，所以这个方法是主要的方法
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//  1.请求的URL路径：https://api.weibo.com/oauth2/default.html?code=63446eb37671b9ad40106d63bcf46c02，可见是有redirect（转寄）和code来组成，这个code就是发送请求后返回的，它在哪儿呢？？？？显然在absolutestring中了
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"code:%@",urlString);
    
//    2.查找“code＝”在URLstring中的位置。而打印却发现其中并没有这个字符串,而是上面的rul字符串
    NSRange range = [urlString rangeOfString:@"code="];
    
//    3.如果urlstring中包含code＝这个字符串
    if (range.length) {
//        4.截取code＝后面的请求标记（经过用户授权成功的）
        int loc = range.location + range.length;
        NSString *code = [urlString substringFromIndex:loc];
        
//        5.向新浪的认证服务器发送请求，使用code换取一个access token
//        这个方法没有
        [self accessTokenWithCode:code];
        
//        6.有的话就不加载该界面
        return NO;
    }
    
    return YES;

}


-(void)accessTokenWithCode:(NSString *)code{
    // 1.封装请求参数
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"client_id"] = SQAppKey;
    //    params[@"client_secret"] = SQAppSecret;
    //    params[@"grant_type"] = @"authorization_code";
    //    params[@"code"] = code;
    //    params[@"redirect_uri"] = SQRedirectURI;
//    要求使用POST方式
    NSString *urlStr = @"https://api.weibo.com/oauth2/access_token";
    NSLog(@"code:***%@",code);
    NSString *httpBody = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&code=%@&redirect_uri=%@",kAPP_KEY, kAPP_SECRET,kGRANT_TYPE,code,kRedirectURI];
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    创建url
    NSURL *url = [NSURL URLWithString:urlStr];
//    创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSData dataWithBytes:httpBody.UTF8String length:httpBody.length];
//    创建会话
    NSURLSession *session= [NSURLSession sharedSession];
//    创建mask
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"task------");
//        转换为Json文件
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonDictionary);
        
        CZSOauchData *oauchData = [CZSOauchData dataWithDictionary:jsonDictionary];
        NSLog(@"111111111");
//        保存
        [CZSDataTools saveData:oauchData];
        NSLog(@"tiao zhuan");
//        跳转到视图控制器
        [UIApplication sharedApplication].keyWindow.rootViewController = [[CZSMainTabBarController alloc] init];
        NSLog(@"save***");
    }];
    
    
    [task resume];
    
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
