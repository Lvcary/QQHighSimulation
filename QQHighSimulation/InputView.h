//
//  InputView.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    defaultKey,         ///< 默认系统键盘
    voiceRecordingKey,  ///< 语音录制键盘
    emojiKey,           ///< 表情键盘
    otherKey            ///< 其他键盘
    
}KeyType;

@protocol InputViewSendMessageDelegate;
@interface InputView : UIView

/**
 *  键盘类型
 */
@property (nonatomic, assign)KeyType keyType;
/**
 *  发送代理
 */
@property (nonatomic, assign)id<InputViewSendMessageDelegate>delegate;

/**
 *  注销键盘
 */
- (void)resignFirstResponder;

@end

@protocol InputViewSendMessageDelegate <NSObject>

- (void)sendMessage:(NSString *)mseeage;

@end