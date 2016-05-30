//
//  LKFriend.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKFriend.h"

@implementation LKFriend

- (instancetype)initWithFriendDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _name = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        _intro = [NSString stringWithFormat:@"%@",dictionary[@"intro"]];
        _icon = [NSString stringWithFormat:@"%@",dictionary[@"icon"]];
        _vip = [NSString stringWithFormat:@"%@",dictionary[@"vip"]];
    }
    return self;
}
+ (instancetype)friendWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithFriendDictionary:dictionary];
}

@end
