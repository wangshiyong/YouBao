//
//  WSYEditTravelsViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/16.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYEditTravelsViewController.h"

// Controllers
#import "WSYTravelsTitleViewController.h"
#import "WSYAddWordsViewController.h"
// Views
#import "WSYMyTravelsFirstView.h"
// Categorys
#import "UIButton+Layout.h"

@interface WSYEditTravelsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WSYMyTravelsFirstView *firstView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WSYEditTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self bindUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI {
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"N_millcolorGrad"];
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_error"]];
    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"N_right"] title:@"发表" titleColor:[UIColor whiteColor]];
    [self.customNavBar wr_setRightButton1WithImage:[UIImage imageNamed:@"N_save"] title:@"保存" titleColor:[UIColor whiteColor]];
    [self.customNavBar wr_setRightButton2WithImage:[UIImage imageNamed:@"N_sort"] title:@"排序" titleColor:[UIColor whiteColor]];
    
    @weakify(self);
    _firstView = [[WSYMyTravelsFirstView alloc]initWithFrame:(CGRect){0, NAV_HEIGHT, kScreenWidth ,kScreenWidth - NAV_HEIGHT}];
    _firstView.addWordsBtnClickBlock = ^{
        @strongify(self);
        WSYAddWordsViewController *vc = [WSYAddWordsViewController new];
        [self.navigationController hh_pushBackViewController:vc];
    };
    _firstView.titleBtnClickBlock = ^{
        @strongify(self);
        WSYTravelsTitleViewController *vc = [WSYTravelsTitleViewController new];
        vc.isSave = YES;
        [self.navigationController hh_pushBackViewController:vc];
    };
    [self.view addSubview:_firstView];
    
//    [self.view addSubview:self.tableView];
}

- (void)bindUI {
//    @weakify(self);
//    [[self.addMusicBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
//        @strongify(self);
//        WSYTravelsTitleViewController *vc = [WSYTravelsTitleViewController new];
//        vc.isSave = YES;
//        [self.navigationController hh_pushBackViewController:vc];
//    }];
//
//    UITapGestureRecognizer *recognizer = [UITapGestureRecognizer new];
//    [recognizer.rac_gestureSignal subscribeNext:^(id x){
//        @strongify(self);
//        WSYTravelsTitleViewController *vc = [WSYTravelsTitleViewController new];
//        vc.isSave = YES;
//        [self.navigationController hh_pushBackViewController:vc];
//    }];
//    [self.bgView addGestureRecognizer:recognizer];
}

#pragma mark ==========Table view data source==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"22222";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ============懒加载============

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, NAV_HEIGHT + 200, kScreenWidth, kScreenHeight - NAV_HEIGHT - 200} style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
