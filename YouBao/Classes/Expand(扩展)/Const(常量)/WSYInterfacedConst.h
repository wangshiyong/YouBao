//
//  WSYInterfacedConst.h
//  YouBao
//
//  Created by 王世勇 on 2018/6/27.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DevelopSever 0
#define TestSever    1

@interface WSYInterfacedConst : NSObject

/** 接口前缀-开发服务器*/
UIKIT_EXTERN NSString *const kApiPrefix;
UIKIT_EXTERN NSString *const kApiPrefixHttps;

#pragma mark - 详细接口地址
/** 注册 */
UIKIT_EXTERN NSString *const kRegister;
/** 登录 */
UIKIT_EXTERN NSString *const kLogin;
/** 用户图像上传 */
UIKIT_EXTERN NSString *const kUploadUserImage;

@end
