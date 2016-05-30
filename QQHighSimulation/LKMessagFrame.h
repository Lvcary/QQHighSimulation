//
//  LKMessagFrame.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/30.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

// 正文的字体
#define MJTextFont [UIFont systemFontOfSize:15]

// 正文的内边距
#define MJTextPadding 20

#import <Foundation/Foundation.h>
@class LKMessage;

@interface LKMessagFrame : NSObject

/**
 *  头像的frame
 */
@property (nonatomic, assign, readonly) CGRect iconF;
/**
 *  时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  正文的frame
 */
@property (nonatomic, assign, readonly) CGRect textF;
/**
 *  cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  数据模型
 */
@property (nonatomic, strong) LKMessage *message;

@end
