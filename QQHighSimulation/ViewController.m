//
//  ViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "ViewController.h"
#import "LKMenuViewController.h"
#import "LKHomeViewController.h"
#import "LKFriendListViewController.h"
#import "MenuDetailViewController.h"

#import "LKBaseNavigationController.h"

static const CGFloat homeEndDistanceLeft = 0.75;  ///< 菜单栏展开后消息距离左边的距离比例
static const CGFloat menuStartratio = 0.7;  ///< 菜单栏缩放的比例
static const CGFloat homeEndTratio = 0.8;  ///< 菜单栏展开后 消息的缩放比例

@interface ViewController ()<MenuIndexPathSelectDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) LKMenuViewController *menuViewController;  ///< 左侧菜单栏

@property (nonatomic, strong) LKHomeViewController * home;  ///< 消息
@property (nonatomic, strong) LKFriendListViewController *friend;  ///<联系人

@property (nonatomic, assign) CGFloat menuCenterStart; ///< 初始时菜单界面的中心位置
@property (nonatomic, assign) CGFloat menuCenterEnd;  ///< 菜单打开后的中心位置
@property (nonatomic, assign) CGFloat distanceLeft;  ///< tabbar距离左边的边距
@property (nonatomic, assign) CGFloat touchPointX;  ///<手势开始时的位置

@property (nonatomic, assign, getter=isMenuOpend) BOOL menuIsOpend;  ///< 菜单栏是否展开

@property (nonatomic, strong) UITabBarController * tabbarCotroller;

@property (nonatomic, strong) UITapGestureRecognizer *tabbarViewtap;  ///< tabbarView上的点击手势

@property (nonatomic, strong) UIButton *leftHeadBtn;  ///< 头像按钮

@property (nonatomic, strong) UIView * coverTabBarView; ///< 展开后在此view添加点击手势
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuCenterStart = LKScreenWith * menuStartratio * 0.5;
    _menuCenterEnd = LKScreenWith * 0.5;
    _distanceLeft = 0;
    
    // 背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"back"];
    [self.view addSubview:backImageView];
    
    // menu
    self.menuViewController = [[LKMenuViewController alloc] init];
    self.menuViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartratio, menuStartratio);
    self.menuViewController.view.center = CGPointMake(_menuCenterStart, self.menuViewController.view.center.y);
    self.menuViewController.delegate = self;
    [self.view addSubview:self.menuViewController.view];

    // home and friend
    _home = [[LKHomeViewController alloc] init];
    LKBaseNavigationController *homeNavi = [[LKBaseNavigationController alloc] initWithRootViewController:_home];
    homeNavi.tabBarItem.title = @"消息";
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"tab_recent_nor"];
    
    _friend = [[LKFriendListViewController alloc] init];
    LKBaseNavigationController * friendNavi = [[LKBaseNavigationController alloc] initWithRootViewController:_friend];
    friendNavi.tabBarItem.title = @"联系人";
    friendNavi.tabBarItem.image = [UIImage imageNamed:@"tab_buddy_nor"];
    
    // tabbar
    self.tabbarCotroller = [[UITabBarController alloc] init];
    self.tabbarCotroller.viewControllers = [NSArray arrayWithObjects:homeNavi,friendNavi, nil];
    [self.view addSubview:self.tabbarCotroller.view];
    
    // panGesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    pan.delegate = self;
    [self.tabbarCotroller.view addGestureRecognizer:pan];
    
    // tapGesture
    _tabbarViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    _coverTabBarView = [[UIView alloc] init];
    _coverTabBarView.hidden = YES;
    [_coverTabBarView addGestureRecognizer:_tabbarViewtap];
    [self.tabbarCotroller.view addSubview:_coverTabBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recivedInfo)
                                                 name:LEFTHEADTAPPOST object:nil];

}

/// 设置statusBar的状态
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIButton *)leftHeadBtn {
    
    LKBaseNavigationController * lkBaseNavi = (LKBaseNavigationController *)self.tabbarCotroller.selectedViewController;
    if (lkBaseNavi.viewControllers.count == 1) {
        if ([[lkBaseNavi.viewControllers lastObject] isKindOfClass:[LKHomeViewController class]]) {
            
            _leftHeadBtn = _home.leftBtn;
        }else if ([[lkBaseNavi.viewControllers lastObject] isKindOfClass:[LKFriendListViewController class]]) {
            
            _leftHeadBtn = _friend.leftBtn;
        }
    }
    return _leftHeadBtn;
}

#pragma mark  ******手势代理******
/*
    获取当前navigationController 判断栈顶的viewcontroller是否在数组里 在就返回YES 不在返回NO
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSArray *controllerArray = [NSArray arrayWithObjects:@"LKHomeViewController",@"LKFriendListViewController", nil];
    LKBaseNavigationController * lkBaseNavi = (LKBaseNavigationController *)self.tabbarCotroller.selectedViewController;
    if (lkBaseNavi.viewControllers > 0) {
        NSString * controllerName = NSStringFromClass([[lkBaseNavi.viewControllers lastObject] class]);
        if ([controllerArray containsObject:controllerName]) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark  *******panGestureAction******
- (void)panGestureAction:(UIPanGestureRecognizer *)sender {
    
    // 手势开始
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.touchPointX = [sender locationInView:self.view].x;
    }
    
    if (self.touchPointX > 65 && self.menuIsOpend == NO) {
        return;
    }
    
    // 手势拖动的距离
    CGFloat x = [sender translationInView:self.view].x;
    // 手势进行中
    if(sender.state == UIGestureRecognizerStateChanged) {
    
        // 菜单栏没打开时 向左滑动无效
        if (!self.isMenuOpend && x < 0) {
            return;
        }
        
        
        // tabbar距离左边距的距离
        CGFloat tabbarDis = _distanceLeft + x;
        if (tabbarDis > LKScreenWith * homeEndDistanceLeft || tabbarDis < 0) {
            return;
        }
        
        CGFloat alpha = tabbarDis/LKScreenWith/homeEndDistanceLeft;
        self.leftHeadBtn.alpha = 1 - alpha;
        
        // tabbar的缩放比例
        CGFloat tabbarTratio = (homeEndTratio - 1)/homeEndDistanceLeft * (tabbarDis/LKScreenWith) + 1;
        // tabbar的中心位置
        CGFloat tabbarCenter = tabbarDis + tabbarTratio * LKScreenWith/2;
        
        self.tabbarCotroller.view.center = CGPointMake(tabbarCenter, self.view.center.y);
        self.tabbarCotroller.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, tabbarTratio, tabbarTratio);

        // menu的缩放比例
        CGFloat menuTratio = (1 - menuStartratio)/homeEndDistanceLeft * tabbarDis/LKScreenWith + menuStartratio;
        // menu的中心位置
        CGFloat menuCenter = LKScreenWith * menuTratio/2;
        self.menuViewController.view.center = CGPointMake(menuCenter, self.view.center.y);
        self.menuViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuTratio , menuTratio);
    }
    // 手势结束或取消
    else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        // tabbar距离左边距的距离
        CGFloat tabbarDis = _distanceLeft + x;
        if (tabbarDis > self.view.center.x) {
            [self openOrCloseMenu:YES];
        }else {
            [self openOrCloseMenu:NO];
        }
    }
}

#pragma mark ******tapDelegate*****
- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self openOrCloseMenu:NO];
}

- (void)recivedInfo {
    [self openOrCloseMenu:YES];
}

#pragma mark  ********手动展开或关闭菜单栏*******
- (void)openOrCloseMenu:(BOOL)isOpen {
    self.menuIsOpend = isOpen;
    
    if (isOpen) {
        // 展开menu
        _distanceLeft = LKScreenWith * homeEndDistanceLeft;
        [self setCoverViewHidden:NO];
        self.leftHeadBtn.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.tabbarCotroller.view.center = CGPointMake(homeEndTratio*0.5*LKScreenWith+LKScreenWith * homeEndDistanceLeft, self.view.center.y);
            self.tabbarCotroller.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, homeEndTratio, homeEndTratio);
            
            self.menuViewController.view.center = CGPointMake(LKScreenWith/2, self.view.center.y);
            self.menuViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 , 1);
        }];
    }else {
        // 关闭meni
        _distanceLeft = 0;
        [self setCoverViewHidden:YES];
        self.leftHeadBtn.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            self.tabbarCotroller.view.center = CGPointMake(LKScreenWith*0.5, self.view.center.y);
            self.tabbarCotroller.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            
            self.menuViewController.view.center = CGPointMake(LKScreenWith * menuStartratio * 0.5, self.view.center.y);
            self.menuViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartratio , menuStartratio);
        }];
    }
    
}

- (void)setCoverViewHidden:(BOOL)isHidden {
    _coverTabBarView.hidden = isHidden;
    if (!isHidden) {
        _coverTabBarView.frame = self.tabbarCotroller.view.bounds;
    }
}

#pragma mark ********菜单栏点击代理********
- (void)menuSelectIndexPath:(NSIndexPath *)indexPath {
//    id class = NSClassFromString(@"MenuDetailViewController");
//    class = [[UIViewController alloc] init];
//    [self.tabbarCotroller.selectedViewController.navigationController pushViewController:class animated:YES];
    [self openOrCloseMenu:NO];
    
    MenuDetailViewController *menuDetail = [[MenuDetailViewController alloc] init];
    menuDetail.title = [NSString stringWithFormat:@"row = %ld",indexPath.row];
    menuDetail.hidesBottomBarWhenPushed = YES;
    [self.tabbarCotroller.selectedViewController pushViewController:menuDetail animated:NO];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
