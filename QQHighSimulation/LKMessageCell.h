//
//  LKMessageCell.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/30.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKMessagFrame;

@interface LKMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) LKMessagFrame *messageFrame;

@end
