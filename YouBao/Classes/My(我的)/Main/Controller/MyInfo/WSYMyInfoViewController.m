//
//  WSYMyInfoViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/2.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyInfoViewController.h"

// Controllers
#import "HFStretchableTableHeaderView.h"
#import "WSYLevelViewController.h"
#import "WSYTravelsViewController.h"
#import "WSYQuestionViewController.h"
#import "WSYCommentViewController.h"
#import "WSYVideosViewController.h"
#import "WSYFriendsListViewController.h"
#import "WSYVisitViewController.h"
#import "WSYPersonalInfoViewController.h"

// Models

// Views
#import "WSYMyInfoHeadView.h"
// Vendors
#import "LEEAlert.h"

//@interface ZJCustomGestureTableView : UITableView
//
//
//@end
//
//@implementation ZJCustomGestureTableView
//
///// 返回YES同时识别多个手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
//}
//
//@end

@interface WSYMyInfoViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (strong, nonatomic) HFStretchableTableHeaderView* stretchableTableHeaderView;
@property (strong, nonatomic) WSYMyInfoHeadView *headView;

@end


@implementation WSYMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
}

- (void)setUpUI {
    @weakify(self);
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_whiteMore"]];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_whiteBack"]];
    self.customNavBar.onClickRightButton = ^{
        @strongify(self);
        [self showAlert];
    };

    [self.view addSubview:self.tableView];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
    _headView = [[WSYMyInfoHeadView alloc]initWithFrame:(CGRect){0, 0, kScreenWidth, IMAGE_HEIGHT + 120}];
    _headView.myHeadBtnClickBlock = ^{
        
    };
    _headView.myLevelBtnClickBlock = ^{
        @strongify(self);
        WSYLevelViewController *vc = [WSYLevelViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myFollowBtnClickBlock = ^{
        @strongify(self);
        WSYFriendsListViewController *vc = [WSYFriendsListViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myFansBtnClickBlock = ^{
        @strongify(self);
        WSYFriendsListViewController *vc = [WSYFriendsListViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myTravelsBtnClickBlock = ^{
        @strongify(self);
        WSYTravelsViewController *vc = [WSYTravelsViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myQuestionBtnClickBlock = ^{
        @strongify(self);
        WSYQuestionViewController *vc = [WSYQuestionViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myCommentBtnClickBlock = ^{
        @strongify(self);
        WSYCommentViewController *vc = [WSYCommentViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myVideosBtnClickBlock = ^{
        @strongify(self);
        WSYVideosViewController *vc = [WSYVideosViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _headView.myVisitsBtnClickBlock = ^{
        @strongify(self);
        WSYVisitViewController *vc = [WSYVisitViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    
    //下拉放大
    _stretchableTableHeaderView = [HFStretchableTableHeaderView new];
    [_stretchableTableHeaderView stretchHeaderForTableView:self.tableView withView:self.headView];
}

-(void)showAlert {
    @weakify(self);
    [LEEAlert actionsheet].config
    .LeeOpenAnimationDuration(0.5f)
    .LeeDestructiveAction(@"编辑个人信息", ^{
        @strongify(self);
        WSYVisitViewController *vc = [WSYVisitViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    })
    .LeeCloseAnimationDuration(0.5f)
    .LeeDestructiveAction(@"分享", ^{
        
    })
    .LeeDestructiveAction(@"取消", ^{
        
    })
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadius(0.0f) // 设置圆角曲率为0
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

#pragma mark ============UIScrollViewDelegate============

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y ;
    if (offsetY > NAV_HEIGHT) {
        self.customNavBar.title = @"王世勇";
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT ) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_blackBack"]];
        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_blackMore"]];
        [self.customNavBar wr_setBottomLineHidden:NO];
    } else {
        [self.customNavBar wr_setBackgroundAlpha:0];
        self.customNavBar.title = nil;
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_whiteBack"]];
        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_whiteMore"]];
        [self.customNavBar wr_setBottomLineHidden:YES];
    }
    
    [_stretchableTableHeaderView scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews {
    [_stretchableTableHeaderView resizeView];
}

#pragma mark ============UITableViewDelegate, UITableViewDataSource============

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"1231231";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ============懒加载============

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = (CGRect){0, 0 , kScreenWidth, kScreenHeight};
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tableFooterView = [UIView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = false;
//        tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
        _tableView = tableView;
    }

    return _tableView;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, IMAGE_HEIGHT}];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.image = [UIImage imageNamed:@"M_personalBG"];
        _headImageView.userInteractionEnabled = YES;
    }
    return _headImageView;
}


@end
