//
//  WSYInfoCell.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYInfoCell.h"
#import "WSYInfoModel.h"
#import "UITextView+Placeholder.h"

#define kLeftMargin 20
#define kRowHeight 60

@interface WSYInfoCell ()

@property (nonatomic, strong) UILabel *needLabel;
//@property (nonatomic, strong) UIImageView *nextImageView;

@end

@implementation WSYInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.needLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
//        [self.contentView addSubview:self.nextImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整cell分割线的边距：top, left, bottom, right
    self.separatorInset = UIEdgeInsetsMake(0, kLeftMargin, 0, kLeftMargin);
    self.needLabel.frame = CGRectMake(kLeftMargin - 16, 0, 16, kRowHeight);
    self.titleLabel.frame = CGRectMake(kLeftMargin, 0, 80, kRowHeight);
//    self.nextImageView.frame = CGRectMake(kScreenWidth - kLeftMargin - 14, (kRowHeight - 14) / 2, 14, 14);
    self.textField.frame = CGRectMake(100, 0, kScreenWidth - 120, kRowHeight);
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    if (self.isNeed) {
        self.needLabel.hidden = NO;
    } else {
        self.needLabel.hidden = YES;
    }
//    if (self.isNext) {
//        self.nextImageView.hidden = NO;
//    } else {
//        self.nextImageView.hidden = YES;
//    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = WSYColor_HEX(0x464646, 1.0);
        _titleLabel.font = WSYFont(15);
    }
    return _titleLabel;
}

- (UILabel *)needLabel {
    if (!_needLabel) {
        _needLabel = [[UILabel alloc]init];
        _needLabel.font = WSYFont(15);
        _needLabel.textAlignment = NSTextAlignmentCenter;
        _needLabel.textColor = [UIColor redColor];
        _needLabel.text = @"*";
    }
    return _needLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = WSYFont(17);
        _textField.textColor = WSYColor_HEX(0x666666, 1.0);
    }
    return _textField;
}

//- (UIImageView *)nextImageView {
//    if (!_nextImageView) {
//        _nextImageView = [[UIImageView alloc]init];
//        _nextImageView.backgroundColor = [UIColor clearColor];
//        _nextImageView.image = [UIImage imageNamed:@"icon_next"];
//    }
//    return _nextImageView;
//}

//- (void)setModel:(WSYInfoModel *)model {
//    _model = model;
//}

@end
