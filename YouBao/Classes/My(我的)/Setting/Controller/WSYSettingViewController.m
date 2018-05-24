//
//  WSYSettingViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/22.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYSettingViewController.h"

// Controllers
#import "WSYCityPickerViewController.h"

@interface WSYSettingViewController ()<WSYCityPickerDelegate>

@end

#define WSYCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@implementation WSYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"111" object:nil]subscribeNext:^(id x){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        SJStaticTableviewCellViewModel *viewModel = [self.dataSource tableView:self.tableView cellViewModelAtIndexPath:indexPath];
        
        if (viewModel) {
            viewModel.indicatorLeftTitle = [WSYUserDataTool getUserData:CITY_NAME];
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDataSource
{
    self.dataSource = [[SJStaticTableViewDataSource alloc] initWithViewModelsArray:[Factory settingPageData] configureBlock:^(SJStaticTableViewCell *cell, SJStaticTableviewCellViewModel *viewModel) {
        
        switch (viewModel.staticCellType) {
                
            case SJStaticCellTypeSystemAccessoryDisclosureIndicator:
            {
//                if (viewModel.identifier == 3) {
//                    viewModel.indicatorLeftTitle = [NSString stringWithFormat:@"%.2fM",[self getCashes]];
//                }
                [cell configureAccessoryDisclosureIndicatorCellWithViewModel:viewModel];
            }
                break;
                
            case SJStaticCellTypeSystemLogout:
            {
                [cell configureLogoutTableViewCellWithViewModel:viewModel];
//                cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Nav_bg"]];
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void)didSelectViewModel:(SJStaticTableviewCellViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath
{
    
    switch (viewModel.identifier)
    {
        case 2:
        {
            WSYCityPickerViewController *vc = [WSYCityPickerViewController new];
            vc.delegate = self;
            vc.customNavBar.title = @"城市选择";
            vc.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
//            [self.navigationController hh_pushBackViewController:vc];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;

            
        default:
            break;
    }
}

#pragma mark ============WSYCityPickerDelegate============

- (void)cityPickerController:(WSYCityPickerViewController *)cityPickerViewController didSelectCity:(WSYCityModel *)city {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    SJStaticTableviewCellViewModel *viewModel = [self.dataSource tableView:self.tableView cellViewModelAtIndexPath:indexPath];
    
    if (viewModel) {
        viewModel.indicatorLeftTitle = city.cityName;
        NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
    }
    [WSYUserDataTool setUserData:city.cityName forKey:CITY_NAME];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
