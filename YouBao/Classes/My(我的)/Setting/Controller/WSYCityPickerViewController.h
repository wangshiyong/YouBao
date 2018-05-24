//
//  WSYCityPickerViewController.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYBaseViewController.h"
#import "WSYCityPickerDelegate.h"
#import "WSYCityModel.h"

@interface WSYCityPickerViewController : WSYBaseViewController

@property (nonatomic, weak) id<WSYCityPickerDelegate>delegate;

/*
 *  热门城市id数组
 */
@property (nonatomic, strong) NSArray *hotCitys;

/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *data;

@end
