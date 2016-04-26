//
//  CZSCommentListsTableViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSCommentListsTableViewController.h"
#import "CZSOauchData.h"
#import "CZSDataTools.h"
#import "CZSNetworkRequest.h"
#import "CZSCommentListsTableViewCell.h"

#define SHOW_COMMENT @"https://api.weibo.com/2/comments/show.json"

@interface CZSCommentListsTableViewController ()

@end

@implementation CZSCommentListsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self dataArray];
    [self showCommentLites];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArray{
//    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
//    }
    return _dataArray;
}

#pragma mark - 网络请求
-(void)showCommentLites{
    CZSOauchData *data = [CZSDataTools oauchData];
    NSDictionary *dic = @{
                          @"access_token" : data.access_token,
                          @"id" : self.userId
                          };
    [CZSNetworkRequest networkRequestGET:SHOW_COMMENT dic:dic completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error.code == NSURLErrorTimedOut) {
            NSLog(@"网络不是很好！");
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (200 == httpResponse.statusCode) {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *comments = [jsonDic valueForKey:@"comments"];
            for (NSDictionary *tempDic in comments) {
               NSString *text = [tempDic valueForKey:@"text"];
                [_dataArray addObject:text];
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_sync(mainQueue, ^{
                    [self.tableView reloadData];
                });
            }
        }else {
            NSLog(@"error:%@",error.localizedDescription);
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
    NSLog(@"%d",_dataArray.count);
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CZSCommentListsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"czs"];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CZSCommentListsTableViewCell" owner:self options:nil] lastObject];
    }
    // Configure the cell...
    cell.textLbel.numberOfLines = 0;
    cell.textLbel.font = [UIFont systemFontOfSize:14];
    cell.textLbel.text = _dataArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


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
