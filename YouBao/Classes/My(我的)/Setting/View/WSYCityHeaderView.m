//
//  WSYCityHeaderView.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYCityHeaderView.h"

@interface WSYCityHeaderView ()

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UILabel *gpsLab;

@end

@implementation WSYCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.searchBtn setTitle:@"🔍 搜索城市" forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:self.searchBtn];
    
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cityBtn setTitle:[WSYUserDataTool getUserData:GPS_CITY] forState:UIControlStateNormal];
    [self.cityBtn setTitleColor:Color_Wathet forState:UIControlStateNormal];
    [self.cityBtn addTarget:self action:@selector(cityClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cityBtn];
    
    self.gpsLab = [[UILabel alloc]init];
    self.gpsLab.text = @"GPS定位";
    self.gpsLab.font = [UIFont systemFontOfSize:14.0f];
    self.gpsLab.textColor = [UIColor grayColor];
    [self addSubview:self.gpsLab];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_offset(UIEdgeInsetsMake(5, 5, 40, 5));
    }];
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.searchBtn.mas_bottom).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.gpsLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.cityBtn.mas_right).offset(15);
        make.centerY.equalTo(self.cityBtn);
    }];
}

- (void)searchClick {
    !_searchBtnClickBlock ? : _searchBtnClickBlock();
}

- (void)cityClick {
    !_cityBtnClickBlock ? : _cityBtnClickBlock();
}

@end
