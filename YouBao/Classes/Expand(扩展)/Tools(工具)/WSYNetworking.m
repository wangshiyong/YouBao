//
//  WSYNetworking.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/27.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYNetworking.h"
#import <PPNetworkHelper/PPNetworkHelper.h>
#import <AFNetworking/AFNetworking.h>

#define TIMEOUT 5

@implementation WSYNetworking

/** 启动页广告 */
+ (void)getLaunchAdImageWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchImageAd" ofType:@"json"]];
    NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    if(success) success(json);
}

/** 注册 */
+ (NSURLSessionTask *)getRegisterWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefix,kRegister];
    return [self requestWithURL:url parameters:parameters success:success failure:failure];
}

/** 登录 */
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",kApiPrefixHttps,kLogin];
    return [self requestWithHttpsURL:url parameters:parameters success:success failure:failure];
}

/** 上传头像 */
+ (NSURLSessionTask *)UploadImageWithKeys:(NSString *)key name:(NSString *)name images:(NSArray<UIImage *> *)array fileNames:(NSArray<NSString *> *)arrayStr imageType:(NSString *)imageType Success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kApiPrefix,kUploadUserImage,key];
    NSLog(@"%@======",url);
    return [PPNetworkHelper uploadImagesWithURL:url parameters:nil name:name images:array fileNames:arrayStr imageScale:1.0 imageType:imageType progress:nil success:success failure:failure];
}


#pragma mark ==========请求的公共方法==========

+ (NSURLSessionTask *)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(SuccessBlock)success failure:(FailureBlock)failure {
    [PPNetworkHelper setRequestTimeoutInterval:TIMEOUT];
    return [PPNetworkHelper POST:URL parameters:parameter success:^(id response) {
        NSLog(@"%@",response);
        success(response);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

+ (NSURLSessionTask *)requestWithHttpsURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(SuccessBlock)success failure:(FailureBlock)failure {
//    [PPNetworkHelper setRequestTimeoutInterval:TIMEOUT];
    [PPNetworkHelper setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager){
        sessionManager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:kApiPrefixHttps]];
    }];
    [PPNetworkHelper setSecurityPolicyWithCerPath:[[NSBundle mainBundle] pathForResource:@"ClientKejiaxun" ofType:@"cer"] validatesDomainName:NO];
    return [PPNetworkHelper POST:URL parameters:parameter success:^(id response) {
        NSLog(@"%@",response);
        success(response);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

@end
