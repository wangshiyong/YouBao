//
//  WSYUserDataTool.m
//  Travel_Card
//
//  Created by 王世勇 on 2017/3/1.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#import "WSYUserDataTool.h"

@implementation WSYUserDataTool

+ (void)setUserData:(id)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+ (id)getUserData:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+ (void)removeUserData:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

@end
