//
//  LKFriendHeadView.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKFriendGroup, LKFriendHeadView;

@protocol LkHeaderViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(LKFriendHeadView *)headerView;
@end

@interface LKFriendHeadView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LKFriendGroup *group;

@property (nonatomic, weak) id<LkHeaderViewDelegate> delegate;


@end
