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
#import "WSYPersonalInfoViewController.h"
// Vendors
//#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface WSYSettingViewController ()<WSYCityPickerDelegate>

@end

#define WSYCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

@implementation WSYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:SELECT_CITY_NOTICE object:nil]subscribeNext:^(id x){
        @strongify(self);
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

- (void)createDataSource {
    self.dataSource = [[SJStaticTableViewDataSource alloc] initWithViewModelsArray:[Factory settingPageData] configureBlock:^(SJStaticTableViewCell *cell, SJStaticTableviewCellViewModel *viewModel) {
        switch (viewModel.staticCellType) {
                
            case SJStaticCellTypeSystemAccessoryDisclosureIndicator:
            {
                if (viewModel.identifier == 6) {
                    viewModel.indicatorLeftTitle = [NSString stringWithFormat:@"%.2fM",[self getCashes]];
                }
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

- (void)didSelectViewModel:(SJStaticTableviewCellViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
    if ([[WSYUserDataTool getUserData:USER_LOGIN] integerValue] == 1 ) {
        switch (viewModel.identifier)
        {
            case 1:
            {
                WSYPersonalInfoViewController *vc = [WSYPersonalInfoViewController new];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
                break;
                
            case 2:
            {
                WSYCityPickerViewController *vc = [WSYCityPickerViewController new];
                vc.delegate = self;
                vc.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
                //            [self.navigationController hh_pushBackViewController:vc];
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
                
            case 6:
            {
                [self cleanCaches];
            }
                break;
                
            case 8:
            {
                [self share];
            }
                break;
                
            case 12:
            {
                [self logout];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (viewModel.identifier)
        {
            case 6:
            {
                [self cleanCaches];
            }
                break;
                
            case 8:
            {
                [self share];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark ============事件响应============

- (void)logout {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              @strongify(self);
                                                              [WSYUserDataTool removeUserData:USER_LOGIN];
                                                              [WSYUserDataTool removeUserData:USER_ICON];
                                                              [WSYUserDataTool removeUserData:USER_NICKNAME];
                                                              [ShareSDK cancelAuthorize:(SSDKPlatformType)[WSYUserDataTool getUserData:USER_TYPE]];
                                                              [[NSNotificationCenter defaultCenter]postNotificationName:LOGOUT_NOTICE object:nil];
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 清理缓存
 */
-(void)cleanCaches{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"清理缓存"
                                                                   message:[NSString stringWithFormat:@"缓存大小为%.2fM,确定要删除所有缓存吗？", [self getCashes]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              @strongify(self);
                                                              [self okTapBtn];
                                                              [self showSuccessHUD:@"清理完成"];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)okTapBtn {
    NSString *path = WSYCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    if ([[WSYUserDataTool getUserData:USER_LOGIN] integerValue] == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        
        //获取cell对应的viewModel
        SJStaticTableviewCellViewModel *viewModel = [self.dataSource tableView:self.tableView cellViewModelAtIndexPath:indexPath];
        
        if (viewModel) {
            viewModel.indicatorLeftTitle = [NSString stringWithFormat:@"%.2fM",[self getCashes]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        //获取cell对应的viewModel
        SJStaticTableviewCellViewModel *viewModel = [self.dataSource tableView:self.tableView cellViewModelAtIndexPath:indexPath];
        
        if (viewModel) {
            viewModel.indicatorLeftTitle = [NSString stringWithFormat:@"%.2fM",[self getCashes]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(float)getCashes{
    NSString *path = WSYCachesPath;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fullPath];
        }
    }
    return folderSize;
}

-(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

- (void)share{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"D45" ofType:@"jpg"]];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:imageArray
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeImage];
    //优先使用平台客户端分享
    [shareParams SSDKEnableUseClientShare];
    //设置微博使用高级接口
    //2017年6月30日后需申请高级权限
    //    [shareParams SSDKEnableAdvancedInterfaceShare];
    //    设置显示平台 只能分享视频的YouTube MeiPai 不显示
    //    NSArray *items = @[
    //                       @(SSDKPlatformTypeFacebook),
    ////                       @(SSDKPlatformTypeFacebookMessenger),
    ////                       @(SSDKPlatformTypeInstagram),
    ////                       @(SSDKPlatformTypeTwitter),
    //                       @(SSDKPlatformTypeLine),
    //                       @(SSDKPlatformTypeQQ),
    //                       @(SSDKPlatformTypeWechat),
    //                       @(SSDKPlatformTypeSinaWeibo),
    //                       @(SSDKPlatformTypeSMS),
    //                       @(SSDKPlatformTypeMail),
    //                       @(SSDKPlatformTypeCopy)
    //                       ];
    
    //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
    //    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    //    [ShareSDK setWeiboURL:@"http://www.mob.com"];
    [ShareSDK showShareActionSheet:nil
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //设置UI等操作
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformTypeInstagram)
                           {
                               break;
                           }
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSLog(@"%@",error);
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
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
