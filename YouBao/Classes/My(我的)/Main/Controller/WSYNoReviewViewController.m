//
//  WSYNoReviewViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/7/11.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYNoReviewViewController.h"

@interface WSYNoReviewViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation WSYNoReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    @weakify(self);
    self.tableView.mj_header = [WSYRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
