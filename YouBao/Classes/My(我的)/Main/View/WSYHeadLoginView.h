//
//  WSYHeadLoginView.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYHeadLoginView : UICollectionReusableView

/** 登录按钮block */
@property (nonatomic, copy) dispatch_block_t myloginBtnClickBlock;

@end
