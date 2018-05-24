//
//  WSYCityGroupCell.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSYCityPickerDelegate.h"

@interface WSYCityGroupCell : UITableViewCell

@property (nonatomic, weak) id<WSYCityGroupCellDelegate>delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray *cityArray;

+ (CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray;

@end
