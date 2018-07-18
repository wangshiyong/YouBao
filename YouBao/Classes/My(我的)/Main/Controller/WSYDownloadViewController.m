//
//  WSYDownloadViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/6.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYDownloadViewController.h"

// Controllers
#import "WSYAllCollectionViewController.h"
#import "WSYStrategyViewController.h"

@interface WSYDownloadViewController ()

@end

@implementation WSYDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav {
    self.customNavBar.title = @"我的下载";
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setRightButtonWithTitle:@"编辑" titleColor:[UIColor blackColor]];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"全部收藏";
        case 1: return @"收藏夹";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[WSYAllCollectionViewController alloc] init];
        case 1: return [[WSYStrategyViewController alloc] init];
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
