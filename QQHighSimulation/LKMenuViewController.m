//
//  LKMenuViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKMenuViewController.h"

@interface LKMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * menuTableView;  ///< tableview

@end

@implementation LKMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.menuTableView];
    
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, LKScreenWith * 0.75, LKScreenHeight - 20) style:UITableViewStylePlain];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.tableFooterView = [UIView new];
    }
    return _menuTableView;
}

#pragma mark   *******tableViewDelegate****
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * indefiter = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefiter];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefiter];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section = %ld,row = %ld",indexPath.section,indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(menuSelectIndexPath:)]) {
        [self.delegate menuSelectIndexPath:indexPath];
    }
    
}

@end
