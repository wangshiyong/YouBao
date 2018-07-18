//
//  WSYNotificationCenterName.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/29.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYNotificationCenterName : NSObject

#pragma mark - 项目中所有通知

/** 登录成功返回通知 */
UIKIT_EXTERN NSString *const LOGIN_SUCESSS_NOTICE;
/** 退出登录返回通知 */
UIKIT_EXTERN NSString *const LOGOUT_NOTICE;
/** 选择背景照片返回通知 */
UIKIT_EXTERN NSString *const SELECT_BGIMAGE_NOTICE;
/** 选择个人头像照片返回通知 */
UIKIT_EXTERN NSString *const SELECT_PORTRAITIMAGE_NOTICE;
/** 选择城市返回通知 */
UIKIT_EXTERN NSString *const SELECT_CITY_NOTICE;

@end
