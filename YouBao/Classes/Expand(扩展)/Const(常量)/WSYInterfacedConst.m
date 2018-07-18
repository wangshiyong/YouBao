//
//  WSYInterfacedConst.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/27.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYInterfacedConst.h"

@implementation WSYInterfacedConst

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"http://192.168.1.45:8016";
NSString *const kApiPrefixHttps = @"https://192.168.1.45:8017";
#endif

/** 注册 */
NSString *const kRegister = @"/api/user/register";
/** 登录 */
NSString *const kLogin = @"/api/user/login";
/** 用户图像上传 */
NSString *const kUploadUserImage = @"/api/user/UploadFile";

@end
