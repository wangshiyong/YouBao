//
//  WSYMyServiceItemCell.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyServiceItemCell.h"

// Models
#import "WSYGridItem.h"

@interface WSYMyServiceItemCell ()

/* imageView */
@property (strong , nonatomic)UIImageView *gridImageView;
/* gridLabel */
@property (strong , nonatomic)UILabel *gridLabel;
/* tagLabel */
@property (strong , nonatomic)UILabel *tagLabel;

@end

@implementation WSYMyServiceItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    _gridImageView = [[UIImageView alloc] init];
    _gridImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_gridImageView];
    
    _gridLabel = [[UILabel alloc] init];
    _gridLabel.font = WSYFont(13);
    _gridLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_gridLabel];
    
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.font = [UIFont systemFontOfSize:8];
    _tagLabel.backgroundColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tagLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    @weakify(self);
    [_gridImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        [make.top.mas_equalTo(self)setOffset:10];
        if (iphone5) {
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }else{
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }
        make.centerX.mas_equalTo(self);
    }];
    
    [_gridLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self.gridImageView.mas_bottom)setOffset:5];
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.gridImageView.mas_centerX);
        make.top.mas_equalTo(self.gridImageView);
        make.size.mas_equalTo(CGSizeMake(35, 15));
    }];
    
}

#pragma mark - Setter Getter Methods
- (void)setGridItem:(WSYGridItem *)gridItem {
    _gridItem = gridItem;
    _gridLabel.text = gridItem.gridTitle;
    _tagLabel.text = gridItem.gridTag;
    
    _tagLabel.hidden = (gridItem.gridTag.length == 0) ? YES : NO;
//    _tagLabel.textColor = [UIColor dc_colorWithHexString:gridItem.gridColor];
//    [DCSpeedy dc_chageControlCircularWith:_tagLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:_tagLabel.textColor canMasksToBounds:YES];
    
    if (_gridItem.iconImage.length == 0) return;
    if ([[_gridItem.iconImage substringToIndex:4] isEqualToString:@"http"]) {
        [_gridImageView sd_setImageWithURL:[NSURL URLWithString:gridItem.iconImage]placeholderImage:[UIImage imageNamed:@"default_49_11"]];
    } else {
        _gridImageView.image = [UIImage imageNamed:_gridItem.iconImage];
    }
}


@end
