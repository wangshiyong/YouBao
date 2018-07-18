//
//  WSYNetworking.h
//  YouBao
//
//  Created by 王世勇 on 2018/6/27.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id response);
typedef void(^FailureBlock)(NSError *error);

@interface WSYNetworking : NSObject

/** 启动页广告*/
+ (void)getLaunchAdImageWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 注册 */
+ (NSURLSessionTask *)getRegisterWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 登录 */
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 上传头像 */
+ (NSURLSessionTask *)UploadImageWithKeys:(NSString *)key name:(NSString *)name images:(NSArray<UIImage *> *)array fileNames:(NSArray<NSString *> *)arrayStr imageType:(NSString *)imageType Success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
