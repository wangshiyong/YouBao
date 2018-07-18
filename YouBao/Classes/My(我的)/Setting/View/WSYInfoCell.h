//
//  WSYInfoCell.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class WSYInfoModel;

@interface WSYInfoCell : UITableViewCell

@property (nonatomic, assign) BOOL isNeed;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
//@property (nonatomic, assign) BOOL isNext;
//@property (nonatomic, strong) WSYInfoModel *model;

@end
