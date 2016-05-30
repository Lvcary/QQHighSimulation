//
//  InputView.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "InputView.h"
#import "UIView+FrameAdjust.h"
@interface InputView()<UITextViewDelegate>

@property (nonatomic, strong) UIButton * talkBtn;  ///< 语音btn

@property (nonatomic, strong) UITextView * contentText;  ///< 输入的文字textView

@property (nonatomic, strong) UIButton * pressLongBtn;  ///< 长按录音的按钮

@property (nonatomic, strong) UIButton * emojiAndKeyBtn;  ///< 表情和键盘切换

@property (nonatomic, strong) UIButton * otherBtn;  ///< 其他btn

@property (nonatomic, strong) UIView * emojiView;  ///< 表情键盘
@property (nonatomic, strong) UIView * otherView;  ///< 其他view

@property (nonatomic, assign) KeyType currentKeyType;  ///< 当前的键盘类型

@end

@implementation InputView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.95
                                                 alpha:1];
        
        _talkBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 44, 44);
            [btn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:0];
            [btn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [btn addTarget:self action:@selector(talkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:_talkBtn];
        
        _otherBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.width - 44,0, 44, 44);
            [btn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:0];
            [btn setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateHighlighted];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [btn addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:_otherBtn];
        
        _emojiAndKeyBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(self.width - 88,0, 44, 44);
            [btn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:0];
            [btn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_nor"] forState:UIControlStateSelected];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [btn addTarget:self action:@selector(emojiAndKeyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [self addSubview:_emojiAndKeyBtn];
        
        _contentText = ({
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(44, 7, self.width - 44*3, 30)];
            textView.backgroundColor = [UIColor whiteColor];
            textView.textColor = [UIColor blackColor];
            textView.font = [UIFont systemFontOfSize:14];
            textView.delegate = self;
            textView.layer.masksToBounds = YES;
            textView.layer.cornerRadius = 7;
            textView.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
            textView.layer.borderWidth = 1;
            textView.returnKeyType = UIReturnKeySend;
            
            
            textView;
        });
        [self addSubview:_contentText];
        
        _pressLongBtn = ({
            UIButton *pressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pressBtn.frame = CGRectMake(44, 7, self.width - 44*3, 30);
            [pressBtn setTitle:@"按住 说话" forState:0];
            [pressBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [pressBtn setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:0];
            pressBtn.layer.masksToBounds = YES;
            pressBtn.layer.cornerRadius = 7;
            pressBtn.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
            pressBtn.layer.borderWidth = 1;
            pressBtn.hidden = YES;
            
            pressBtn;
        });
        [self addSubview:_pressLongBtn];
        
    }
    return self;
}

#pragma mark   **** 懒加载 ****
- (UIView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 252)];
        _emojiView.backgroundColor = [UIColor orangeColor];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_emojiView.width/2 - 80, _emojiView.height/2 - 30, 160, 60)];
        label.text = @"这是表情键盘";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [_emojiView addSubview:label];
    }
    return _emojiView;
}

- (UIView *)otherView {
    if (!_otherView) {
        _otherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 252)];
        _otherView.backgroundColor = [UIColor purpleColor];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_otherView.width/2 - 80, _otherView.height/2 - 30, 160, 60)];
        label.text = @"这是其他视图键盘";
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        [_otherView addSubview:label];
    }
    return _otherView;
}

#pragma mark   **** Action ****
- (void)talkBtnAction:(UIButton *)sender {
    _emojiAndKeyBtn.selected = NO;
    _otherBtn.selected = NO;
    _contentText.hidden = !sender.selected;
    _pressLongBtn.hidden = sender.selected;
    if (sender.selected) {
        [self setKeyType:defaultKey];
        sender.selected = NO;
    }else {
        [self setKeyType:voiceRecordingKey];
        sender.selected = YES;
    }
}

- (void)emojiAndKeyBtnAction:(UIButton *)sender {
    _talkBtn.selected = NO;
    _otherBtn.selected = NO;
    if (sender.selected) {
        [self setKeyType:defaultKey];
        sender.selected = NO;
    }else {
        [self setKeyType:emojiKey];
        sender.selected = YES;
    }
}

- (void)otherBtnAction:(UIButton *)sender {
    _talkBtn.selected = NO;
    _emojiAndKeyBtn.selected = NO;
    if (sender.selected) {
        [self setKeyType:defaultKey];
        sender.selected = NO;
    }else {
        [self setKeyType:otherKey];
        sender.selected = YES;
    }
}

#pragma mark   **** set ****
- (void)setKeyType:(KeyType)keyType {
    _currentKeyType = keyType;
    switch (keyType) {
        case defaultKey:
        {
            _contentText.inputView = nil;
        }
            break;
        case voiceRecordingKey:
        {
            _contentText.inputView = nil;
            [_contentText resignFirstResponder];
        }
            break;
        case emojiKey:
        {
            _contentText.inputView = self.emojiView;
            _contentText.hidden = NO;
            _pressLongBtn.hidden = YES;
        }
            break;
        case otherKey:
        {
            _contentText.inputView = self.otherView;
            _contentText.hidden = NO;
            _pressLongBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
    if (keyType != voiceRecordingKey) {
        [_contentText becomeFirstResponder];
    }
    [_contentText reloadInputViews];
}

#pragma mark  **** textViewDelegate ****
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _talkBtn.selected = NO;
    _emojiAndKeyBtn.selected = NO;
    _otherBtn.selected = NO;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(sendMessage:)]) {
            [self.delegate sendMessage:_contentText.text];
            _contentText.text = @"";
        }
        return NO;
    }
    return YES;
}

- (void)resignFirstResponder {
    _talkBtn.selected = NO;
    _emojiAndKeyBtn.selected = NO;
    _otherBtn.selected = NO;
    
    [_contentText resignFirstResponder];
}

@end
