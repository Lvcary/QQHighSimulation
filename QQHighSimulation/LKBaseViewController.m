//
//  LKBaseViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKBaseViewController.h"

@interface LKBaseViewController ()

@property (nonatomic, strong) NSArray * viewControllArrar;  ///< 主控制器名称



@end

@implementation LKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIViewController * topViewController = self.navigationController.topViewController;
    NSString * className = NSStringFromClass([topViewController class]);
    
    if ([self.viewControllArrar containsObject:className]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    }
    
}

- (NSArray *)viewControllArrar {
    if (!_viewControllArrar) {
        _viewControllArrar = [NSArray arrayWithObjects:@"LKHomeViewController",@"LKFriendListViewController", nil];
    }
    return _viewControllArrar;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, 0, 33, 33);
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 16.5;
        [_leftBtn setImage:[UIImage imageNamed:@"me"] forState:0];
        [self.leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (void)leftBtnAction:(UIButton *)sender {
    NSLog(@"222");
    [[NSNotificationCenter defaultCenter] postNotificationName:LEFTHEADTAPPOST object:nil];
}


@end
