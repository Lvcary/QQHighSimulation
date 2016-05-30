//
//  LKChatViewController.m
//  QQHighSimulation
//
//  Created by 刘康蕤 on 16/5/27.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "LKChatViewController.h"
#import "InputView.h"
#import "LKMessage.h"
#import "LKMessagFrame.h"
#import "LKMessageCell.h"
@interface LKChatViewController()<UITableViewDelegate,UITableViewDataSource,InputViewSendMessageDelegate>

@property (nonatomic, weak)UITableView * tableView;
@property (nonatomic, strong)InputView *inputView;  ///< 底部的输入栏

@property (nonatomic, strong) NSMutableArray *dataSource;  ///< 数据源

@end

@implementation LKChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // 监听键盘高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHeightChangeNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // tableView
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.allowsSelection = NO;
    [self.view addSubview:table];
    _tableView = table;
    
    // 输入栏
    _inputView = [[InputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44)];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSArray * messArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
        NSMutableArray * mfArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dic in messArray) {
            // 消息模型
            LKMessage * msg = [LKMessage messageWithDict:dic];
            
            // 取出上一个模型
            LKMessagFrame * lastMf = [mfArray lastObject];
            LKMessage * lastMsg = lastMf.message;
            
            // 判断时间是否一致
            msg.hideTime = [msg.time isEqualToString:lastMsg.time];
            
            // frame模型
            LKMessagFrame *mf = [[LKMessagFrame alloc] init];
            mf.message = msg;
            
            // 添加
            [mfArray addObject:mf];
        }
        _dataSource = mfArray;
    }
    return _dataSource;
}

- (void)tapAction:(UITapGestureRecognizer *) sender {
    [_inputView resignFirstResponder];
}

#pragma mark  ***** 监听键盘高度变化 *****
- (void)keyBoardHeightChangeNotification:(NSNotification *)note {

    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 1.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.取出键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 3. 计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 4.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark  ***** tableViewDataSource *****
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    LKMessageCell *cell = [LKMessageCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messageFrame = self.dataSource[indexPath.row];
    
    // 3.返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKMessagFrame *mf = self.dataSource[indexPath.row];
    return mf.cellHeight;
}


#pragma mark - 发送消息代理方法
- (void)sendMessage:(NSString *)mseeage {
    // 发消息
    [self addMessage:mseeage type:LKMessageTYpeMe];
    
    // 收到消息
    [self addMessage:@"哦" type:LKMessageTypeOther];
}

/**
 *  发送一条消息
 */
- (void)addMessage:(NSString *)text type:(LKMessageType)type
{
    // 1.数据模型
    LKMessage *msg = [[LKMessage alloc] init];
    msg.type = type;
    msg.text = text;
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    // NSDate  --->  NSString
    // NSString ---> NSDate
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //  2014-08-09 15:45:56
    // 09/08/2014  15:45:56
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    LKMessagFrame *lastMf = [self.dataSource lastObject];
    LKMessage *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    
    // 2.frame模型
    LKMessagFrame *mf = [[LKMessagFrame alloc] init];
    mf.message = msg;
    [self.dataSource addObject:mf];
    
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
