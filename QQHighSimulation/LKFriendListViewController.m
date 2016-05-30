//
//  LKFriendListViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKFriendListViewController.h"
#import "LKFriendGroup.h"
#import "LKFriend.h"
#import "LKFriendHeadView.h"
#import "ODRefreshControl.h"
@interface LKFriendListViewController ()<UITableViewDelegate,UITableViewDataSource,LkHeaderViewDelegate>

@property (nonatomic, strong)UITableView *friendTableView;  ///< tableview
@property (nonatomic, strong)NSMutableArray *dataSource;  ///< 数据源

@property (nonatomic, strong) ODRefreshControl * refreshControl; ///< 下拉刷新控件
@end

@implementation LKFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.friendTableView];
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.friendTableView];
    [_refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    
    _dataSource = [[NSMutableArray alloc] init];
    NSArray * friends = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"]];
    if (friends.count > 0) {
        for (NSDictionary * dic in friends) {
            [_dataSource addObject:[LKFriendGroup friendGroupWithDic:dic]];
        }
    }
}

#pragma Mark *****懒加载*****
- (UITableView *)friendTableView {
    if (!_friendTableView) {
        _friendTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 49) style:UITableViewStylePlain];
        _friendTableView.dataSource = self;
        _friendTableView.delegate = self;
        // 每一行cell的高度
        _friendTableView.rowHeight = 50;
        // 每一组头部控件的高度
        _friendTableView.sectionHeaderHeight = 44;
        _friendTableView.tableFooterView = [UIView new];
    }
    return _friendTableView;
}

#pragma mark *******refreshControlAction*****
- (void)refreshControlAction:(ODRefreshControl *)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refresh endRefreshing];
    });
}

#pragma mark  ****tableViewDelegate*****
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[_dataSource objectAtIndex:section] isopend]) {
        return [[[_dataSource objectAtIndex:section] friends] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *friend = @"friend";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friend];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friend];
    }
    
    LKFriendGroup * group = [self.dataSource objectAtIndex:indexPath.section];
    LKFriend * friendInfo = [group.friends objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:friendInfo.icon];
    cell.textLabel.text = friendInfo.name;
    cell.textLabel.textColor = [friendInfo.vip isEqualToString:@"1"] ? [UIColor redColor] : [UIColor blackColor];
    cell.detailTextLabel.text = friendInfo.intro;
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 1.创建头部控件
    LKFriendHeadView *header = [LKFriendHeadView headerViewWithTableView:tableView];
    header.delegate = self;
    
    // 2.给header设置数据(给header传递模型)
    header.group = self.dataSource[section];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - headerView的代理方法
/**
 *  点击了headerView上面的名字按钮时就会调用
 */
- (void)headerViewDidClickedNameView:(LKFriendHeadView *)headerView
{
    [_friendTableView reloadData];
}

@end
