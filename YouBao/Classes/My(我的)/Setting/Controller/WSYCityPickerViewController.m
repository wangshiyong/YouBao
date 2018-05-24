//
//  WSYCityPickerViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYCityPickerViewController.h"
// Views
#import "WSYCityGroupCell.h"
#import "WSYCityHeaderView.h"
// Models

// Vendors
#import "UITableView+SCIndexView.h"
#import "PYSearch.h"

@interface WSYCityPickerViewController ()<UITableViewDataSource, UITableViewDelegate, WSYCityGroupCellDelegate, PYSearchViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) NSMutableArray *arraySection;
@property (nonatomic, strong) NSMutableArray *hotCityData;

@end

@implementation WSYCityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSYCityHeaderView *headView = [[WSYCityHeaderView alloc]initWithFrame:(CGRect){0, NAV_HEIGHT, kScreenWidth, 80}];
    [self.view addSubview:headView];
    [self.view addSubview:self.tableView];
    self.customNavBar.leftButton.hidden = YES;
    [self.customNavBar wr_setRightButtonWithTitle:@"取消" titleColor:WSYColor(17, 174, 243)];
    @weakify(self);
    self.customNavBar.onClickRightButton = ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    headView.cityBtnClickBlock = ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    headView.searchBtnClickBlock = ^{
        @strongify(self);
        NSMutableArray *hotSeaches = [NSMutableArray array];
        
        for (int i = 0; i < self.hotCityData.count; i++) {
            WSYCityModel *city = [self.hotCityData objectAtIndex:i];
            [hotSeaches addObject:city.cityName];
        }
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索城市" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            if ([searchText containsString:@"市"]) {
                [WSYUserDataTool setUserData:searchText forKey:CITY_NAME];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"111" object:nil];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];

        searchViewController.hotSearchStyle = 4;
        searchViewController.searchHistoryStyle = 2;
        searchViewController.delegate = self;
        searchViewController.searchResultShowMode = PYSearchResultShowModePush;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [self presentViewController:nav animated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============PYSearchViewControllerDelegate============

- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    if (searchText.length) {
        NSMutableArray *searchSuggestionsM = [NSMutableArray array];
        for (WSYCityModel *city in self.cityData){
            if ([city.cityName containsString:searchText] || [city.pinyin containsString:searchText] || [city.initials containsString:searchText]) {
                [searchSuggestionsM addObject:city.cityName];
            }
        }
        searchViewController.searchSuggestions = searchSuggestionsM;
    }
}

#pragma mark ============UITableViewDataSource============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    WSYCityGroupModel *group = self.data[section - 1];
    return group.arrayCitys.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [WSYCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"Cell";
        WSYCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[WSYCityGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setCityArray:self.hotCityData];
        cell.delegate = self;
        return cell;
    } else {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        WSYCityGroupModel *group = self.data[indexPath.section - 1];
        WSYCityModel *city = group.arrayCitys[indexPath.row];
        cell.textLabel.text = city.cityName;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.arraySection[section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark ============UITableViewDelegate============

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    WSYCityGroupModel *group = self.data[indexPath.section - 1];
    WSYCityModel *city = group.arrayCitys[indexPath.row];
    [self didSelctedCity:city];
}

#pragma mark ============WSYCityGroupCellDelegate============

- (void)cityGroupCellDidSelectCity:(WSYCityModel *)city {
    [self didSelctedCity:city];
}

- (void)didSelctedCity:(WSYCityModel *)city {
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
}

#pragma mark ============懒加载============

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, NAV_HEIGHT + 80, kScreenWidth, kScreenHeight - NAV_HEIGHT - 80} style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.sectionIndexColor = [UIColor redColor];
        
        SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
        configuration.indexItemSelectedBackgroundColor = WSYColor(17, 174, 243);
        _tableView.sc_indexViewConfiguration = configuration;
    }
    return _tableView;
}

- (NSMutableArray *) data {
    if (!_data) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        _data = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            WSYCityGroupModel *group = [[WSYCityGroupModel alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                WSYCityModel *city = [[WSYCityModel alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [group.arrayCitys addObject:city];
                [self.cityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_data addObject:group];
        }
        NSMutableArray *indexArray = [NSMutableArray arrayWithArray:self.arraySection];
        [self.arraySection insertObject:@"热门城市" atIndex:0];
        [indexArray insertObject:@"热" atIndex:0];
        self.tableView.sc_indexViewDataSource = indexArray;
    }
    return _data;
}

- (NSMutableArray *) arraySection {
    if (!_arraySection) {
        _arraySection = [[NSMutableArray alloc] init];
    }
    return _arraySection;
}

- (NSMutableArray *) cityData {
    if (!_cityData) {
        _cityData = [[NSMutableArray alloc] init];
    }
    return _cityData;
}

- (NSMutableArray *) hotCityData {
    if (!_hotCityData) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            WSYCityModel *city = nil;
            for (WSYCityModel *item in self.cityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            } else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

@end
