//
//  CAShapeLayer + Mask.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/5.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "CAShapeLayer+Mask.h"

@implementation CAShapeLayer (Mask)

+ (instancetype)createMaskLayerWithView:(UIView *)view{
    CGSize size = view.frame.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addQuadCurveToPoint:CGPointMake(0, 0) controlPoint:CGPointMake(size.width/2, 35)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor purpleColor].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    return layer;
}

@end
