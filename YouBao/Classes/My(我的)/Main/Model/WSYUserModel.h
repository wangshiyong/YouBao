//
//  WSYUserModel.h
//  YouBao
//
//  Created by 王世勇 on 2018/6/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSYUserModel : NSObject

/** 城市  */
@property (nonatomic, copy) NSString *city;
/** 昵称  */
@property (nonatomic, copy) NSString *nickName;
/** 账号  */
@property (nonatomic, copy) NSString *userName;
/** 等级  */
@property (nonatomic, copy) NSString *level;
/** 头像  */
@property (nonatomic, copy) NSString *icon;
/** 背景图像  */
@property (nonatomic, copy) NSString *bgImage;

@end
