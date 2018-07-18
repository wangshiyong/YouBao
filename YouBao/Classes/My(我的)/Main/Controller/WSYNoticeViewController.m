//
//  WSYNoticeViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/6.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYNoticeViewController.h"

@interface WSYNoticeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WSYNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    //    [self.tableView reloadEmptyDataSet];
    
    @weakify(self);
    _tableView.mj_header = [WSYRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============懒加载============

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - NAV_HEIGHT - 44} style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
    
    text = @"愿你在每一个薄暮晨光的早上，都能被阳光亲吻。";
    
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

@end

