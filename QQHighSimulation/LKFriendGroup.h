//
//  LKFriendGroup.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  好友组
 */
@interface LKFriendGroup : NSObject

/**
 *  组名
 */
@property (nonatomic, copy) NSString * name;

/**
 *  在线人数
 */
@property (nonatomic, copy) NSString * online;

/**
 *  小组下的好友
 */
@property (nonatomic, strong) NSArray * friends;

/**
 *  是否展开
 */
@property (nonatomic, assign) BOOL isopend;

/**
 *  好友组初始化
 *
 *  @param dictionary 数据model
 *
 *  @return 好友组对象
 */
- (instancetype)initWithGroupDic:(NSDictionary *)dictionary;
+ (instancetype)friendGroupWithDic:(NSDictionary *)dictionary;

@end
