//
//  WSYMyTravelsFirstView.h
//  YouBao
//
//  Created by 王世勇 on 2018/7/16.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYMyTravelsFirstView : UIView

/** 游记标题 */
@property (nonatomic, strong) UILabel *titleStr;

/**
 添加音乐block
 */
@property (nonatomic, copy) dispatch_block_t addMusicBtnClickBlock;
/**
 进入游记标题界面block
 */
@property (nonatomic, copy) dispatch_block_t titleBtnClickBlock;
/**
 添加文字block
 */
@property (nonatomic, copy) dispatch_block_t addWordsBtnClickBlock;
/**
 插入照片block
 */
@property (nonatomic, copy) dispatch_block_t addImagesBtnClickBlock;

@end
