//
//  WSYMyViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyViewController.h"

// Controllers
#import "WSYSettingViewController.h"
#import "WSYLoginViewController.h"
#import "WSYMyInfoViewController.h"
#import "WSYSignInViewController.h"
#import "WSYNewsViewController.h"
#import "WSYCollectionViewController.h"
#import "WSYDownloadViewController.h"
#import "WSYMyCommentViewController.h"
#import "WSYMyTravelsViewController.h"
// Models
#import "WSYGridItem.h"
#import "WSYUserModel.h"
// Views
#import "WSYHeadView.h"
#import "WSYHeadLoginView.h"
#import "WSYMyServiceItemCell.h"
#import "WSYSigninCell.h"
// Vendors
#import "HyPopMenuView.h"
#import "WRNavigationBar.h"
#import "TZImagePickerController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MOBFoundation/MOBFoundation.h>
// Others


typedef NS_ENUM(NSInteger, WSYPersonalCenterSection) {
    WSYPersonalCenterSectionRecord  = 0,
    WSYPersonalCenterSectionMy      = 1,
    WSYPersonalCenterSectionSetting = 2,
};

static NSString *const WSYSigninCellID = @"WSYSigninCellID";
static NSString *const WSYMyServiceItemCellID = @"WSYMyServiceItemCell";
static NSString *const WSYHeadViewID = @"WSYHeadViewID";
static NSString *const WSYHeadLoginViewID = @"WSYHeadLoginViewID";
static NSString *const WSYCollectionReusableViewID = @"WSYCollectionReusableViewID";

@interface WSYMyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HyPopMenuViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate>{
    BOOL _isAuth;
    NSMutableDictionary *_platforemUserInfos;
}

@property (nonatomic, strong) UICollectionView *collectionView;
/* 服务item */
@property (nonatomic, strong) NSMutableArray<WSYGridItem *> *gridItem;
/* 弹出菜单 */
@property (nonatomic, strong) HyPopMenuView* menu;


@property (nonatomic, strong) NSMutableArray* phoneArray;

@end

@implementation WSYMyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpNav];
    
    //    self.collecionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self.collecionView.mj_header endRefreshing];
    //        });
    //    }];
    //    [self.collecionView.mj_header beginRefreshing];
    _gridItem = [WSYGridItem mj_objectArrayWithFilename:@"MyServiceFlow.plist"];
    
    [self setUpPopMenu];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([[WSYUserDataTool getUserData:USER_LOGIN] integerValue] == 1 ) {
//        [_collectionView registerClass:[WSYHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadViewID];
//    } else {
//        [_collectionView registerClass:[WSYHeadLoginView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadLoginViewID];
//    }
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpNav {
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_setting"].imageForDismissTheme];
    @weakify(self);
    self.customNavBar.onClickLeftButton = ^{
        @strongify(self);
        WSYSettingViewController *vc = [WSYSettingViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_info"].imageForDismissTheme];
    self.customNavBar.onClickRightButton = ^{
        @strongify(self);
        WSYNewsViewController *vc = [WSYNewsViewController new];
        vc.automaticallyCalculatesItemWidths = YES;
        vc.menuViewStyle = WMMenuViewStyleLine;
        vc.progressViewIsNaughty = YES;
        vc.progressWidth = 30;
        
        [self.navigationController hh_pushBackViewController:vc];
    };
    
//    hub = [[RKNotificationHub alloc]initWithView:self.customNavBar.rightButton];
//    [hub moveCircleByX:-10 Y:15];
//    [hub increment];
//    [hub hideCount];
//    self.customNavBar.onClickRightButton = ^{
//        @strongify(self);
//        WSYMessageViewController *vc = [WSYMessageViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    };
    
    [self.view addSubview:self.collectionView];
    [self.view insertSubview:self.customNavBar aboveSubview:self.collectionView];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:LOGIN_SUCESSS_NOTICE object:nil]subscribeNext:^(id x){
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:LOGOUT_NOTICE object:nil]subscribeNext:^(id x){
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:SELECT_CITY_NOTICE object:nil]subscribeNext:^(id x){
        @strongify(self);
        [self.collectionView reloadData];
    }];
}


- (void)setUpPopMenu {
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [PopMenuModel
                           allocPopMenuModelWithImageNameString:@"M_photo"
                           AtTitleString:@"相册/视频"
                           AtTextColor:[UIColor grayColor]
                           AtTransitionType:PopMenuTransitionTypeCustomizeApi
                           AtTransitionRenderingColor:nil];
    
    PopMenuModel* model1 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"M_camera"
                            AtTitleString:@"拍摄/短视频"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model2 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"M_review"
                            AtTitleString:@"写新游记"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
                            AtTransitionRenderingColor:nil];
    
    
    _menu.dataSource = @[model, model1, model2];
    _menu.delegate = self;
    _menu.popMenuSpeed = 10.0f;
    _menu.automaticIdentificationColor = false;
    _menu.animationType = HyPopMenuViewAnimationTypeCenter;
}

#pragma mark ============UICollectionViewDataSource============

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        @weakify(self);
        WSYSigninCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSYSigninCellID forIndexPath:indexPath];
        cell.signInBtnClickBlock = ^{
            @strongify(self);
            WSYSignInViewController *vc = [WSYSignInViewController new];
            [self.navigationController hh_pushBackViewController:vc];
        };
        gridcell = cell;
    } else {
        WSYMyServiceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSYMyServiceItemCellID forIndexPath:indexPath];
        cell.gridItem = _gridItem[indexPath.row];
        gridcell = cell;
    }
    
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            if ([[WSYUserDataTool getUserData:USER_LOGIN] integerValue] == 1 ) {
                WSYHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadViewID forIndexPath:indexPath];
                @weakify(self);
                headView.mytakeBtnClickBlock = ^{
                    @strongify(self);
                    self.menu.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
                    [self.menu openMenu];
                };
                headView.myViewClickBlock = ^{
                    @strongify(self);
                    WSYMyInfoViewController *vc = [WSYMyInfoViewController new];
                    [self.navigationController hh_pushBackViewController:vc];
                };               
                reusableview = headView;
            } else {
                WSYHeadLoginView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadLoginViewID forIndexPath:indexPath];
                @weakify(self);
                headView.myloginBtnClickBlock = ^{
                    @strongify(self);
                    WSYLoginViewController *vc = [[WSYLoginViewController alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                };

                reusableview = headView;
            }
        } else {
            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYCollectionReusableViewID forIndexPath:indexPath];
            headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            reusableview = headView;
        }
    }
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WSYCollectionReusableViewID forIndexPath:indexPath];
//        footview.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        reusableview = footview;
//    }
    
    return reusableview;
}

#pragma mark ============UICollectionViewDelegate============

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了帮组与反馈Item%ld",(long)indexPath.row);
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:
        {
            if (indexPath.row == 0) {
                WSYCollectionViewController *vc = [WSYCollectionViewController new];
                vc.showOnNavigationBar = YES;
                vc.automaticallyCalculatesItemWidths = YES;
                vc.menuViewStyle = WMMenuViewStyleLine;
                vc.progressViewIsNaughty = YES;
                vc.progressWidth = 30;
                [self.navigationController hh_pushBackViewController:vc];
            }else if (indexPath.row == 1) {
                WSYDownloadViewController *vc = [WSYDownloadViewController new];
                vc.automaticallyCalculatesItemWidths = YES;
                vc.menuViewStyle = WMMenuViewStyleLine;
                vc.progressViewIsNaughty = YES;
                vc.progressWidth = 30;
                [self.navigationController hh_pushBackViewController:vc];
            } else if (indexPath.row == 2) {
//                WSYDownloadViewController *vc = [WSYDownloadViewController new];
//                vc.automaticallyCalculatesItemWidths = YES;
//                vc.menuViewStyle = WMMenuViewStyleLine;
//                vc.progressViewIsNaughty = YES;
//                vc.progressWidth = 30;
//                [self.navigationController hh_pushBackViewController:vc];
            } else if (indexPath.row == 3) {
                WSYMyTravelsViewController *vc = [WSYMyTravelsViewController new];
                [self.navigationController hh_pushBackViewController:vc];
            } else if (indexPath.row == 4) {
//                WSYDownloadViewController *vc = [WSYDownloadViewController new];
//                vc.automaticallyCalculatesItemWidths = YES;
//                vc.menuViewStyle = WMMenuViewStyleLine;
//                vc.progressViewIsNaughty = YES;
//                vc.progressWidth = 30;
//                [self.navigationController hh_pushBackViewController:vc];
            } else if (indexPath.row == 5) {
                WSYMyCommentViewController *vc = [WSYMyCommentViewController new];
                vc.automaticallyCalculatesItemWidths = YES;
                vc.menuViewStyle = WMMenuViewStyleLine;
                vc.progressViewIsNaughty = YES;
                vc.progressWidth = 30;
                [self.navigationController hh_pushBackViewController:vc];
            } else if (indexPath.row == 6) {
//                WSYDownloadViewController *vc = [WSYDownloadViewController new];
//                vc.automaticallyCalculatesItemWidths = YES;
//                vc.menuViewStyle = WMMenuViewStyleLine;
//                vc.progressViewIsNaughty = YES;
//                vc.progressWidth = 30;
//                [self.navigationController hh_pushBackViewController:vc];
            }
            
        }
            break;
            

            
        default:
            break;
    }
    if (indexPath.section == 1) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"D45" ofType:@"jpg"]];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeImage];
//        //优先使用平台客户端分享
//        [shareParams SSDKEnableUseClientShare];
//        //设置微博使用高级接口
//        //2017年6月30日后需申请高级权限
//        //    [shareParams SSDKEnableAdvancedInterfaceShare];
//        //    设置显示平台 只能分享视频的YouTube MeiPai 不显示
//        //    NSArray *items = @[
//        //                       @(SSDKPlatformTypeFacebook),
//        ////                       @(SSDKPlatformTypeFacebookMessenger),
//        ////                       @(SSDKPlatformTypeInstagram),
//        ////                       @(SSDKPlatformTypeTwitter),
//        //                       @(SSDKPlatformTypeLine),
//        //                       @(SSDKPlatformTypeQQ),
//        //                       @(SSDKPlatformTypeWechat),
//        //                       @(SSDKPlatformTypeSinaWeibo),
//        //                       @(SSDKPlatformTypeSMS),
//        //                       @(SSDKPlatformTypeMail),
//        //                       @(SSDKPlatformTypeCopy)
//        //                       ];
//
//        //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//        //    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
//        //    [ShareSDK setWeiboURL:@"http://www.mob.com"];
//        [ShareSDK showShareActionSheet:nil
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//
//                           case SSDKResponseStateBegin:
//                           {
//                               //设置UI等操作
//                               break;
//                           }
//                           case SSDKResponseStateSuccess:
//                           {
//                               //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
//                               if (platformType == SSDKPlatformTypeInstagram)
//                               {
//                                   break;
//                               }
//
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               NSLog(@"%@",error);
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           case SSDKResponseStateCancel:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }];
    }
    
}

//item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 50);
    }
    return CGSizeMake(kScreenWidth/3, 100);
}

//X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 240);
    }
    return CGSizeMake(kScreenWidth, 10);
}

//foot宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//    return CGSizeMake(kScreenWidth, 10);
//}

#pragma mark ============UIScrollViewDelegate============

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y ;
    if (offsetY >= 0) {
        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
    } else {
        [self updateNavBarButtonItemsAlphaAnimated:.0f];
    }
    
    if (offsetY > 0) {
        self.customNavBar.title = @"欢迎来到游宝";
        CGFloat alpha = offsetY * 6 / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
    } else {
        self.customNavBar.title = @"";
        [self.customNavBar wr_setBackgroundAlpha:0];
    }
}

- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha {
    [UIView animateWithDuration:0.2 animations:^{
        self.customNavBar.leftButton.alpha = alpha;
        self.customNavBar.rightButton.alpha = alpha;
    }];
}

- (void)popMenuView:(HyPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index {
    WSYSignInViewController *vc = [WSYSignInViewController new];
    [self.navigationController pushViewController:vc animated:false];
}

#pragma mark ============点击事件============

/**
 选择头像
 */
- (void)clickImagePickerVc {
//    [WRNavigationBar wr_setDefaultStatusBarStyle:UIStatusBarStyleDefault];
    [WRNavigationBar wr_setDefaultNavBarBarTintColor:[UIColor whiteColor]];
    [WRNavigationBar wr_setDefaultNavBarTintColor:Color_Wathet];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.statusBarStyle = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.barItemTextColor = Color_Wathet;
//    // 设置竖屏下的裁剪尺寸
//    NSInteger left = 30;
//    NSInteger widthHeight = self.view.wsy_width - 2 * left;
//    NSInteger top = (self.view.wsy_height - widthHeight) / 2;
//    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 你可以通过block或者代理，来得到用户选择的照片.
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        @strongify(self);
        self.phoneArray = [NSMutableArray arrayWithArray:photos];
        [self.collectionView reloadSections:[[NSIndexSet alloc]initWithIndex:0]];
        
        NSString *key = @"?userID=13&imageKind=1";
        [WSYNetworking UploadImageWithKeys:key name:@"HeadIcon" images:photos fileNames:nil imageType:@"png" Success:^(id success){
            NSLog(@"======");
        } failure:^(NSError *error){
            [self showErrorHUD:@"更新失败"];
        }];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark ============懒加载============

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = (CGRect){0, 0, kScreenWidth, kScreenHeight - TABBAR_HEIGHT};
        _collectionView.backgroundColor = [UIColor whiteColor];
    
        [_collectionView registerClass:[WSYHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadViewID];
        [_collectionView registerClass:[WSYHeadLoginView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadLoginViewID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYCollectionReusableViewID];
        
        //尾部
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WSYCollectionReusableViewID]; //分割线
        //cell
        [_collectionView registerClass:[WSYMyServiceItemCell class] forCellWithReuseIdentifier:WSYMyServiceItemCellID];
        [_collectionView registerClass:[WSYSigninCell class] forCellWithReuseIdentifier:WSYSigninCellID];
    }
    return _collectionView;
}

@end
