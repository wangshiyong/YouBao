//
//  WSYHeadLoginView.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYHeadLoginView.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface WSYHeadLoginView ()

@property (nonatomic, strong) UILabel *helloLab;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) FLAnimatedImageView *customImageView;
@property (nonatomic, strong) UIImageView *welcomeImageView;

@end

@implementation WSYHeadLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    _helloLab = [UILabel new];
    _helloLab.text = @"欢迎来到游宝";
    _helloLab.font = WSYFont(30);
    _helloLab.textColor = [UIColor blackColor];
    [self addSubview:_helloLab];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    _loginBtn.backgroundColor = WSYTheme_Color;
    _loginBtn.titleLabel.font = WSYFont(19);
    [_loginBtn addTarget:self action:@selector(loginBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 25;
    [self addSubview:_loginBtn];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_bottomView];
    
    _customImageView = [FLAnimatedImageView new];
    _customImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]]pathForResource:@"welcome" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    _customImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
    [self addSubview:_customImageView];
    
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.helloLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(NAV_HEIGHT + 5);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.helloLab.mas_bottom).offset(20);
        make.width.mas_equalTo(kScreenWidth/2 - 50);
        make.height.mas_equalTo(50);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(-kScreenWidth/4);
        make.bottom.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(750);
        make.height.mas_equalTo(120);
    }];
}

- (void)loginBtnBeTouched {
    !_myloginBtnClickBlock ? : _myloginBtnClickBlock();
}

@end
