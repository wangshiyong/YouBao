//
//  WSYMyInfoHeadView.h
//  YouBao
//
//  Created by 王世勇 on 2018/7/4.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYMyInfoHeadView : UIView

/** 背景图片 */
@property (nonatomic, strong) UIImageView *bgImage;
/** 头像按钮 */
@property (nonatomic, strong) UIButton *headBtn;
/** 昵称 */
@property (nonatomic, strong) UILabel *name;
/** 等级按钮 */
@property (nonatomic, strong) UIButton *leaveBtn;
/** 定位图片 */
@property (nonatomic, strong) UIImageView *gpsImage;
/** 位置信息 */
@property (nonatomic, strong) UILabel *address;
/** 关注按钮 */
@property (nonatomic, strong) UIButton *followBtn;
/** 粉丝按钮 */
@property (nonatomic, strong) UIButton *fansBtn;
/** 游记按钮 */
@property (nonatomic, strong) UIButton *travelsBtn;
/** 问答按钮 */
@property (nonatomic, strong) UIButton *questionBtn;
/** 点评按钮 */
@property (nonatomic, strong) UIButton *commentBtn;
/** 视频按钮 */
@property (nonatomic, strong) UIButton *videoBtn;
/** 白色背景view */
@property (nonatomic, strong) UIView *bgView;
/** 今日访问 */
@property (nonatomic, strong) YYLabel *today;
/** 累计访问 */
@property (nonatomic, strong) YYLabel *total;
/** 访问按钮 */
@property (nonatomic, strong) UIButton *visitBtn;


@property (nonatomic, copy) dispatch_block_t myHeadBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myLevelBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myFollowBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myFansBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myTravelsBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myQuestionBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myCommentBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myVideosBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t myVisitsBtnClickBlock;

@end
