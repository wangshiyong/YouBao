//
//  AppDelegate.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "AppDelegate.h"
#import "WSYTabBarControllerConfig.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <PPNetworkHelper/PPNetworkHelper.h>

@interface AppDelegate ()<UITabBarControllerDelegate, CYLTabBarControllerDelegate, CLLocationManagerDelegate, WXApiDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpRootVC];
    [self setUpFixiOS11]; //适配IOS 11
    [self startLocation];
    [self monitorNetworkStatus]; // 实时监测网络状态
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    [WXApi handleOpenURL:url delegate:self];
    return  YES;
}
    
- (void)onReq:(BaseReq *)req {
    NSLog(@"--->%s wxapi onreq:%@",__func__,req);
}
    
- (void)onResp:(BaseResp *)resp {
    NSLog(@"--->%s wxapi onresp:%@",__func__,resp);
}
    
#pragma mark ==========适配==========
    
- (void)setUpFixiOS11 {
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}

#pragma mark - 实时监测网络状态
- (void)monitorNetworkStatus {
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                // 无网络
            case PPNetworkStatusNotReachable:
                [self.window.rootViewController showHUDWindow:@"无网络连接"];
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                [self.window.rootViewController showHUDWindow:@"移动(3G/4G)网络已连接"];
                break;
            case PPNetworkStatusReachableViaWiFi:
                [self.window.rootViewController showHUDWindow:@"Wi-Fi网络已连接"];
                break;
        }
    }];
}

#pragma mark ==========私有方法==========
    
- (void)setUpRootVC {
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    //    [CYLPlusButtonSubclass registerPlusButton];
    WSYTabBarControllerConfig *tabBarControllerConfig = [[WSYTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    
    tabBarController.delegate = self;
    [self.window makeKeyAndVisible];
    [self customizeInterfaceWithTabBarController:tabBarController];
}
    
- (void)customizeInterfaceWithTabBarController:(CYLTabBarController *)tabBarController {
    //设置导航栏
    [self setUpNavigationBarAppearance];
    
    [tabBarController hideTabBadgeBackgroundSeparator];
    //添加小红点
    UIViewController *viewController = tabBarController.viewControllers[0];
    UIView *tabBadgePointView0 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    [viewController.tabBarItem.cyl_tabButton cyl_setTabBadgePointView:tabBadgePointView0];
    [viewController cyl_showTabBadgePoint];
    
    UIView *tabBadgePointView1 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
    @try {
        [tabBarController.viewControllers[1] cyl_setTabBadgePointView:tabBadgePointView1];
        [tabBarController.viewControllers[1] cyl_showTabBadgePoint];
        
        UIView *tabBadgePointView2 = [UIView cyl_tabBadgePointViewWithClolor:RANDOM_COLOR radius:4.5];
        [tabBarController.viewControllers[2] cyl_setTabBadgePointView:tabBadgePointView2];
        [tabBarController.viewControllers[2] cyl_showTabBadgePoint];
        
        [tabBarController.viewControllers[3] cyl_showTabBadgePoint];
        
        //添加提示动画，引导用户点击
        [self addScaleAnimationOnView:tabBarController.viewControllers[3].cyl_tabButton.cyl_tabImageView repeatCount:20];
    } @catch (NSException *exception) {}
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
//    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
//
//    UIImage *backgroundImage = nil;
//    NSDictionary *textAttributes = nil;
//    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
//
//        textAttributes = @{
//                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
//                           NSForegroundColorAttributeName : [UIColor blackColor],
//                           };
//    } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
//        textAttributes = @{
//                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
//                           UITextAttributeTextColor : [UIColor blackColor],
//                           UITextAttributeTextShadowColor : [UIColor clearColor],
//                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
//                           };
//#endif
//    }
//
//    [navigationBarAppearance setBackgroundImage:backgroundImage
//                                  forBarMetrics:UIBarMetricsDefault];
//    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


#pragma mark ==========delegate==========

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [[self cyl_tabBarController] updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        //更改红标状态
        if ([[self cyl_tabBarController].selectedViewController cyl_isShowTabBadgePoint]) {
            [[self cyl_tabBarController].selectedViewController cyl_removeTabBadgePoint];
        } else {
            [[self cyl_tabBarController].selectedViewController cyl_showTabBadgePoint];
        }
        
        animationView = [control cyl_tabImageView];
    }
    
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if ([control cyl_isPlusButton]) {
        UIButton *button = CYLExternPlusButton;
        animationView = button.imageView;
    }
    
    if ([self cyl_tabBarController].selectedIndex % 2 == 0) {
        [self addScaleAnimationOnView:animationView repeatCount:1];
    } else {
        [self addRotateAnimationOnView:animationView];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

#pragma mark============定位============
//开始定位
- (void)startLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}
    
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = locations[0];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"%@",placemark.country);
            
            [WSYUserDataTool setUserData:city forKey:GPS_CITY];
            
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

    
@end
