//
//  CZSTableViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/8.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSTableViewController.h"
#import "CZSData.h"
#import "CZSTableViewCell.h"
#import "CZSOauchData.h"
#import "CZSDataTools.h"
#import "CZSMainNavigationViewController.h"
#import "CZSNetworkRequest.h"
#import "CZSCommentListsTableViewCell.h"

#define PUBLIC_URL @"https://api.weibo.com/2/statuses/public_timeline.json"
#define FRIENDS_URL @"https://api.weibo.com/2/statuses/friends_timeline.json"
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IMAGE_NUM 9

@interface CZSTableViewController ()

@end

@implementation CZSTableViewController{
    UIView *_footerView;
    UIButton *_footerButton;
    UIView *_waitView;
    UIRefreshControl *_refresh;
    NSTimer *_timer;
    CZSData *_data;
    int _like_count;
}



- (void)viewDidLoad {
    NSLog(@"navigationController:::::%@",self.navigationController);
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self waitInterface];
    [self setupNavigationBar];
    [self dataArray];
    [self achieveData];
    [self tableViewCellHeight];
    [self pullDownRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 新版本或新功能的模仿导航视图
- (void)navigationView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.contentSize = CGSizeMake(IMAGE_NUM * IPHONE_WIDTH, IPHONE_HEIGHT);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    for (int i = 0 ; i < IMAGE_NUM; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
        imageView.frame=CGRectMake(i*IPHONE_WIDTH, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
        [self.scrollView addSubview:imageView];
    }
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.pageControl.center = CGPointMake(160, 400);
    self.pageControl.numberOfPages = IMAGE_NUM;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    
    [self.tableView addSubview:self.scrollView];
    [self.tableView addSubview:self.pageControl];
    
}

#pragma mark - scrollView delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (IMAGE_NUM == self.pageControl.currentPage + 1) {
        [self.scrollView removeFromSuperview];
        [self.pageControl removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.pageControl.currentPage = self.scrollView.contentOffset.x/IPHONE_WIDTH + 1;
}


#pragma mark - 等待视图
-(void)waitInterface{
    _waitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    _refresh = [[UIRefreshControl alloc]init];
    _refresh.attributedTitle = [[NSAttributedString alloc]initWithString: @"海贼们已经帮您努力加载了..."];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    imgView.center = CGPointMake(160, 100);
    imgView.layer.cornerRadius = 100/2;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"7"];
    [_waitView addSubview:imgView];
    
    [self.view insertSubview:_waitView aboveSubview:self.tableView];
    [self.view insertSubview:_refresh aboveSubview:_waitView];
    [_refresh beginRefreshing];
    
//    设计一个定时器
    _timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(timerOut:) userInfo:nil repeats:YES];
}

-(void)timerOut:(NSTimer *)timer{
    NSLog(@"已经过去半分钟了，超时不候！！！");
}


#pragma mark - 每次都不成功的懒加载,记得调用的时候必须使用self.的形式去调用才行
-(NSMutableArray *)dataArray{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 配置navigation bar的两个按钮
-(void)setupNavigationBar{
//    左侧按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_friendsearch"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] forState:UIControlStateHighlighted];
    leftButton.frame = (CGRect){CGPointZero,leftButton.currentBackgroundImage.size};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
//    右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"radar_card_guide_hot-1"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] forState:UIControlStateHighlighted];
    rightButton.frame = (CGRect){CGPointZero,rightButton.currentBackgroundImage.size};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
//    还有中间图标，不知道长啥样。。。。
    
}

-(void)pullDownRefresh{
//    [self.refreshControl beginRefreshing];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(targetPullDownRefresh) forControlEvents:UIControlEventValueChanged];
}

-(void)targetPullDownRefresh{
//    请求新数据
    if (self.refreshControl.isRefreshing) {
        [self achieveNewData];
    }else {
        [self.refreshControl beginRefreshing];
        [self achieveData];
    }
}

#pragma mark - 弹出新信息的数量
-(void)popWindow:(int)count flag:(BOOL)flag{
    NSLog(@"dan chuang");
    
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    userView.center = CGPointMake(160, -20);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.backgroundColor = [UIColor greenColor];
    if (0 == count) {
        [label setText:[NSString stringWithFormat:@"没有得到新信息"]];
    }else {
        [label setText:[NSString stringWithFormat:@"新得到%d条信息",count]];
    }
    [label setTextAlignment:NSTextAlignmentCenter];
    [userView addSubview:label];
    userView.backgroundColor = [UIColor redColor];
    
    [self.navigationController.view insertSubview:userView belowSubview:self.navigationController.navigationBar];

//    动画进行显现和消除
    [UIView animateWithDuration:0.8 animations:^{
        userView.center =CGPointMake(160, 80);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 delay:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            userView.center = CGPointMake(160, -20);
        } completion:^(BOOL finished) {
            [userView removeFromSuperview];
        }];
    }];
//            定位到第几行
    if (flag) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

}

#pragma mark - 设置cell行高
-(void)tableViewCellHeight{
//    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _footerButton.frame = CGRectMake(0, 0, 320, 40);
//    [_footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
//    _footerButton.backgroundColor = [UIColor redColor];
    
//    这一行代码很有意思，不是所有view都需要加载子视图，下面这个是个属性，可以直接复制，而且用加载子视图的方式并不能够显示出来，可能是因为这个属性默认不显示
//    self.tableView.tableFooterView = _footerButton;

//    [self.tableView.tableFooterView addSubview:_footerButton];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 获取新信息
-(void)achieveNewData{
    CZSOauchData *data = [CZSDataTools oauchData];
    NSDictionary *dic = @{
                          @"access_token" : data.access_token,
                          @"count":@"5"
                          };
    [CZSNetworkRequest networkRequestGET:FRIENDS_URL dic: dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (200 == httpResponse.statusCode) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //停止刷新画画
            [self.refreshControl endRefreshing];
            //他的个数作为参数传递出去
            NSArray *newArray = [self jsonModel:jsonDic];
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:newArray];
            [tempArray addObjectsFromArray:_dataArray];
            _dataArray = tempArray;
            //      刷新页面,注意要在主线程中执行
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            //        同步方式添加进主线程
            dispatch_sync(mainQueue, ^{
                [self.tableView reloadData];
                // 刷新页面的同时进行弹框，提示收到的新信息数
                NSLog(@"shua xin");
                [self popWindow:newArray.count flag:YES];
            });
        }else {
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - 首次获取信息
-(void)achieveData{
//    get方式,参数要求为access_token
    CZSOauchData *oauchData = [CZSDataTools oauchData];
    NSDictionary *dic = @{
                         @"access_token" : oauchData.access_token
                          };
    [CZSNetworkRequest networkRequestGET:FRIENDS_URL dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"网络不是很好啊！！！");
        }
        NSHTTPURLResponse *httpRsponse = (NSHTTPURLResponse *)response;
        if (200 == httpRsponse.statusCode) {
            [_refresh endRefreshing];
            _refresh.hidden = YES;
            [_refresh removeFromSuperview];
            [_waitView removeFromSuperview];
            //            停止定时器
            [_timer invalidate];
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *newArray = [self jsonModel:jsonDic];
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:newArray];
            [tempArray addObjectsFromArray:_dataArray];
            _dataArray = tempArray;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
//                重新加载之前要把头像换成默认的头像，而不是别人的头像，不然会导致头像的跳转，用户体验会很差的
                [self navigationView];

                [self.tableView reloadData];
            });
        }else {
            NSLog(@"statusCode:%d",httpRsponse.statusCode);
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

#pragma mark - json转模型
-(NSMutableArray *)jsonModel:(NSDictionary *)jsonDic{
    //取一层
    NSArray *statuses = [jsonDic valueForKey:@"statuses"];
    NSMutableArray *newArray = [NSMutableArray array];
//    NSLog(@"%@",statuses);
    
    for (NSDictionary *dic in statuses) {
        
        CZSData *data = [[CZSData alloc]init];
        data.name = [[dic valueForKey:@"user"] valueForKey:@"name"];
        data.text = [dic valueForKey:@"text"];
        data.created_at = [dic valueForKey:@"created_at"];
        data.profile_image = [[dic valueForKey:@"user"] valueForKey:@"profile_image_url"];
        data.userId  = [dic valueForKey:@"id"];
        data.reposts_count = [(NSNumber*)[dic valueForKey:@"reposts_count"] integerValue];
        data.comments_count = [(NSNumber *)[dic valueForKey:@"comments_count"] integerValue];
        data.attitudes_count = [(NSNumber *)[dic valueForKey:@"attitudes_count"] integerValue];
        data.like_count = _like_count;
        data.scourceStr = [dic valueForKey:@"source"];

        NSRange range = [data.scourceStr rangeOfString:@"\">"];
//        NSLog(@"%d,,,,%d",range.location,range.length);
        if (0 != range.length) {
            NSRange newRange = {range.location + 2, data.scourceStr.length - 4 - (range.location + 2)};
            data.scourceStr = [data.scourceStr substringWithRange:newRange];
        }else {
            NSLog(@"不包含要查找的字符!!");
        }
        [newArray addObject:data];
    }
    return newArray;
}

#pragma mark - 点击加载更多
-(void)clickFooterButton{
    [_footerButton setTitle:@"请稍等，正在为您加载中..." forState:UIControlStateNormal];
    CZSOauchData *oauchData = [CZSDataTools oauchData];
    NSDictionary *dic = @{
                          @"access_token" : oauchData.access_token,
                          @"count" : @"4"
                          };
    [CZSNetworkRequest networkRequestGET:FRIENDS_URL dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (200 == httpResponse.statusCode) {
            //            改回button上显示的文字
            [_footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
            
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *newArray = [self jsonModel:jsonDic];
            //            加到最后
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObjectsFromArray:_dataArray];
            [tempArray addObjectsFromArray:newArray];
            _dataArray =tempArray;
            
            //            获取主线程
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_sync(mainQueue, ^{

                [self.tableView reloadData];
                //               调用弹窗
                [self popWindow:newArray.count flag:NO];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 2*_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"CZSTableViewCell" owner:self options:nil];
    if (0 == indexPath.row % 2) {
        CZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"czs"];
        
        if (nil == cell) {
            cell = [array firstObject];
            
//            添加点击事件
            [cell.retWeetButton addTarget:self action:@selector(clickTimeLineRetWeetButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentButton addTarget:self action:@selector(clickTimeLinecommentButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        }
//        CZSData *data = _dataArray[indexPath.row/2];
        [cell setData:_dataArray[indexPath.row/2]];
        
        return cell;
    }else {
        CZSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"czs1"];
        if (nil == cell ) {
            cell = [array lastObject];
        }
//        显示出最下面的按钮,设定5个变动区间
        if (2*_dataArray.count-3 < (indexPath.row+1)) {
            _footerButton.alpha = 1;
            _footerView.alpha = 1;
        }
        else {
            _footerButton.alpha = 0;
            _footerView.alpha = 0;
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 != indexPath.row % 2) {
        return 4;
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footerButton.frame = CGRectMake(0, 0, 320, 40);
    [_footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    _footerButton.backgroundColor = [UIColor redColor];
    [_footerView addSubview:_footerButton];
//    设定为隐藏
    _footerButton.alpha = 0;
    _footerView.alpha = 0;
    [_footerButton addTarget:self action:@selector(clickFooterButton) forControlEvents:UIControlEventTouchUpInside];
    
    return _footerView;
}

#pragma mark - 为button添加事件

- (void)clickTimeLineRetWeetButton:(UIButton *)sender{
    CZSRetWeetViewController *retWeetVC = [[CZSRetWeetViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:retWeetVC];
//    设置代理
    retWeetVC.delegate = self;
//    第二种传值方式，属性传值,寻找父view可以找到这个cell,一共是四层
    CZSTableViewCell *cell = (CZSTableViewCell *)sender.superview.superview.superview.superview;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    _data = _dataArray[cellIndexPath.row/2];
    retWeetVC.cellInfo = _data.text;
    NSLog(@"hang:%d",cellIndexPath.row/2);
    CZSData *data = _dataArray[cellIndexPath.row/2];
    retWeetVC.blockName = ^(BOOL isSuccess){
        if (YES == isSuccess) {
            data.reposts_count ++;
            [_dataArray replaceObjectAtIndex:cellIndexPath.row/2 withObject:data];
//            [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    };
    retWeetVC.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)clickTimeLinecommentButton:(UIButton *)sender{
    CZSCommentViewController *retWeetVC = [[CZSCommentViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:retWeetVC];
    //    设置代理
    retWeetVC.delegate = self;
    //    第二种传值方式，属性传值,寻找父view可以找到这个cell
     CZSTableViewCell *cell = (CZSTableViewCell *)sender.superview.superview.superview.superview;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"hang:%d",cellIndexPath.row/2);
    _data = _dataArray[cellIndexPath.row/2];
//    block传值
    CZSData *data = _dataArray[cellIndexPath.row/2];
    retWeetVC.blockName = ^(BOOL count){
        if (YES == count) {
            data.comments_count ++;
            [_dataArray replaceObjectAtIndex:cellIndexPath.row/2 withObject:data];
//            [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    };
    retWeetVC.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)clickLikeButton:(UIButton *)sender{
    CZSTableViewCell *cell = (CZSTableViewCell *)sender.superview.superview.superview.superview;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    _like_count ++;
    CZSData *data = _dataArray[cellIndexPath.row/2];
    data.like_count = _like_count;
    if (1 == _like_count) {
        data.attitudes_count ++;
    }else if(2 == _like_count){
        data.attitudes_count --;
        _like_count = 0;
    }
    [_dataArray replaceObjectAtIndex:cellIndexPath.row/2 withObject:data];
    [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

#pragma mark - 代理传参，实现代理方法
-(NSString *)achieveUserCommentId{
    return _data.userId;
}

-(NSString *)achieveUserRetweetId{
    
    return _data.userId;
}


#pragma mark - segue传参，只有在UIStoryboard之间切换时才可以用，其它时候不能用

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSLog(@"chuancan !!!");
//    CZSRetWeetViewController *retWeetVC = segue.destinationViewController;
//    retWeetVC.userId = _data.userId;
//
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
