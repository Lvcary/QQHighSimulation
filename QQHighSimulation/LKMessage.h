//
//  LKMessage.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/30.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LKMessageTYpeMe = 0,  // 自己发的
    LKMessageTypeOther    // 别人发的
    
}LKMessageType;;

@interface LKMessage : NSObject
/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  发送时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  信息的类型
 */
@property (nonatomic, assign) LKMessageType type;

/**
 *  是否隐藏时间
 */
@property (nonatomic, assign) BOOL hideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
