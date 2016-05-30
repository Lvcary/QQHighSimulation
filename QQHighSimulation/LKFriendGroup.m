//
//  LKFriendGroup.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKFriendGroup.h"
#import "LKFriend.h"
@implementation LKFriendGroup

- (instancetype)initWithGroupDic:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        _name = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        _online = [NSString stringWithFormat:@"%@",dictionary[@"online"]];
        
        NSArray * friendArray = [NSArray arrayWithArray:dictionary[@"friends"]];
        
    
        if (friendArray.count > 0) {
            NSMutableArray * friends = [[NSMutableArray alloc] init];
            for (NSDictionary * friendDic in friendArray) {
                [friends addObject:[LKFriend friendWithDictionary:friendDic]];
            }
            _friends = [NSArray arrayWithArray:friends];
        }
    }
    return self;
}
+ (instancetype)friendGroupWithDic:(NSDictionary *)dictionary {
    return [[self alloc] initWithGroupDic:dictionary];
}


- (NSArray *)friends {
    if (!_friends ) {
        _friends = [NSArray array];
    }
    return _friends;
}

@end
