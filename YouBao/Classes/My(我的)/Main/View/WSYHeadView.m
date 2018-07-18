//
//  WSYHeadViewCell.m
//  Albatross
//
//  Created by wangshiyong on 2017/12/15.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#import "WSYHeadView.h"

@interface WSYHeadView ()<UIGestureRecognizerDelegate>

/** 头像 */
@property (nonatomic, strong)UIImageView *headImage;
/** 昵称 */
@property (nonatomic, strong)UILabel *nameLab;
/** 等级 */
@property (nonatomic, strong)UILabel *gradeLab;
/** 地址 */
@property (nonatomic, strong)YYLabel *addressLab;
/** 关注 */
@property (nonatomic, strong)YYLabel *followLab;
/** 粉丝 */
@property (nonatomic, strong)YYLabel *fansLab;
/** 多媒体按钮 */
@property (nonatomic, strong)UIButton *takeBtn;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WSYHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI {
    _headImage = [UIImageView new];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:[WSYUserDataTool getUserData:USER_ICON]]
                                             placeholderImage:[UIImage imageNamed:@"M_photo"]];
    _headImage.layer.cornerRadius = 30;
    _headImage.clipsToBounds = YES;
    [_headImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:_headImage];
    
    _nameLab = [UILabel new];
    _nameLab.text = [WSYUserDataTool getUserData:USER_NICKNAME];
    _nameLab.font = WSYFont(22);
    _nameLab.textColor = [UIColor blackColor];
    [self addSubview:_nameLab];
    
    _gradeLab = [UILabel new];
    _gradeLab.textAlignment = NSTextAlignmentCenter;
    _gradeLab.text = @"Lv1";
    _gradeLab.font = WSYFont(11);
    _gradeLab.layer.borderWidth = 1;
    _gradeLab.layer.borderColor = WSYTheme_Text.CGColor;
    _gradeLab.textColor = WSYTheme_Text;
    [self addSubview:_gradeLab];
    
    _addressLab = [YYLabel new];
    _addressLab.font = WSYFont(15);
    NSString *str = @"常住地 广东省深圳市民治南景新村907";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:str];
    text.yy_color = WSYTheme_Text;
    [text yy_setColor:[UIColor blackColor] range:NSMakeRange(3, str.length - 3)];
    _addressLab.attributedText = text;
    [self addSubview:_addressLab];
    
    _followLab = [YYLabel new];
    _followLab.font = WSYFont(15);
    NSString *followStr = @"关注 50";
    NSMutableAttributedString *followText = [[NSMutableAttributedString alloc]initWithString:followStr];
    followText.yy_color = WSYTheme_Text;
    [followText yy_setColor:[UIColor blackColor] range:NSMakeRange(2, followStr.length - 2)];
    _followLab.attributedText = followText;
    [self addSubview:_followLab];
    
    _fansLab = [YYLabel new];
    _fansLab.font = WSYFont(15);
    NSString *fansStr = @"粉丝 88888";
    NSMutableAttributedString *fansText = [[NSMutableAttributedString alloc]initWithString:fansStr];
    fansText.yy_color = WSYTheme_Text;
    [fansText yy_setColor:[UIColor blackColor] range:NSMakeRange(2, fansStr.length - 2)];
    _fansLab.attributedText = fansText;
    [self addSubview:_fansLab];
    
    _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_takeBtn setTitle:@"记录你的旅行" forState:UIControlStateNormal];
    [_takeBtn addTarget:self action:@selector(takeBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _takeBtn.backgroundColor = WSYTheme_Color;
    _takeBtn.layer.cornerRadius = 30;
    _takeBtn.titleLabel.font = WSYFont(18);
    [self addSubview:_takeBtn];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_bottomView];
    
    @weakify(self);
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]init];
    [[recognizer rac_gestureSignal]subscribeNext:^(id x){
        @strongify(self);
        [self myViewBtnBeTouched];
    }];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self).offset(NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.headImage.mas_right).offset(16);
        make.top.equalTo(self).offset(NAV_HEIGHT);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 120);
    }];
    
    [self.gradeLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.nameLab.mas_right).offset(5);
        make.centerY.equalTo(self.nameLab);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(16);
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.headImage.mas_right).offset(16);
        make.top.equalTo(self.nameLab.mas_bottom).offset(6);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 220);
    }];

    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(60);
        make.left.equalTo(self).offset(90);
        make.right.equalTo(self).offset(-90);
        make.bottom.equalTo(self).offset(-40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.followLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.addressLab.mas_right).offset(8);
        make.centerY.equalTo(self.addressLab);
        make.width.mas_lessThanOrEqualTo(50);
    }];
    
    [self.fansLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.followLab.mas_right).offset(8);
        make.centerY.equalTo(self.addressLab);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
}

- (void)myViewBtnBeTouched {
    !_myViewClickBlock ? : _myViewClickBlock();
}


- (void)takeBtnBeTouched{
    !_mytakeBtnClickBlock ? : _mytakeBtnClickBlock();
}


@end
