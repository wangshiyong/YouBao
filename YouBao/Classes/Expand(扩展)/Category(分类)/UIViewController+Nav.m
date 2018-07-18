//
//  UIViewController+Nav.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/27.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "UIViewController+Nav.h"

@implementation UIViewController (Nav)

- (UINavigationController*)myNavigationController
{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    } else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = ((UITabBarController*)self).selectedViewController.myNavigationController;
        } else {
            nav = self.navigationController;
        }
    }
    return nav;
}

@end
