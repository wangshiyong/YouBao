//
//  WSYRegisterViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/23.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYRegisterViewController.h"

// Models
#import "WSYRegisterViewModel.h"
// Vendors
#import <YYText/YYText.h>
#import "CRToast.h"
#import "DGActivityIndicatorView.h"

@interface WSYRegisterViewController ()<UIGestureRecognizerDelegate>{
    NSTimer *_timer;
    NSInteger _i;
}

/* UI界面 */
@property (nonatomic, strong) UIButton *areaCodeBtn;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UILabel *pwdLab;
@property (nonatomic, strong) UITextField *pwdText;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, strong) YYLabel *privacyLab;
@property (nonatomic, strong) UIButton *registerBtn;
/* 注册模型 */
@property (nonatomic, strong) WSYRegisterViewModel *registerModel;
@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation WSYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self layoutUI];
    [self bindUI];
    [self bindRegisterModel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ============绑定监听UI============

/**
 绑定监听UI
 */
- (void)bindUI {
    @weakify(self);
    [[self.showBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        self.showBtn.selected = !self.showBtn.selected;
        if (!self.showBtn.selected) {
            self.pwdText.secureTextEntry = YES;
        } else {
            self.pwdText.secureTextEntry = NO;
        }
    }];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]init];
    [[recognizer rac_gestureSignal]subscribeNext:^(id x){
        @strongify(self);
        [self.phoneText resignFirstResponder];
        [self.codeText resignFirstResponder];
        [self.nameText resignFirstResponder];
        [self.pwdText resignFirstResponder];
    }];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
  
    [[self.phoneText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 11){
            self.phoneText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:11]];
        }
    }];
    
    [[self.codeText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 4){
            self.codeText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:4]];
        }
    }];
    
    [[self.nameText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 15){
            self.nameText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:15]];
        }
    }];
    
    [[self.pwdText rac_textSignal]subscribeNext:^(id x){
        @strongify(self);
        if([x length] > 20){
            self.pwdText.text = [NSString stringWithFormat:@"%@",[x substringToIndex:20]];
        }
    }];
}


/**
 绑定注册模型
 */
- (void)bindRegisterModel {
    self.registerModel = [[WSYRegisterViewModel alloc]init];
    RAC(self.registerModel, userName) = self.nameText.rac_textSignal;
    RAC(self.registerModel, password) = self.pwdText.rac_textSignal;
    RAC(self.codeBtn, enabled) = [self.registerModel validSignalCode];
    RAC(self.registerModel, phone) = self.phoneText.rac_textSignal;
    RAC(self.registerModel, code) = self.codeText.rac_textSignal;
    RAC(self.registerBtn, enabled) = [self.registerModel validSignal];
    
    @weakify(self);
    [self.registerModel.successSubjectCode subscribeNext:^(NSString *str){
        @strongify(self);
        [CRToastManager showNotificationWithOptions:[self successOptions:str]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    [self.registerModel.errorSubjectCode subscribeNext:^(NSString *str){
        @strongify(self);
        [CRToastManager showNotificationWithOptions:[self errorOptions:str]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    RAC(self.codeBtn, alpha) = [[self.registerModel validSignalCode] map:^(NSNumber *b){
        return b.boolValue ? @1: @0.4;
    }];
    
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(NSString *str){
        @strongify(self);
        if ([self isChinaMobile:self.phoneText.text]) {
            [self.registerModel getCodeBtn];
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
            self->_i = 60;
        } else {
            [CRToastManager showNotificationWithOptions:[self errorOptions:str]
                                         apperanceBlock:nil
                                        completionBlock:nil];
        }
    }];
    
    [self.registerModel.successSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [self.activityIndicatorView stopAnimating];
        [self showStrHUD:str];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.registerModel.failureSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [CRToastManager showNotificationWithOptions:[self errorOptions:str]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    [self.registerModel.errorSubject subscribeNext:^(NSString *str){
        @strongify(self);
        [self.activityIndicatorView stopAnimating];
        [CRToastManager showNotificationWithOptions:[self errorOptions:str]
                                     apperanceBlock:nil
                                    completionBlock:nil];
    }];
    
    RAC(self.registerBtn, alpha) = [[self.registerModel validSignal] map:^(NSNumber *b){
        return b.boolValue ? @1: @0.4;
    }];
    
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self.activityIndicatorView startAnimating];
        [self.registerModel loginBtnCode];
    }];
}

- (BOOL)isChinaMobile:(NSString *)phoneNum
{
    NSString *CM = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    return [regextestcm evaluateWithObject:phoneNum];
}

- (NSDictionary*)successOptions:(NSString *)successStr {
    NSDictionary *options = @{
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextKey : successStr,
                              kCRToastTimeIntervalKey : @(1.0),
                              kCRToastTextColorKey : [UIColor blackColor],
                              kCRToastBackgroundColorKey : [UIColor whiteColor]
                              };
    return [NSDictionary dictionaryWithDictionary:options];
}

- (NSDictionary*)errorOptions:(NSString *)errorStr {
    NSDictionary *options = @{
                              kCRToastAnimationOutDirectionKey : @(0),
                              kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                              kCRToastNotificationPresentationTypeKey : @(CRToastPresentationTypeCover),
                              kCRToastTextKey : errorStr,
                              kCRToastTimeIntervalKey : @(1.0),
                              kCRToastBackgroundColorKey : WSYTheme_Color
                              };
    return [NSDictionary dictionaryWithDictionary:options];
}

- (void)startCount {
    NSString *text = [NSString stringWithFormat:@"重新发送(%zd)",_i] ;
    [_codeBtn setTitle:text forState:UIControlStateNormal];
    _codeBtn.enabled = NO;
    _codeBtn.backgroundColor = WSYColor(150, 150, 150);
    
    if (!_i--) {
        [_timer invalidate];
        [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _codeBtn.enabled = YES;
        _codeBtn.backgroundColor = WSYTheme_Color;
    }
}

#pragma mark ============设置UI界面============

- (void)setUpUI {
    _areaCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_areaCodeBtn setTitle:@"中国 +86" forState:UIControlStateNormal];
    [_areaCodeBtn setTitleColor:Color_Wathet forState:UIControlStateNormal];
    _areaCodeBtn.titleLabel.font = WSYFont(15);
    [self.view addSubview:_areaCodeBtn];
    
    _phoneText = [UITextField new];
    _phoneText.placeholder = @"请输入手机号";
    _phoneText.font = WSYFont(16);
    _phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneText];

    _line1 = [UIView new];
    _line1.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:_line1];
    
    
    _codeLab = [UILabel new];
    _codeLab.text = @"短信验证码";
    _codeLab.textColor = WSYTheme_Text;
    _codeLab.font = WSYFont(15);
    [self.view addSubview:_codeLab];
    
    _codeText = [UITextField new];
    _codeText.placeholder = @"请输入验证码";
    _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    _codeText.font = WSYFont(16);
    [self.view addSubview:_codeText];
    
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = WSYFont(13);
    _codeBtn.backgroundColor = WSYTheme_Color;
    [self.view addSubview:_codeBtn];
    _codeBtn.layer.cornerRadius = 19;
    
    _line2 = [UIView new];
    _line2.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:_line2];
    
    _nameLab = [UILabel new];
    _nameLab.text = @"昵称";
    _nameLab.textColor = WSYTheme_Text;
    _nameLab.font = WSYFont(15);
    [self.view addSubview:_nameLab];
    
    _nameText = [UITextField new];
    _nameText.placeholder = @"15个字符以内";
    _nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameText.font = WSYFont(16);
    [self.view addSubview:_nameText];
    
    _line3 = [UIView new];
    _line3.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:_line3];
    
    _pwdLab = [UILabel new];
    _pwdLab.text = @"密码";
    _pwdLab.textColor = WSYTheme_Text;
    _pwdLab.font = WSYFont(15);
    [self.view addSubview:_pwdLab];
    
    _pwdText = [UITextField new];
    _pwdText.placeholder = @"6-20位数字或字母";
    _pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdText.font = WSYFont(16);
    _pwdText.secureTextEntry = YES;
    [self.view addSubview:_pwdText];
    
    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showBtn setImage:[UIImage imageNamed:@"L_hidePwd"] forState:UIControlStateNormal];
    [_showBtn setImage:[UIImage imageNamed:@"L_showPwd"] forState:UIControlStateSelected];
    [self.view addSubview:_showBtn];
    
    _line4 = [UIView new];
    _line4.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:_line4];
    
    _privacyLab = [YYLabel new];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"点击完成即同意《游宝用户注册协议》"];
    text.yy_color = WSYColor(150, 150, 150);
    self.privacyLab.font = WSYFont(11);
    [text yy_setTextHighlightRange:NSMakeRange(7, 10) color:Color_Wathet backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"《信天嗡用户注册协议》被点击了=====");
    }];
    _privacyLab.attributedText = text;
    _privacyLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_privacyLab];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"完成注册，进入游宝" forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = WSYFont(18);
    _registerBtn.backgroundColor = WSYTheme_Color;
    _registerBtn.layer.cornerRadius = 23;
    [self.view addSubview:_registerBtn];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:WSYTheme_Color];
    _activityIndicatorView.frame = (CGRect){0, 0, kScreenWidth, kScreenHeight};
    [self.view addSubview:_activityIndicatorView];
}

- (void)layoutUI {
    @weakify(self);
    [self.areaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.view).offset(0);
        make.centerY.equalTo(self.phoneText);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.areaCodeBtn.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(NAV_HEIGHT + 16);
        make.height.mas_equalTo(34);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.phoneText.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.codeLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.codeText);
        make.width.mas_equalTo(80);
    }];
    
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.codeLab.mas_right).offset(10);
        make.top.equalTo(self.line1.mas_bottom).offset(16);
        make.right.equalTo(self.codeBtn.mas_left).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.codeText);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(38);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.codeText.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.nameText);
        make.width.mas_equalTo(35);
    }];
    
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.nameLab.mas_right).offset(10);
        make.top.equalTo(self.line2.mas_bottom).offset(16);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(34);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.nameText.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.pwdLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.view).offset(20);
        make.centerY.equalTo(self.pwdText);
        make.width.mas_equalTo(35);
    }];
    
    [self.pwdText mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.pwdLab.mas_right).offset(10);
        make.top.equalTo(self.line3.mas_bottom).offset(16);
        //        make.right.equalTo(self.codeBtn.mas_left).offset(-10);
        make.height.mas_equalTo(34);
    }];
    
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.left.equalTo(self.pwdText.mas_right).offset(10);
        make.centerY.equalTo(self.pwdText);
        make.right.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.pwdText.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.privacyLab mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.line4.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(34);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make){
        @strongify(self);
        make.top.equalTo(self.privacyLab.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(46);
    }];
}

@end
