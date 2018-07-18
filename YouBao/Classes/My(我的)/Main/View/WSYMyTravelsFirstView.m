//
//  WSYMyTravelsFirstView.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/16.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyTravelsFirstView.h"
#import "UIButton+Layout.h"

@interface WSYMyTravelsFirstView ()

/** 编辑 */
@property (nonatomic, strong) UILabel *editStr;
/** 线条 */
@property (nonatomic, strong) UIView *lineView;
/** 背景view */
@property (nonatomic, strong) UIView *bgView;
/** 添加音乐按钮 */
@property (nonatomic, strong) UIButton *addMusicBtn;
@property (nonatomic, strong) UIButton *addTitle;
@property (nonatomic, strong) UIButton *addImage;
@property (nonatomic, strong) UILabel *hintStr;
@property (nonatomic, strong) UILabel *descriptionStr;


@end

@implementation WSYMyTravelsFirstView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    _addMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addMusicBtn.frame = (CGRect){kScreenWidth - 100, 16, 100, 34};
    [_addMusicBtn setTitle:@"添加音乐" forState:UIControlStateNormal];
    [_addMusicBtn setImage:[UIImage imageNamed:@"L_weibo"] forState:UIControlStateNormal];
    _addMusicBtn.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [_addMusicBtn addTarget:self action:@selector(addMusicBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    _addMusicBtn.imageRect = (CGRect){10, 6, 22, 22};
    _addMusicBtn.titleRect = (CGRect){44, 0, 56, 34};
    _addMusicBtn.titleLabel.font = WSYFont(13);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_addMusicBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(17, 17)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _addMusicBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _addMusicBtn.layer.mask = maskLayer;
    [self addSubview:_addMusicBtn];
    
    _titleStr = [UILabel new];
    _titleStr.text = @"请输入游记标题";
    _titleStr.font = WSYBoldFont(20);
    _titleStr.numberOfLines = 0;
    [self addSubview:_titleStr];
    
    _editStr = [UILabel new];
    _editStr.text = @"编辑";
    _editStr.textColor = [UIColor blueColor];
    _editStr.font = WSYFont(12);
    [self addSubview:_editStr];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineView];
    
    _bgView = [UIView new];
    [self addSubview:_bgView];
    [self sendSubviewToBack:_bgView];
    UITapGestureRecognizer *recognizer = [UITapGestureRecognizer new];
    @weakify(self);
    [recognizer.rac_gestureSignal subscribeNext:^(id x){
        @strongify(self);
        !self.titleBtnClickBlock ? : self.titleBtnClickBlock();
    }];
    [self.bgView addGestureRecognizer:recognizer];


    _addTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addTitle setTitle:@"添加文字" forState:UIControlStateNormal];
    [_addTitle setImage:[UIImage imageNamed:@"M_review"] forState:UIControlStateNormal];
    [_addTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _addTitle.imageRect = (CGRect){15, 0, 50, 50};
    _addTitle.titleRect = (CGRect){0, 70, 80, 30};
    _addTitle.titleLabel.font = WSYFont(16);
    _addTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addTitle addTarget:self action:@selector(addWordsBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addTitle];
    
    _addImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addImage setTitle:@"插入照片" forState:UIControlStateNormal];
    [_addImage setImage:[UIImage imageNamed:@"M_camera"] forState:UIControlStateNormal];
    [_addImage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _addImage.imageRect = (CGRect){15, 0, 50, 50};
    _addImage.titleRect = (CGRect){0, 70, 80, 30};
    _addImage.titleLabel.font = WSYFont(16);
    _addImage.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addImage addTarget:self action:@selector(addImagesBtnBeTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addImage];
    
    _hintStr = [UILabel new];
    _hintStr.text = @"提示";
    _hintStr.font = WSYBoldFont(16);
    [self addSubview:_hintStr];
    
    _descriptionStr = [UILabel new];
    _descriptionStr.textColor = [UIColor grayColor];
    _descriptionStr.font = WSYFont(14);
    _descriptionStr.text = @"你可以任意添加一段文字或是图片开始一篇游记。后期可以用”照片排序“的功能来完成游记和文字的编辑。";
    _descriptionStr.numberOfLines = 0;
    [self addSubview:_descriptionStr];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.titleStr mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.addMusicBtn.mas_bottom);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.height.mas_equalTo(100);
    }];
    
    [self.editStr mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.titleStr.mas_bottom).offset(20);
        make.right.equalTo(self).offset(-16);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.editStr.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.editStr.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.addTitle mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.right.equalTo(self.mas_centerX).offset(-30);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(80);
    }];
    
    [self.addImage mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(20);
        make.left.equalTo(self.mas_centerX).offset(30);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(80);
    }];
    
    [self.hintStr mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.addTitle.mas_bottom).offset(50);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.descriptionStr mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.hintStr.mas_bottom).offset(8);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)addWordsBtnBeTouched {
    !_addWordsBtnClickBlock ? : _addWordsBtnClickBlock();
}

- (void)addImagesBtnBeTouched {
    !_addImagesBtnClickBlock ? : _addImagesBtnClickBlock();
}

- (void)addMusicBtnBeTouched {
    !_addMusicBtnClickBlock ? : _addMusicBtnClickBlock();
}
@end
