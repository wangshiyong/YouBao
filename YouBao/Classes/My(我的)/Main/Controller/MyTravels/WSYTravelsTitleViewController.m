//
//  WSYTravelsTitleViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/12.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYTravelsTitleViewController.h"

#import "WSYEditTravelsViewController.h"

#import "UITextView+Placeholder.h"
#import "UILabel+ChangeSpace.h"

@interface WSYTravelsTitleViewController ()

@property (nonatomic, strong) UITextView *titleView;
@property (nonatomic, strong) UILabel *input;
@property (nonatomic, strong) UILabel *hintStr;
@property (nonatomic, strong) UILabel *hintTitle;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation WSYTravelsTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self bindUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI {
    [self.customNavBar wr_setBottomLineHidden:YES];
    @weakify(self);
    if (_isSave) {
        [self.customNavBar wr_setRightButtonWithTitle:@"保存" titleColor:[UIColor blueColor]];
        self.customNavBar.onClickRightButton = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    } else {
        [self.customNavBar wr_setLeftButtonWithTitle:@"取消" titleColor:[UIColor blackColor]];
        [self.customNavBar wr_setRightButtonWithTitle:@"下一步" titleColor:[UIColor blueColor]];
        self.customNavBar.onClickRightButton = ^{
            @strongify(self);
            WSYEditTravelsViewController *vc = [WSYEditTravelsViewController new];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        };
    }
    
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *maker){
        @strongify(self);
        maker.top.equalTo(self.view).offset(NAV_HEIGHT + 20);
        maker.left.equalTo(self.view).offset(16);
        maker.right.equalTo(self.view).offset(-16);
        maker.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.hintTitle];
    [self.hintTitle mas_makeConstraints:^(MASConstraintMaker *maker){
        @strongify(self);
        maker.top.equalTo(self.titleView.mas_bottom).offset(64);
        maker.left.equalTo(self.view).offset(16);
    }];
    
    [self.view addSubview:self.hintStr];
    [self.hintStr mas_makeConstraints:^(MASConstraintMaker *maker){
        @strongify(self);
        maker.top.equalTo(self.hintTitle.mas_bottom).offset(8);
        maker.left.equalTo(self.view).offset(16);
        maker.right.equalTo(self.view).offset(-16);
    }];
    
    [self.view addSubview:self.input];
    [self.input mas_makeConstraints:^(MASConstraintMaker *maker){
        @strongify(self);
        maker.top.equalTo(self.titleView.mas_bottom).offset(5);
        maker.right.equalTo(self.view).offset(-16);
    }];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *maker){
        @strongify(self);
        maker.top.equalTo(self.input.mas_bottom).offset(5);
        maker.left.equalTo(self.view).offset(16);
        maker.right.equalTo(self.view).offset(-16);
        maker.height.mas_equalTo(1);
    }];
}

- (void)bindUI {
    @weakify(self);
    [[self.titleView rac_textSignal] subscribeNext:^(NSString *str){
        @strongify(self);
        if (str.length >= 50) {
            self.titleView.text = [NSString stringWithFormat:@"%@",[str substringToIndex:50]];
            self.input.text = @"50/50";
            self.input.textColor = [UIColor redColor];
        }  else {
            self.input.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)str.length];
            self.input.textColor = [UIColor blackColor];
        }
    }];
}

#pragma mark ============懒加载============

- (UITextView *)titleView {
    if (!_titleView) {
        _titleView = [UITextView new];
        _titleView.font = WSYBoldFont(20);
        _titleView.placeholder = @"请输入游记标题";
        _titleView.placeholderColor = [UIColor blackColor];
    }
    return _titleView;
}

- (UILabel *)hintStr {
    if (!_hintStr) {
        _hintStr = [UILabel new];
        _hintStr.textColor = [UIColor grayColor];
        _hintStr.font = WSYFont(14);
        _hintStr.numberOfLines = 0;
        _hintStr.text = @"1.一个好的游记标题会给你带来更多阅读。\n2.标题也可以在写游记的过程中进行编辑。\n3.设置好标题后，可以通过点击“下一步”来添加照片或文字。";
        [UILabel changeLineSpaceForLabel:_hintStr WithSpace:8];
    }
    return _hintStr;
}

- (UILabel *)hintTitle {
    if (!_hintTitle) {
        _hintTitle = [UILabel new];
        _hintTitle.textColor = [UIColor blackColor];
        _hintTitle.font = WSYFont(16);
        _hintTitle.text = @"提示";
    }
    return _hintTitle;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UILabel *)input {
    if (!_input) {
        _input = [UILabel new];
        _input.font = WSYFont(12);
//        NSString *str = @"可输入 48 字";
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:str];
//        text.yy_color = [UIColor grayColor];
//        [text yy_setColor:[UIColor blackColor] range:NSMakeRange(3, str.length - 4)];
//        _input.attributedText = text;
    }
    return _input;
}

@end
