//
//  CAShapeLayer + Mask.h
//  YouBao
//
//  Created by 王世勇 on 2018/7/5.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAShapeLayer (Mask)

+ (instancetype)createMaskLayerWithView:(UIView *)view;

@end
