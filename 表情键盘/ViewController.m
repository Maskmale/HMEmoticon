//
//  ViewController.m
//  表情键盘
//
//  Created by 刘凡 on 16/3/3.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "HMEmoticonTextView.h"
#import "HMEmoticonInputView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HMEmoticonTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 通过表情描述字符串设置属性字符串
    NSString *text = @"[爱你]啊[笑哈哈]";
    NSAttributedString *attributeText = [[HMEmoticonManager sharedManager]
                                         emoticonStringWithString:text
                                         font:_textView.font];
    _textView.attributedText = attributeText;
    
    // 2. 设置用户标示 - 用于保存最近使用表情
    [HMEmoticonManager sharedManager].userIdentifier = @"刀哥";
    
    // 3. 设置表情输入视图
    __weak typeof(self) weakSelf = self;
    _textView.inputView = [[HMEmoticonInputView alloc] initWithSelectedEmoticon:^(HMEmoticon * _Nullable emoticon, BOOL isRemoved) {
        [weakSelf.textView inputEmoticon:emoticon isRemoved:isRemoved];
    }];
    
    // 4. 监听键盘通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillChanged:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)showText:(id)sender {
    NSLog(@"%@", _textView.emoticonText);
}

- (void)keyboardWillChanged:(NSNotification *)notification {
    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    _bottomConstraint.constant = self.view.bounds.size.height - rect.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:curve];
        
        [self.view layoutIfNeeded];
    }];
}

@end
