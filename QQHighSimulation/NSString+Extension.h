//
//  NSString+Extension.h
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/30.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
