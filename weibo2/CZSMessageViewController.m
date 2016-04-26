//
//  CZSMessageViewController.m
//  weibo2
//
//  Created by sq-ios53 on 16/3/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "CZSMessageViewController.h"

@interface CZSMessageViewController ()

@end

@implementation CZSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 简单设置一下各个cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        UIViewController *viewController = [[UIViewController alloc]init];
        viewController.view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.center = viewController.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [label setText:[NSString stringWithFormat:@"第%d行被选中了！！",indexPath.row+1]];
    [viewController.view addSubview:label];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - searchBar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"searchBarSearchButtonClicked");
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"textDidChange");
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
