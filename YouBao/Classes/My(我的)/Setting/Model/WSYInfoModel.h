//
//  WSYInfoModel.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/28.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSYInfoModel : NSObject

/** 姓名 */
@property (nonatomic, copy) NSString *nameStr;
/** 性别 */
@property (nonatomic, copy) NSString *genderStr;
/** 地址信息 */
@property (nonatomic, copy) NSString *addressStr;
/** 个性签名 */
@property (nonatomic, copy) NSString *signStr;


@end
