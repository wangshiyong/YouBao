//
//  WSYCityHeaderView.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYCityHeaderView : UIView

@property (nonatomic, copy) dispatch_block_t searchBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t cityBtnClickBlock;

@end
