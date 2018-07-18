//
//  WSYMyInfoHeadView.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/4.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyInfoHeadView.h"
#import "CAShapeLayer+Mask.h"

@interface WSYMyInfoHeadView ()

/** 边框view */
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WSYMyInfoHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    _bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"M_personalBG"]];
    _bgImage.contentMode = UIViewContentModeScaleAspectFill;
//    _bgImage.clipsToBounds = YES;
//    _bgImage.userInteractionEnabled = YES;
    [self addSubview:_bgImage];
    
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headBtn setBackgroundImage:[UIImage imageNamed:@"M_photo"] forState:UIControlStateNormal];
    [_headBtn addTarget:self action:@selector(headBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _headBtn.layer.cornerRadius = 30;
    [self addSubview:_headBtn];
    
    _name = [UILabel new];
    _name.text = @"王世勇";
    _name.font = WSYBoldFont(24);
    _name.textColor = [UIColor whiteColor];
    [self addSubview:_name];
    
    _leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leaveBtn.backgroundColor = [UIColor whiteColor];
    [_leaveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_leaveBtn addTarget:self action:@selector(levelBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [_leaveBtn setTitle:@"Lv2>" forState:UIControlStateNormal];
    _leaveBtn.titleLabel.font = WSYFont(13);
    _leaveBtn.layer.cornerRadius = 4;
    [self addSubview:_leaveBtn];
    
    _gpsImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"M_photo"]];
    [self addSubview:_gpsImage];
    
    _address = [UILabel new];
    _address.text = @"深圳";
    _address.font = WSYBoldFont(14);
    _address.textColor = [UIColor whiteColor];
    [self addSubview:_address];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followBtn setTitle:@"50关注" forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(followBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _followBtn.titleLabel.font = WSYBoldFont(12);
    [self addSubview:_followBtn];
    
    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fansBtn setTitle:@"8888粉丝" forState:UIControlStateNormal];
    [_fansBtn addTarget:self action:@selector(fansBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _fansBtn.titleLabel.font = WSYBoldFont(12);
    [self addSubview:_fansBtn];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    _travelsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_travelsBtn setTitle:@"游记 0" forState:UIControlStateNormal];
    [_travelsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_travelsBtn addTarget:self action:@selector(travelsBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _travelsBtn.titleLabel.font = WSYBoldFont(14);
    [self addSubview:_travelsBtn];
    
    _questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_questionBtn setTitle:@"问答 0" forState:UIControlStateNormal];
    [_questionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_questionBtn addTarget:self action:@selector(questionBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _questionBtn.titleLabel.font = WSYBoldFont(14);
    [self addSubview:_questionBtn];

    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setTitle:@"点评 0" forState:UIControlStateNormal];
    [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.titleLabel.font = WSYBoldFont(14);
    [self addSubview:_commentBtn];

    _videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_videoBtn setTitle:@"视频 0" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_videoBtn addTarget:self action:@selector(videosBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _videoBtn.titleLabel.font = WSYBoldFont(14);
    [self addSubview:_videoBtn];
    
    _view1 = [UIView new];
    _view1.backgroundColor = [UIColor grayColor];
    [self addSubview:_view1];
    
    _view2 = [UIView new];
    _view2.backgroundColor = [UIColor grayColor];
    [self addSubview:_view2];
    
    _view3 = [UIView new];
    _view3.backgroundColor = [UIColor grayColor];
    [self addSubview:_view3];
    
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_bottomView];
    
    _visitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _visitBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [_visitBtn addTarget:self action:@selector(visitBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_visitBtn];
    
    _today = [YYLabel new];
    _today.text = @"今日访问 0";
    _today.font = WSYFont(12);
    _today.textColor = [UIColor whiteColor];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_today.text];
    
    text.yy_font = WSYFont(13);
    text.yy_color = [UIColor orangeColor];
    [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
    @weakify(self);
    [text yy_setTextHighlightRange:NSMakeRange(0, 4)//设置点击的位置
                             color:[UIColor whiteColor]
                   backgroundColor:nil
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             @strongify(self);
                             !self.myVisitsBtnClickBlock ? : self.myVisitsBtnClickBlock();
                         }];
    _today.attributedText = text;
    [self addSubview:_today];
    
    _total = [YYLabel new];
    _total.text = @"累计访问 0";
    _total.font = WSYFont(12);
    _total.userInteractionEnabled = YES;
    _total.clipsToBounds = YES;
    _total.textColor = [UIColor whiteColor];
    NSMutableAttributedString *textt = [[NSMutableAttributedString alloc] initWithString:_total.text];
    
    textt.yy_font = WSYFont(13);
    textt.yy_color = [UIColor orangeColor];
    [textt yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
    [textt yy_setTextHighlightRange:NSMakeRange(0, 4)//设置点击的位置
                             color:[UIColor whiteColor]
                   backgroundColor:nil
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             @strongify(self);
                             !self.myVisitsBtnClickBlock ? : self.myVisitsBtnClickBlock();
                         }];
    _total.attributedText = textt;
    [self addSubview:_total];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(NAV_HEIGHT + 40);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.headBtn.mas_bottom).offset(20);
        make.width.mas_lessThanOrEqualTo(180);
    }];
    
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.name.mas_right).offset(8);
        make.centerY.equalTo(self.name);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(22);
    }];
    
    [self.gpsImage mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.name.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.gpsImage.mas_right);
        make.centerY.equalTo(self.gpsImage);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.gpsImage.mas_bottom);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.fansBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.followBtn.mas_right).offset(10);
        make.centerY.equalTo(self.followBtn);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(70);
    }];
    
    [self.travelsBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
        make.width.mas_equalTo((kScreenWidth - 40)/4);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.travelsBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo((kScreenWidth - 40)/4);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.questionBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo((kScreenWidth - 40)/4);
    }];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.commentBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo((kScreenWidth - 40)/4);
    }];
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.travelsBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.questionBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.commentBtn.mas_right);
        make.centerY.equalTo(self.travelsBtn);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(18);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(10);
    }];
    
    [self.today mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(NAV_HEIGHT + 10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.total mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.today.mas_bottom).offset(2);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.visitBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self).offset(NAV_HEIGHT);
        make.right.equalTo(self);
        make.left.equalTo(self.today.mas_left).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_visitBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(25, 25)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _visitBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _visitBtn.layer.mask = maskLayer;
    
    CAShapeLayer *layer = [CAShapeLayer createMaskLayerWithView:_bgView];
    _bgView.layer.mask = layer;

}

- (void)headBtnBeTouched {
    !_myHeadBtnClickBlock ? : _myHeadBtnClickBlock();
}

- (void)followBtnBeTouched {
    !_myFollowBtnClickBlock ? : _myFollowBtnClickBlock();
}

- (void)fansBtnBeTouched {
    !_myFansBtnClickBlock ? : _myFansBtnClickBlock();
}

- (void)travelsBtnBeTouched {
    !_myTravelsBtnClickBlock ? : _myTravelsBtnClickBlock();
}

- (void)questionBtnBeTouched {
    !_myQuestionBtnClickBlock ? : _myQuestionBtnClickBlock();
}

- (void)commentBtnBeTouched {
    !_myCommentBtnClickBlock ? : _myCommentBtnClickBlock();
}

- (void)videosBtnBeTouched {
    !_myVideosBtnClickBlock ? : _myVideosBtnClickBlock();
}

- (void)visitBtnBeTouched {
    !_myVisitsBtnClickBlock ? : _myVisitsBtnClickBlock();
}

- (void)levelBtnBeTouched {
    !_myLevelBtnClickBlock ? : _myLevelBtnClickBlock();
}

@end
