//
//  UILabel+ChangeSpace.h
//  YouBao
//
//  Created by 王世勇 on 2018/7/12.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel (ChangeSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end
