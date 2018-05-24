//
//  WSYRegisterViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/23.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYRegisterViewController.h"

// Vendors
#import <YYText/YYText.h>

@interface WSYRegisterViewController ()

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
@property (strong , nonatomic)YYLabel *privacyLab;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation WSYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
    [self layoutUI];
    [self bindUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x){
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)setUpUI {
    self.areaCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.areaCodeBtn setTitle:@"中国 +86" forState:UIControlStateNormal];
    [self.areaCodeBtn setTitleColor:Color_Wathet forState:UIControlStateNormal];
    self.areaCodeBtn.titleLabel.font = WSYFont(15);
    [self.view addSubview:self.areaCodeBtn];
    
    self.phoneText = [UITextField new];
    self.phoneText.placeholder = @"请输入手机号";
    self.phoneText.font = WSYFont(16);
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.phoneText];

    self.line1 = [UIView new];
    self.line1.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line1];
    
    
    self.codeLab = [UILabel new];
    self.codeLab.text = @"短信验证码";
    self.codeLab.textColor = WSYTheme_Text;
    self.codeLab.font = WSYFont(15);
    [self.view addSubview:self.codeLab];
    
    self.codeText = [UITextField new];
    self.codeText.placeholder = @"请输入验证码";
    self.codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeText.font = WSYFont(16);
    [self.view addSubview:self.codeText];
    
    self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = WSYFont(13);
    self.codeBtn.backgroundColor = WSYTheme_Color;
    [self.view addSubview:self.codeBtn];
    self.codeBtn.layer.cornerRadius = 14;
    
    self.line2 = [UIView new];
    self.line2.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line2];
    
    self.nameLab = [UILabel new];
    self.nameLab.text = @"昵称";
    self.nameLab.textColor = WSYTheme_Text;
    self.nameLab.font = WSYFont(15);
    [self.view addSubview:self.nameLab];
    
    self.nameText = [UITextField new];
    self.nameText.placeholder = @"15个字符以内";
    self.nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameText.font = WSYFont(16);
    [self.view addSubview:self.nameText];
    
    self.line3 = [UIView new];
    self.line3.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line3];
    
    self.pwdLab = [UILabel new];
    self.pwdLab.text = @"密码";
    self.pwdLab.textColor = WSYTheme_Text;
    self.pwdLab.font = WSYFont(15);
    [self.view addSubview:self.pwdLab];
    
    self.pwdText = [UITextField new];
    self.pwdText.placeholder = @"6-20位数字或字母";
    self.pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pwdText.font = WSYFont(16);
    self.pwdText.secureTextEntry = YES;
    [self.view addSubview:self.pwdText];
    
    self.showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showBtn setImage:[UIImage imageNamed:@"L_hidePwd"] forState:UIControlStateNormal];
    [self.showBtn setImage:[UIImage imageNamed:@"L_showPwd"] forState:UIControlStateSelected];
    [self.view addSubview:self.showBtn];
    
    self.line4 = [UIView new];
    self.line4.backgroundColor = WSYColor(241, 241, 241);
    [self.view addSubview:self.line4];
    
    self.privacyLab = [YYLabel new];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"点击完成即同意《游宝用户注册协议》"];
    text.yy_color = WSYColor(150, 150, 150);
    self.privacyLab.font = WSYFont(11);
    [text yy_setTextHighlightRange:NSMakeRange(7, 10) color:Color_Wathet backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"《信天嗡用户注册协议》被点击了=====");
    }];
    self.privacyLab.attributedText = text;
    self.privacyLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.privacyLab];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerBtn setTitle:@"完成注册，进入游宝" forState:UIControlStateNormal];
    self.registerBtn.titleLabel.font = WSYFont(18);
    self.registerBtn.backgroundColor = WSYTheme_Color;
    self.registerBtn.layer.cornerRadius = 23;
    [self.view addSubview:self.registerBtn];

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
