//
//  WSYLoginViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYLoginViewController.h"

// Controllers
#import "WSYRegisterViewController.h"
// Models
#import "WSYLoginViewModel.h"
#import "WSYUserModel.h"
// Views
#import "WSYAccountPsdView.h"
#import "WSYVerificationView.h"
// Vendors
#import <YYText/YYText.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "CRToast.h"
// Categories
#import "UIButton+Layout.h"

@interface WSYLoginViewController ()<UIScrollViewDelegate>{
    NSTimer *_timer;
    NSInteger _i;
}

@property (strong , nonatomic)UIView *middleLoginView;
/* 上一次选中的按钮 */
@property (strong , nonatomic)UIButton *selectBtn;
/* indicatorView */
@property (strong , nonatomic)UIView *indicatorView;
/* titleView */
@property (strong , nonatomic)UIView *titleView;
/* contentView */
@property (strong , nonatomic)UIScrollView *contentView;
/* 账号密码登录 */
@property (strong , nonatomic)WSYAccountPsdView *accountPsdView;
/* 验证码 */
@property (strong , nonatomic)WSYVerificationView *verificationView;
@property (strong , nonatomic)UIView *line1;
@property (strong , nonatomic)UIView *line2;
@property (strong , nonatomic)UILabel *otherLab;
/* qq按钮 */
@property (strong , nonatomic)UIButton *qqBtn;
/* 微信按钮 */
@property (strong , nonatomic)UIButton *wechatBtn;
/* 微博按钮 */
@property (strong , nonatomic)UIButton *weiboBtn;
/* 隐私政策 */
@property (strong , nonatomic)YYLabel *privacyLab;
/* 登录模型 */
@property (nonatomic,strong) WSYLoginViewModel *loginModel;

@end

@implementation WSYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpTiTleView];
    [self setUpContentView];
    [self setUpBottomView];
    [self bindAccountModel];
    [self bindUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============绑定监听============

/**
 绑定登录
 */
- (void)bindAccountModel {
    self.loginModel = [[WSYLoginViewModel alloc]init];
    RAC(self.loginModel, userName) = self.accountPsdView.accountText.rac_textSignal;
    RAC(self.loginModel, password) = self.accountPsdView.pwdText.rac_textSignal;
    RAC(self.accountPsdView.loginBtn, enabled) = [self.loginModel validSignal];
    RAC(self.loginModel, phone) = self.verificationView.phoneText.rac_textSignal;
    RAC(self.loginModel, code) = self.verificationView.codeText.rac_textSignal;
    RAC(self.verificationView.loginCodeBtn, enabled) = [self.loginModel validSignalCode];
    RAC(self.verificationView.codeBtn, enabled) = [self.loginModel validSignalCodeBtn];
    
    @weakify(self);
    [self.loginModel.successSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCESSS_NOTICE object:nil];
        [WSYUserDataTool setUserData:@1 forKey:USER_LOGIN];
        [self showSuccessHUDWindow:str];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.loginModel.failureSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [self showErrorHUD:str];
    }];
    
    [self.loginModel.errorSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [self showErrorHUD:str];
    }];
    
    RAC(self.accountPsdView.loginBtn, alpha) = [[self.loginModel validSignal] map:^(NSNumber *b){
        return b.boolValue ? @1: @0.4;
    }];
    [[self.accountPsdView.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self.loginModel loginBtn];
    }];

    
    [self.loginModel.successSubjectGetCode subscribeNext:^(id x){
        @strongify(self);
        [CRToastManager showNotificationWithOptions:[self successOptions]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    [self.loginModel.failureSubjectGetCode subscribeNext:^(id x){
        @strongify(self);
        [CRToastManager showNotificationWithOptions:[self failureOptions]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    [[self.verificationView.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        if ([self isChinaMobile:self.verificationView.phoneText.text]) {
            [self.loginModel getCodeBtn];
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
            self->_i = 60;
        } else {
            [CRToastManager showNotificationWithOptions:[self failureOptions]
                                         apperanceBlock:nil
                                        completionBlock:nil];
        }
    }];
    
    [self.loginModel.successSubjectCode subscribeNext:^(NSString *str){
        @strongify(self);
        NSLog(@"%@=====",str);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self.loginModel.errorSubjectCode subscribeNext:^(NSString *str){
        NSLog(@"%@=====",str);
    }];
    
    RAC(self.verificationView.codeBtn, alpha) = [[self.loginModel validSignalCodeBtn] map:^(NSNumber *b){
        return b.boolValue ? @1: @0.4;
    }];
    
    RAC(self.verificationView.loginCodeBtn, alpha) = [[self.loginModel validSignalCode] map:^(NSNumber *b){
        return b.boolValue ? @1: @0.4;
    }];
    
    [[self.verificationView.loginCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self.loginModel loginBtnCode];
    }];
}

/**
 绑定UI
*/
- (void)bindUI {
    @weakify(self);
    [[self.qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self authAct:SSDKPlatformTypeQQ];
    }];
    
    [[self.weiboBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self authAct:SSDKPlatformTypeSinaWeibo];
    }];
    
    [[self.wechatBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self authAct:SSDKPlatformTypeWechat];
    }];
    
    [[self.verificationView.phoneText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 11){
            self.verificationView.phoneText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:11]];
        }
    }];
    
    [[self.verificationView.codeText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 4){
            self.verificationView.codeText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:4]];
        }
    }];
}
    
#pragma mark ============事件响应/方法============
    
- (void)authAct:(SSDKPlatformType)platformType {
    NSLog(@"%lu====",(unsigned long)platformType);
    [ShareSDK authorize:platformType
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
             switch (state) {
                 case SSDKResponseStateSuccess:
                 {
                     NSLog(@"%@",user.icon);
                     NSLog(@"授权 成功");
                     [WSYUserDataTool setUserData:user.nickname forKey:USER_NICKNAME];
                     [WSYUserDataTool setUserData:user.icon forKey:USER_ICON];
                     [WSYUserDataTool setUserData:@1 forKey:USER_LOGIN];
                     [WSYUserDataTool setUserData:@(platformType) forKey:USER_TYPE];
                     [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCESSS_NOTICE object:nil];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     break;
                 }
                 case SSDKResponseStateFail:
                 {
                     NSLog(@"%@",error);
                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权失败"
                                                                         message:[NSString stringWithFormat:@"%@",error]
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确认"
                                                               otherButtonTitles: nil];
                     [alertView show];
                     break;
                 }
                 break;
                 case SSDKResponseStateCancel:
                 {

                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"授权取消"
                                                                         message:nil
                                                                        delegate:nil
                                                               cancelButtonTitle:@"确认"
                                                               otherButtonTitles: nil];
                     [alertView show];
                     break;
                 }
                 default:
                 break;
             }
    }];
}
    
- (void)buttonClick:(UIButton *)button {
    button.selected = !button.selected;
    [self.selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    self.selectBtn = button;
    
    @weakify(self);
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self);
        self.indicatorView.wsy_width = button.titleLabel.wsy_width;
        self.indicatorView.wsy_centerX = button.wsy_centerX;
    }];
    
    CGPoint offset = _contentView.contentOffset;
    offset.x = self.contentView.wsy_width * button.tag;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)startCount {
    NSString *text = [NSString stringWithFormat:@"重新发送(%zd)",_i] ;
    [_verificationView.codeBtn setTitle:text forState:UIControlStateNormal];
    _verificationView.codeBtn.enabled = NO;
    _verificationView.codeBtn.backgroundColor = WSYColor(150, 150, 150);
    
    if (!_i--) {
        [_timer invalidate];
        [_verificationView.codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _verificationView.codeBtn.enabled = YES;
        _verificationView.codeBtn.backgroundColor = WSYTheme_Color;
    }
}

- (BOOL)isChinaMobile:(NSString *)phoneNum {
    NSString *CM = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    return [regextestcm evaluateWithObject:phoneNum];
}

- (NSDictionary*)successOptions {
    NSDictionary *options = @{
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextKey : @"短信验证码已发送",
                              kCRToastTimeIntervalKey : @(1.0),
                              kCRToastTextColorKey : [UIColor blackColor],
                              kCRToastBackgroundColorKey : [UIColor whiteColor]
                              };
    return [NSDictionary dictionaryWithDictionary:options];
}

- (NSDictionary*)errorOptions {
    NSDictionary *options = @{
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextKey : @"短信验证码发送失败",
                              kCRToastTimeIntervalKey : @(1.0),
                              kCRToastBackgroundColorKey : WSYTheme_Color
                              };
    return [NSDictionary dictionaryWithDictionary:options];
}

- (NSDictionary*)failureOptions {
    NSDictionary *options = @{
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextKey : @"请输入正确的手机号码",
                              kCRToastTimeIntervalKey : @(1.0),
                              kCRToastBackgroundColorKey : WSYTheme_Color
                              };
    return [NSDictionary dictionaryWithDictionary:options];
}

#pragma mark ============UIScrollViewDelegate============

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.wsy_width;
    UIButton *button = _titleView.subviews[index];
    [self buttonClick:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark ============懒加载============

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        _contentView.delegate = self;
    }
    return _contentView;
}

#pragma mark ============UI界面============

- (void)setUpNav {
    [self.customNavBar wr_setBottomLineHidden:YES];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"N_off"]];
    [self.customNavBar wr_setRightButtonWithTitle:@"注册" titleColor:[UIColor blackColor]];
    @weakify(self);
    self.customNavBar.onClickRightButton = ^{
        @strongify(self);
        WSYRegisterViewController *vc = [WSYRegisterViewController new];
        vc.customNavBar.title = @"新用户注册";
        [self.navigationController hh_pushBackViewController:vc];
    };
    
    self.customNavBar.onClickLeftButton = ^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)setUpTiTleView {
    self.middleLoginView = [[UIView alloc]initWithFrame:(CGRect){0, NAV_HEIGHT + 20, kScreenWidth, 350}];
    [self.view addSubview:self.middleLoginView];
    
    self.titleView = [UIView new];
    self.titleView.frame = CGRectMake(0, 0, kScreenWidth, 35);
    [self.middleLoginView addSubview:self.titleView];
    
    NSArray *titleArray = @[@"账号密码登录",@"短信验证登录"];
    CGFloat buttonW = (self.titleView.wsy_width - 30) / 2;
    CGFloat buttonH = self.titleView.wsy_height - 3;
    CGFloat buttonX = 15;
    CGFloat buttonY = 0;
    for (NSInteger i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = WSYFont(16);
        button.tag = i;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.frame = CGRectMake((i * buttonW) + buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:button];
    }
    
    UIButton *firstButton = self.titleView.subviews[0];
    [self buttonClick:firstButton];
    
    self.indicatorView = [UIView new];
    self.indicatorView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    
    
    [firstButton.titleLabel sizeToFit];
    
    self.indicatorView.wsy_height = 2;
    self.indicatorView.wsy_width = firstButton.titleLabel.wsy_width;
    self.indicatorView.wsy_centerX = firstButton.wsy_centerX;
    self.indicatorView.wsy_y = self.titleView.wsy_bottom - self.indicatorView.wsy_height;
    [self.titleView addSubview:self.indicatorView];
    
    self.contentView.contentSize = CGSizeMake(kScreenWidth * titleArray.count, 0);
}

- (void)setUpContentView {
    self.contentView.frame = (CGRect){0, self.titleView.wsy_bottom + 10, kScreenWidth, self.middleLoginView.wsy_height - self.titleView.wsy_bottom - 10};
    [self.middleLoginView addSubview:self.contentView];
    
    
    self.verificationView = [WSYVerificationView new];
    [self.contentView addSubview:self.verificationView];
    self.accountPsdView = [WSYAccountPsdView wsy_viewFromXib];
    [self.contentView addSubview:self.accountPsdView];
    
    self.verificationView.frame = (CGRect){kScreenWidth, 0, kScreenWidth, self.middleLoginView.wsy_height - self.titleView.wsy_height};
    self.accountPsdView.frame = (CGRect){0, 0, kScreenWidth, self.middleLoginView.wsy_height - self.titleView.wsy_height};
}

- (void)setUpBottomView {
    self.otherLab = [UILabel new];
    self.otherLab.text = @"其他登录方式";
    self.otherLab.font = WSYFont(11);
    self.otherLab.textColor = WSYColor(170, 170, 170);
    self.otherLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.otherLab];
    @weakify(self);
    [self.otherLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(80);
        make.bottom.equalTo(self.view).offset(-130);
    }];
    
    self.line1 = [[UIView alloc]init];
    self.line1.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line1];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.otherLab.mas_left).offset(-15);
        make.height.mas_equalTo(1);
        make.centerY.equalTo(self.otherLab);
    }];
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line2];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.otherLab.mas_right).offset(15);
        make.centerY.equalTo(self.otherLab);
    }];
    
    self.weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weiboBtn setImage:[UIImage imageNamed:@"L_weibo"] forState:UIControlStateNormal];
    [self.weiboBtn setTitle:@"微博登录" forState:UIControlStateNormal];
    [self.weiboBtn setTitleColor:WSYColor(130, 130, 130) forState:UIControlStateNormal];
    self.weiboBtn.titleLabel.font = WSYFont(11);
    self.weiboBtn.imageRect = (CGRect){0, 0, 43, 43};
    self.weiboBtn.titleRect = (CGRect){0, 43, 45, 27};
    [self.view addSubview:self.weiboBtn];
    [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(70);
        make.top.equalTo(self.otherLab).offset(30);
    }];
    
    self.wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wechatBtn setImage:[UIImage imageNamed:@"L_wx"] forState:UIControlStateNormal];
    [self.wechatBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:WSYColor(130, 130, 130) forState:UIControlStateNormal];
    self.wechatBtn.titleLabel.font = WSYFont(11);
    self.wechatBtn.imageRect = (CGRect){0, 0, 43, 43};
    self.wechatBtn.titleRect = (CGRect){0, 43, 45, 27};
    [self.view addSubview:self.wechatBtn];
    [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerY.equalTo(self.weiboBtn);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(70);
        make.right.equalTo(self.weiboBtn.mas_left).offset(-50);
    }];
    
    self.qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.qqBtn setImage:[UIImage imageNamed:@"L_qq"] forState:UIControlStateNormal];
    [self.qqBtn setTitle:@"QQ登录" forState:UIControlStateNormal];
    [self.qqBtn setTitleColor:WSYColor(130, 130, 130) forState:UIControlStateNormal];
    self.qqBtn.titleLabel.font = WSYFont(11);
    self.qqBtn.imageRect = (CGRect){0, 0, 43, 43};
    self.qqBtn.titleRect = (CGRect){0, 43, 45, 27};
    [self.view addSubview:self.qqBtn];
    [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.centerY.equalTo(self.weiboBtn);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(70);
        make.left.equalTo(self.weiboBtn.mas_right).offset(50);
    }];
    
    self.privacyLab = [YYLabel new];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"登录即代表您已经同意《游宝隐私政策》"];
    text.yy_color = WSYColor(150, 150, 150);
    self.privacyLab.font = WSYFont(11);
    [text yy_setTextHighlightRange:NSMakeRange(10, 8) color:Color_Wathet backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"《信天嗡用户注册协议》被点击了=====");
    }];
    self.privacyLab.attributedText = text;
    self.privacyLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.privacyLab];
    [self.privacyLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.bottom.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
}

@end
