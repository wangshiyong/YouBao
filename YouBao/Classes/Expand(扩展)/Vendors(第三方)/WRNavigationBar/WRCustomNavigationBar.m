//
//  WRCustomNavigationBar.m
//  CodeDemo
//
//  Created by wangrui on 2017/10/22.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "WRCustomNavigationBar.h"
#import "sys/utsname.h"

#define kWRDefaultTitleSize 18
#define kWRDefaultTitleColor [UIColor blackColor]
#define kWRDefaultBackgroundColor [UIColor whiteColor]
#define kWRScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation UIViewController (WRRoute)

- (void)wr_toLastViewController
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (UIViewController*)wr_currentViewController {
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self wr_currentViewControllerFrom:rootViewController];
}

+ (UIViewController*)wr_currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self wr_currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self wr_currentViewControllerFrom:tabBarController.selectedViewController];
    }
    else if (viewController.presentedViewController != nil) {
        return [self wr_currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}

@end

@interface WRCustomNavigationBar ()
@property (nonatomic, strong) UILabel     *titleLable;
//@property (nonatomic, strong) UIButton    *leftButton;
//@property (nonatomic, strong) UIButton    *rightButton;
@property (nonatomic, strong) UIView      *bottomLine;
@property (nonatomic, strong) UIView      *backgroundView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@end

@implementation WRCustomNavigationBar

+ (instancetype)CustomNavigationBar {
    WRCustomNavigationBar *navigationBar = [[self alloc] initWithFrame:CGRectMake(0, 0, kWRScreenWidth, [WRCustomNavigationBar navBarBottom])];
    return navigationBar;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    [self addSubview:self.backgroundView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.leftButton];
    [self addSubview:self.titleLable];
    [self addSubview:self.rightButton];
    [self addSubview:self.rightButton1];
    [self addSubview:self.rightButton2];
    [self addSubview:self.bottomLine];
    [self addSubview:self.searchButton];
    [self updateFrame];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = kWRDefaultBackgroundColor;
}

// TODO:这边结合 WRCellView 会不会更好呢？
-(void)updateFrame {
    NSInteger top = ([WRCustomNavigationBar isIphoneX]) ? 44 : 20;
    NSInteger margin = 10;
    NSInteger buttonHeight = 44;
    NSInteger buttonWidth = 44;
    NSInteger titleLabelHeight = 44;
    NSInteger titleLabelWidth = 180;

    self.backgroundView.frame = self.bounds;
    self.backgroundImageView.frame = self.bounds;
    self.leftButton.frame = CGRectMake(margin - 3 , top, buttonWidth, buttonHeight);
    self.rightButton.frame = CGRectMake(kWRScreenWidth - buttonWidth - margin*2, top, buttonWidth + margin*2, buttonHeight);
    self.rightButton1.frame = CGRectMake(kWRScreenWidth - buttonWidth*2 - margin*5, top, buttonWidth + margin*2, buttonHeight);
    self.rightButton2.frame = CGRectMake(kWRScreenWidth - buttonWidth*3 - margin*8, top, buttonWidth + 20, buttonHeight);
    self.titleLable.frame = CGRectMake((kWRScreenWidth - titleLabelWidth) / 2, top, titleLabelWidth, titleLabelHeight);
    self.bottomLine.frame = CGRectMake(0, (CGFloat)(self.bounds.size.height-0.5), kWRScreenWidth, 0.5);
    self.searchButton.frame = CGRectMake(75, top + 4, kWRScreenWidth - 150, buttonHeight - 8);
    self.searchButton.layer.cornerRadius = (buttonHeight - 8)/2;
}

#pragma mark - 导航栏左右按钮事件
-(void)clickBack {
    if (self.onClickLeftButton) {
        self.onClickLeftButton();
    } else {
        UIViewController *currentVC = [UIViewController wr_currentViewController];
        [currentVC wr_toLastViewController];
    }
}
-(void)clickRight {
    if (self.onClickRightButton) {
        self.onClickRightButton();
    }
}

- (void)wr_setBottomLineHidden:(BOOL)hidden {
    self.bottomLine.hidden = hidden;
}

- (void)wr_setBackgroundAlpha:(CGFloat)alpha {
    self.backgroundView.alpha = alpha;
    self.backgroundImageView.alpha = alpha;
    self.bottomLine.alpha = alpha;
}

- (void)wr_setTintColor:(UIColor *)color {
    [self.leftButton setTitleColor:color forState:UIControlStateNormal];
    [self.rightButton setTitleColor:color forState:UIControlStateNormal];
    [self.titleLable setTextColor:color];
}

#pragma mark - 左右按钮
- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.leftButton.hidden = NO;
    [self.leftButton setImage:normal forState:UIControlStateNormal];
    [self.leftButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)wr_setLeftButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setLeftButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
}
- (void)wr_setLeftButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
    [self wr_setLeftButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
}
- (void)wr_setLeftButtonWithImage:(UIImage *)image {
    [self wr_setLeftButtonWithNormal:image highlighted:image title:nil titleColor:nil];
}
- (void)wr_setLeftButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setLeftButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
}

- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.rightButton.hidden = NO;
    [self.rightButton setImage:normal forState:UIControlStateNormal];
    [self.rightButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)wr_setRightButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setRightButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
}
- (void)wr_setRightButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
    [self wr_setRightButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
}
- (void)wr_setRightButtonWithImage:(UIImage *)image {
    [self wr_setRightButtonWithNormal:image highlighted:image title:nil titleColor:nil];
}
- (void)wr_setRightButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setRightButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
}

//右按钮1
- (void)wr_setRightButton1WithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.rightButton1.hidden = NO;
    [self.rightButton1 setImage:normal forState:UIControlStateNormal];
    [self.rightButton1 setImage:highlighted forState:UIControlStateHighlighted];
    [self.rightButton1 setTitle:title forState:UIControlStateNormal];
    [self.rightButton1 setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)wr_setRightButton1WithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setRightButton1WithNormal:image highlighted:image title:title titleColor:titleColor];
}

//右按钮2
- (void)wr_setRightButton2WithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.rightButton2.hidden = NO;
    [self.rightButton2 setImage:normal forState:UIControlStateNormal];
    [self.rightButton2 setImage:highlighted forState:UIControlStateHighlighted];
    [self.rightButton2 setTitle:title forState:UIControlStateNormal];
    [self.rightButton2 setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)wr_setRightButton2WithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setRightButton2WithNormal:image highlighted:image title:title titleColor:titleColor];
}

#pragma mark - 搜索按钮
- (void)wr_setSearchButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted title:(NSString *)title titleColor:(UIColor *)titleColor {
    self.searchButton.hidden = NO;
    [self.searchButton setImage:normal forState:UIControlStateNormal];
    [self.searchButton setImage:highlighted forState:UIControlStateHighlighted];
    [self.searchButton setTitle:title forState:UIControlStateNormal];
    [self.searchButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)wr_setSearchButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setSearchButtonWithNormal:image highlighted:image title:title titleColor:titleColor];
}
- (void)wr_setSearchButtonWithNormal:(UIImage *)normal highlighted:(UIImage *)highlighted {
    [self wr_setSearchButtonWithNormal:normal highlighted:highlighted title:nil titleColor:nil];
}
- (void)wr_setSearchButtonWithImage:(UIImage *)image {
    [self wr_setSearchButtonWithNormal:image highlighted:image title:nil titleColor:nil];
}
- (void)wr_setSearchButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self wr_setSearchButtonWithNormal:nil highlighted:nil title:title titleColor:titleColor];
}

#pragma mark - setter
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.hidden = NO;
    self.titleLable.text = _title;
}
- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    self.titleLable.textColor = _titleLabelColor;
}
- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    _titleLabelFont = titleLabelFont;
    self.titleLable.font = _titleLabelFont;
}
-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    self.backgroundImageView.hidden = YES;
    _barBackgroundColor = barBackgroundColor;
    self.backgroundView.hidden = NO;
    self.backgroundView.backgroundColor = _barBackgroundColor;
}
- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    self.backgroundView.hidden = YES;
    _barBackgroundImage = barBackgroundImage;
    self.backgroundImageView.hidden = NO;
    self.backgroundImageView.image = _barBackgroundImage;
}

#pragma mark - getter
-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.imageView.contentMode = UIViewContentModeCenter;
        _leftButton.titleLabel.font = WSYFont(16);
        _leftButton.hidden = YES;
    }
    return _leftButton;
}
-(UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.imageView.contentMode = UIViewContentModeCenter;
        _rightButton.titleLabel.font = WSYFont(16);
        _rightButton.hidden = YES;
    }
    return _rightButton;
}
-(UIButton *)rightButton1 {
    if (!_rightButton1) {
        _rightButton1 = [[UIButton alloc] init];
        [_rightButton1 addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        _rightButton1.imageView.contentMode = UIViewContentModeCenter;
        _rightButton1.titleLabel.font = WSYFont(16);
        _rightButton1.hidden = YES;
    }
    return _rightButton1;
}
-(UIButton *)rightButton2 {
    if (!_rightButton2) {
        _rightButton2 = [[UIButton alloc] init];
        [_rightButton2 addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        _rightButton2.imageView.contentMode = UIViewContentModeCenter;
        _rightButton2.titleLabel.font = WSYFont(16);
        _rightButton2.hidden = YES;
    }
    return _rightButton2;
}
-(UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] init];
        [_searchButton addTarget:self action:@selector(clickRight) forControlEvents:UIControlEventTouchUpInside];
        [_searchButton setBackgroundColor:[UIColor whiteColor]];
        _searchButton.imageView.contentMode = UIViewContentModeCenter;
        _searchButton.titleLabel.font = WSYFont(15);
        _searchButton.hidden = YES;
    }
    return _searchButton;
}
-(UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = kWRDefaultTitleColor;
        _titleLable.font = [UIFont systemFontOfSize:kWRDefaultTitleSize];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.hidden = YES;
        _titleLable.font = WSYFont(16);
    }
    return _titleLable;
}
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:(CGFloat)(218.0/255.0) green:(CGFloat)(218.0/255.0) blue:(CGFloat)(218.0/255.0) alpha:1.0];
    }
    return _bottomLine;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}
-(UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.hidden = YES;
    }
    return _backgroundImageView;
}

+ (int)navBarBottom {
    return 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}
+ (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // judgment by height when in simulators
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}

@end


















