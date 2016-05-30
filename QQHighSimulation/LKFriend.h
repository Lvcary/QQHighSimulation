//
//  LKFriend.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKFriend : NSObject
/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  简介
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString * name;

/**
 *  是否为VIP 1为是 0为不是
 */
@property (nonatomic, copy) NSString * vip;

- (instancetype)initWithFriendDictionary:(NSDictionary *)dictionary;
+ (instancetype)friendWithDictionary:(NSDictionary *)dictionary;

@end
