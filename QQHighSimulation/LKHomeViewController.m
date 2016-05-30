//
//  LKHomeViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKHomeViewController.h"
#import "ODRefreshControl.h"
#import "ResultTableViewController.h"
#import "LKChatViewController.h"
@interface LKHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@property (nonatomic, weak) UITableView * messageTableView;  ///< 消息table

@property (nonatomic, strong) UISearchController * searchController;  ///< 搜索栏
@property (nonatomic, strong) ResultTableViewController * resultTabController; ///< 搜索结果

@property (nonatomic, weak) ODRefreshControl * refreshControl; ///< 下拉刷新控件

@end

@implementation LKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.definesPresentationContext = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray * segArray = [NSArray arrayWithObjects:@"消息",@"电话", nil];
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:segArray];
    segment.selectedSegmentIndex = 0;
    [segment setWidth:60 forSegmentAtIndex:0];
    [segment setWidth:60 forSegmentAtIndex:1];
    self.navigationItem.titleView = segment;
    
    // tableView
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0,64, LKScreenWith, LKScreenHeight - 64 - 49) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    _messageTableView = table;
    
    ODRefreshControl * refresh = [[ODRefreshControl alloc] initInScrollView:_messageTableView];
    [refresh addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
    _refreshControl = refresh;
    
    _messageTableView.tableHeaderView = self.searchController.searchBar;
    
}

- (UISearchController *)searchController{
    
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultTabController];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.placeholder = @"搜索";
        
    }
    return _searchController;
}

- (ResultTableViewController *)resultTabController{
    if (!_resultTabController) {
        _resultTabController = [[ResultTableViewController alloc] init];
    }
    return _resultTabController;
}

#pragma mark *******refreshControlAction*****
- (void)refreshControlAction:(ODRefreshControl *)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refresh endRefreshing];
    });
}

#pragma mark  ****tableViewDelegate*****
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * messageInter = @"message";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageInter];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageInter];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LKChatViewController * lkchatVc = [[LKChatViewController alloc] init];
    lkchatVc.title = [NSString stringWithFormat:@"row%ld",indexPath.row];
    lkchatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lkchatVc animated:YES];
    
}

#pragma mark - UISearchResultsUpdating  (which you use ,which you choose!!)
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSString *str = [NSString stringWithFormat:@"SELF Like[c]'%@*'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *arr = [[UIFont familyNames] filteredArrayUsingPredicate:predicate];
    
    
    // hand over the filtered results to our search results table
    ResultTableViewController *tableController = (ResultTableViewController *)self.searchController.searchResultsController;
    tableController.filteredModels = arr;
    [tableController.tableView reloadData];
}


@end
