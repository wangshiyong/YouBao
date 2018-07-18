//
//  WSYHeadViewCell.h
//  Albatross
//
//  Created by wangshiyong on 2017/12/15.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYHeadView : UICollectionReusableView

/** 界面block */
@property (nonatomic, copy) dispatch_block_t myViewClickBlock;
/** 多媒体按钮block */
@property (nonatomic, copy) dispatch_block_t mytakeBtnClickBlock;

@end
