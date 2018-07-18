//
//  WSYMyTravelsViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/6.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYMyTravelsViewController.h"

#import "WSYTravelsTitleViewController.h"

@interface WSYMyTravelsViewController ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation WSYMyTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    @weakify(self);
    self.tableView.mj_header = [WSYRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.customNavBar.title = @"我的游记";
    [self.customNavBar wr_setRightButtonWithTitle:@"草稿" titleColor:[UIColor blackColor]];
    self.customNavBar.onClickRightButton = ^{
        @strongify(self);
        WSYTravelsTitleViewController *vc = [WSYTravelsTitleViewController new];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:vc animated:YES completion:nil];
    };
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
}

#pragma mark ==========Table view data source==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ============DZNEmptyDataSetSource Methods============

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"这里暂时还没有内容";
    
    font = [UIFont boldSystemFontOfSize:17.0];
    textColor = [UIColor colorWithHex:@"25282b"];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = nil;
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    UIColor *textColor = [UIColor colorWithHex:@"7b8994"];;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"愿你在每一片一望无际的田野上，清风里都参着淡淡麦香";
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"P_placeholder"];
}

//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIColor colorWithHex:@"f0f3f5"];
//}

#pragma mark ============DZNEmptyDataSetDelegate Methods============

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark ============懒加载============

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = (CGRect){0, NAV_HEIGHT , kScreenWidth, kScreenHeight - NAV_HEIGHT};
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.tableFooterView = [UIView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        tableView.showsVerticalScrollIndicator = false;
        //        tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT, 0, 0, 0);
        _tableView = tableView;
    }
    return _tableView;
}

@end
