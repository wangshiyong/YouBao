//
//  WSYDestinationViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/2.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYDestinationViewController.h"

// Views
#import "WSYDestinationHeadView.h"

static NSString *const WSYDestinationHeadID = @"WSYDestinationHeadID";

@interface WSYDestinationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;

@end

@implementation WSYDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
    @weakify(self);
    _collectionView.mj_header = [WSYRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.collectionView.mj_header endRefreshing];
    }];
    [_collectionView.mj_header beginRefreshing];
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
    
//    [self.collectionView addSubview:self.advView];
    [self.view addSubview:self.collectionView];
    [self.view insertSubview:self.customNavBar aboveSubview:self.collectionView];
}

#pragma mark ============UICollectionViewDataSource============
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    WSYDestinationHeadView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSYDestinationHeadID forIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        WSYDestinationHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYDestinationHeadID forIndexPath:indexPath];
        reusableview = headView;
    }
    return reusableview;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 230);
}

#pragma mark ============懒加载============

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - TABBAR_HEIGHT} collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
//        [_collectionView registerClass:[WSYMyServiceItemCell class] forCellWithReuseIdentifier:WSYMyServiceItemCellID];
        //头部
//        [_collectionView registerClass:[WSYDestinationHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYDestinationHeadID];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WSYDestinationHeadView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WSYDestinationHeadID];
        //        //尾部
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WSYCollectionReusableViewID]; //分割线
         //cell
         [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

@end
