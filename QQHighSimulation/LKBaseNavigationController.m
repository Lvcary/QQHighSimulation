//
//  LKBaseNavigationController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKBaseNavigationController.h"

@implementation LKBaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithRed:0 green:122.0 / 255 blue:1.0 alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    // 设置navigationBar上的字体为白色
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
}

@end
