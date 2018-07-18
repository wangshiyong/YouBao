//
//  WSYHomeViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYHomeViewController.h"

// Controllers
// Models
#import "WSYGridItem.h"
// Views
#import "WSYMyServiceItemCell.h"

// Vendors
#import "SDCycleScrollView.h"

static NSString *const WSYHeadViewID = @"WSYHeadViewID";
static NSString *const WSYMyServiceItemCellID = @"WSYMyServiceItemCell";

@interface WSYHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *advView;
/* 服务item */
@property (nonatomic, strong) NSMutableArray<WSYGridItem *> *gridItem;

@end

@implementation WSYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
        });
    }];
    [self.collectionView.mj_header beginRefreshing];
    _gridItem = [WSYGridItem mj_objectArrayWithFilename:@"GoodsGrid.plist"];
    
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@=======",x);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI {
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"P_setting"]];
//    @weakify(self);
    self.customNavBar.onClickLeftButton = ^{
//        @strongify(self);
        //        WSYSettingViewController *vc = [WSYSettingViewController new];
        //        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_info"]];
    self.customNavBar.onClickRightButton = ^{
//        @strongify(self);
        //        WSYMessageViewController *vc = [WSYMessageViewController new];
        //        [self.navigationController pushViewController:vc animated:YES];
    };
    
    [self.customNavBar wr_setSearchButtonWithTitle:@"搜索" titleColor:[UIColor grayColor]];
    
    [self.collectionView addSubview:self.advView];
    [self.view addSubview:_collectionView];
    [self.view insertSubview:self.customNavBar aboveSubview:_collectionView];
}


#pragma mark ============UICollectionViewDataSource============
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WSYMyServiceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSYMyServiceItemCellID forIndexPath:indexPath];
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.gridItem = _gridItem[indexPath.row];
    return cell;
    
}


#pragma mark ============UICollectionViewDelegate============

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了帮组与反馈Item");
}

//item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return CGSizeMake(kScreenWidth/5, 60);
//    }
    return CGSizeMake(kScreenWidth/5, 90);
}

//X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark ============UIScrollViewDelegate============

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y ;
    
//    if (offsetY < -IMAGE_HEIGHT) {
//        [self updateNavBarButtonItemsAlphaAnimated:.0f];
//    } else {
//        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
//    }
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT - IMAGE_HEIGHT) {
        //        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"back"]];
        //        self.customNavBar.title = @"个人信息";
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT + IMAGE_HEIGHT) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        [self.customNavBar.searchButton setBackgroundColor:[UIColor grayColor]];
        //        [self.customNavBar wr_setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        //        [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"navLeft"]];
        //        self.customNavBar.title = @"";
        [self.customNavBar wr_setBackgroundAlpha:0];
        [self.customNavBar.searchButton setBackgroundColor:[UIColor whiteColor]];
        //        [self.customNavBar wr_setTintColor:[UIColor whiteColor]];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

//- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.customNavBar.leftButton.alpha = alpha;
//        self.customNavBar.rightButton.alpha = alpha;
//    }];
//}

#pragma mark ============SDCycleScrollViewDelegate============

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark ============懒加载============

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置尺寸
        //        layout.itemSize = CGSizeMake(kScreenWidth/3 , 60);
        //        layout.minimumLineSpacing = layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc]initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - NAV_HEIGHT - TABBAR_HEIGHT} collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
        
        [_collectionView registerClass:[WSYMyServiceItemCell class] forCellWithReuseIdentifier:WSYMyServiceItemCellID];
        //        //头部
//        [_collectionView registerClass:[SDCycleScrollView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYHeadViewID];
        //        //尾部
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WSYCollectionReusableViewID]; //分割线
        //        //cell
        //        [_collectionView registerClass:[WSYFlowAttributeCell class] forCellWithReuseIdentifier:WSYFlowAttributeCellID];
    }
    return _collectionView;
}

- (SDCycleScrollView *)advView {
    if (_advView == nil) {
        _advView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRect){0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT} delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _advView.imageURLStringsGroup = GoodsHomeSilderImagesArray;
        _advView.pageDotColor = [UIColor grayColor];
        _advView.autoScrollTimeInterval = 2;
        _advView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _advView.currentPageDotColor = [UIColor whiteColor];
        _advView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    }
    return _advView;
}
@end
