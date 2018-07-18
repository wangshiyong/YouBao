//
//  WSYVerificationView.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/23.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYVerificationView.h"

@interface WSYVerificationView ()


@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UIView *line2;


@end

@implementation WSYVerificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    _areaCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_areaCodeBtn setTitle:@"中国 +86" forState:UIControlStateNormal];
//    self.areaCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_areaCodeBtn setTitleColor:Color_Wathet forState:UIControlStateNormal];
    _areaCodeBtn.titleLabel.font = WSYFont(15);
    [self addSubview:_areaCodeBtn];
    
    _phoneText = [UITextField new];
    _phoneText.placeholder = @"请输入手机号";
    _phoneText.font = WSYFont(16);
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneText];
    
    _line1 = [UIView new];
    _line1.backgroundColor = WSYColor(241, 241, 241);
    [self addSubview:_line1];
    
    
    _codeLab = [UILabel new];
    _codeLab.text = @"短信验证码";
    _codeLab.textColor = WSYTheme_Text;
    _codeLab.font = WSYFont(15);
    [self addSubview:_codeLab];
    
    _codeText = [UITextField new];
    _codeText.placeholder = @"请输入验证码";
    _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    _codeText.font = WSYFont(16);
    [self addSubview:_codeText];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = WSYFont(13);
    _codeBtn.backgroundColor = WSYTheme_Color;
    [self addSubview:_codeBtn];
    _codeBtn.layer.cornerRadius = 19;
    
    _line2 = [UIView new];
    _line2.backgroundColor = WSYColor(241, 241, 241);
    [self addSubview:_line2];
    
    _loginCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginCodeBtn setTitle:@"登 录" forState:UIControlStateNormal];
    _loginCodeBtn.titleLabel.font = WSYFont(18);
    _loginCodeBtn.backgroundColor = WSYTheme_Color;
    _loginCodeBtn.layer.cornerRadius = 23;
    [self addSubview:_loginCodeBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.areaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(0);
        make.centerY.equalTo(self.phoneText);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.areaCodeBtn.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(16);
        make.height.mas_equalTo(34);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.phoneText.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.codeText);
        make.width.mas_equalTo(80);
    }];
    
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.codeText);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(38);
    }];
    
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.codeLab.mas_right).offset(10);
        make.top.equalTo(self.line1.mas_bottom).offset(16);
        make.right.equalTo(self.codeBtn.mas_left).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.codeText.mas_bottom).offset(16);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.loginCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.line2.mas_bottom).offset(25);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(46);
    }];
}


@end
