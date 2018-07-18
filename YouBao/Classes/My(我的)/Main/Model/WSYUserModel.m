//
//  WSYUserModel.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYUserModel.h"

@implementation WSYUserModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"city" : @"city",
             @"nickName" : @"Nickname",
             @"userName" : @"UserName",
             @"level" : @"Level",
             @"icon" : @"Icon",
             @"bgImage" : @"Background"
             };
}


@end
