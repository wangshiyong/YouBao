//
//  WSYNewsViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/6.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYNewsViewController.h"

// Controllers
#import "WSYNoticeViewController.h"
#import "WSYBroadcastViewController.h"
#import "WSYMessageViewController.h"

@interface WSYNewsViewController ()

@end

@implementation WSYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"消息";
    [self.customNavBar wr_setBottomLineHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"通知";
        case 1: return @"广播";
        case 2: return @"私信";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 3) {
        case 0: return [[WSYNoticeViewController alloc] init];
        case 1: return [[WSYBroadcastViewController alloc] init];
        case 2: return [[WSYMessageViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, kScreenWidth - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, kScreenWidth, kScreenHeight - originY);
}

@end
