//
//  WSYMyCommentViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/11.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyCommentViewController.h"

// Controllers
#import "WSYReviewViewController.h"
#import "WSYNoReviewViewController.h"


@interface WSYMyCommentViewController ()

@end

@implementation WSYMyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav {
    self.customNavBar.title = @"我的点评";
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setRightButtonWithTitle:@"添加" titleColor:[UIColor blackColor]];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"已点评";
        case 1: return @"未点评";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [[WSYReviewViewController alloc] init];
        case 1:
            return [[WSYNoReviewViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

//- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//    if ([info[@"index"] integerValue] == 0) {
//        self.customNavBar.rightButton.hidden = NO;
//    } else {
//        self.customNavBar.rightButton.hidden = YES;
//    }
//}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? iphoneX ? 44 : 20 : NAV_HEIGHT;
    return CGRectMake(leftMargin, originY, kScreenWidth - 2*leftMargin, 43);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, kScreenWidth, kScreenHeight - originY);
}

@end
