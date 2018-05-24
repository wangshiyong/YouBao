//
//  WSYVerificationView.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/23.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYVerificationView.h"

@interface WSYVerificationView ()

@property (nonatomic, strong) UIButton *areaCodeBtn;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *loginCodeBtn;

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
    
//    self.backgroundColor = [UIColor yellowColor];
    
    self.areaCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaCodeBtn setTitle:@"中国 +86" forState:UIControlStateNormal];
//    self.areaCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.areaCodeBtn setTitleColor:Color_Wathet forState:UIControlStateNormal];
    self.areaCodeBtn.titleLabel.font = WSYFont(15);
    [self addSubview:self.areaCodeBtn];
    
    self.phoneText = [UITextField new];
    self.phoneText.placeholder = @"请输入手机号";
    self.phoneText.font = WSYFont(16);
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.phoneText];
    
    self.line1 = [UIView new];
    self.line1.backgroundColor = WSYColor(241, 241, 241);
    [self addSubview:self.line1];
    
    
    self.codeLab = [UILabel new];
    self.codeLab.text = @"短信验证码";
    self.codeLab.textColor = WSYTheme_Text;
    self.codeLab.font = WSYFont(15);
    [self addSubview:self.codeLab];
    
    self.codeText = [UITextField new];
    self.codeText.placeholder = @"请输入验证码";
    self.codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeText.font = WSYFont(16);
    [self addSubview:self.codeText];
    
    self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = WSYFont(13);
    self.codeBtn.backgroundColor = WSYTheme_Color;
    [self addSubview:self.codeBtn];
    self.codeBtn.layer.cornerRadius = 14;
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = WSYColor(241, 241, 241);
    [self addSubview:self.line2];
    
    self.loginCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginCodeBtn setTitle:@"登 录" forState:UIControlStateNormal];
    self.loginCodeBtn.titleLabel.font = WSYFont(18);
    self.loginCodeBtn.backgroundColor = WSYTheme_Color;
    self.loginCodeBtn.layer.cornerRadius = 23;
    [self addSubview:self.loginCodeBtn];
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
