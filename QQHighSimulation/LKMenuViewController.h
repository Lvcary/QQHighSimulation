//
//  LKMenuViewController.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/25.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKBaseViewController.h"

@protocol MenuIndexPathSelectDelegate;

@interface LKMenuViewController : LKBaseViewController

@property (nonatomic, assign)id<MenuIndexPathSelectDelegate>delegate;

@end


@protocol MenuIndexPathSelectDelegate <NSObject>

- (void)menuSelectIndexPath:(NSIndexPath *)indexPath;

@end