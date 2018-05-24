//
//  WSYCityModel.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSYCityModel : NSObject

/*
 *  城市ID
 */
@property (nonatomic, strong) NSString *cityID;

/*
 *  城市名称
 */
@property (nonatomic, strong) NSString *cityName;

/*
 *  短名称
 */
@property (nonatomic, strong) NSString *shortName;

/*
 *  城市名称-拼音
 */
@property (nonatomic, strong) NSString *pinyin;

/*
 *  城市名称-拼音首字母
 */
@property (nonatomic, strong) NSString *initials;

@end

@interface WSYCityGroupModel : NSObject

/*
 *  分组标题
 */
@property (nonatomic, strong) NSString *groupName;

/*
 *  城市数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCitys;

@end

