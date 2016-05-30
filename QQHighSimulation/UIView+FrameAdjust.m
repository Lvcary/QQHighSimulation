//
//  UIView+FrameAdjust.m
//  CoreTextDemo
//
//  Created by 刘康蕤 on 16/5/16.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "UIView+FrameAdjust.h"

@implementation UIView (FrameAdjust)

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

@end
