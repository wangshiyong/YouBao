//
//  WSYAddWordsViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/17.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYAddWordsViewController.h"
#import "UITextView+Placeholder.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface WSYAddWordsViewController ()

@property (nonatomic, strong) UITextView *textVeiw;

@end

@implementation WSYAddWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self bindUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindUI {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(NSNotification *notification){
        @strongify(self);
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        self.textVeiw.height = kScreenHeight - NAV_HEIGHT - keyboardRect.size.height - 10;
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(NSNotification *notification){
        @strongify(self);
        self.textVeiw.height = kScreenHeight - NAV_HEIGHT;
    }];
}

- (void)setUpUI {
    self.customNavBar.title = @"添加文字";
    [self.customNavBar wr_setRightButtonWithTitle:@"完成" titleColor:Color_Wathet];
    
    _textVeiw = [[UITextView alloc]initWithFrame:(CGRect){0, NAV_HEIGHT, kScreenWidth, 0}];
    [_textVeiw becomeFirstResponder];
    _textVeiw.placeholder = @"写点什么吧，分享旅行中的种种经历和故事～";
    _textVeiw.font = WSYFont(15);
    [self.view addSubview:_textVeiw];
}


@end
