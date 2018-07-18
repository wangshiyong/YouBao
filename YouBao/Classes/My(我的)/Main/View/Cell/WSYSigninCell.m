//
//  WSYSigninCell.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYSigninCell.h"

@interface WSYSigninCell()

@property (nonatomic, strong)YYLabel *money;
@property (nonatomic, strong)YYLabel *gold;
@property (nonatomic, strong) UIButton *takeBtn;

@end

@implementation WSYSigninCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    _money = [YYLabel new];
    NSString *str = @"宝石 8888";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:str];
    text.yy_color = WSYTheme_Text;
    text.yy_font = WSYFont(17);
    [text yy_setColor:[UIColor blackColor] range:NSMakeRange(2, str.length - 2)];
    _money.attributedText = text;
    [self addSubview:_money];
    
    _gold = [YYLabel new];NSString *strr = @"金币 888888";
    NSMutableAttributedString *textt = [[NSMutableAttributedString alloc]initWithString:strr];
    textt.yy_color = WSYTheme_Text;
    textt.yy_font = WSYFont(17);
    [textt yy_setColor:[UIColor blackColor] range:NSMakeRange(2, str.length - 2)];
    _gold.attributedText = textt;
    [self addSubview:_gold];
    
    
    _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takeBtn setTitle:@"打卡" forState:UIControlStateNormal];
    _takeBtn.backgroundColor = WSYTheme_Color;
    _takeBtn.layer.cornerRadius = 18;
    _takeBtn.titleLabel.font = WSYFont(15);
    [_takeBtn addTarget:self action:@selector(signInBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takeBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self);
        make.left.equalTo(self).offset(20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [self.gold mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self);
        make.left.equalTo(self.money.mas_right).offset(20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(36);
    }];
}

-(void)signInBtnBeTouched {
    !_signInBtnClickBlock ? : _signInBtnClickBlock();
}
@end
