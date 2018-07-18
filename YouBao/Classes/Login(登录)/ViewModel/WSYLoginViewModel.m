//
//  WSYLoginViewModel.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYLoginViewModel.h"
#import <SMS_SDK/SMSSDK.h>

@interface WSYLoginViewModel ()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *codeSignal;
@property (nonatomic, strong) RACSignal *loginSignalCode;

@end

@implementation WSYLoginViewModel

-(instancetype)init{
    if (self = [super init]) {
        _userNameSignal = RACObserve(self, userName);
        _passwordSignal = RACObserve(self, password);
        _successSubject = [RACSubject subject];
        _failureSubject = [RACSubject subject];
        _errorSubject   = [RACSubject subject];
        _phoneSignal = RACObserve(self, phone);
        _codeSignal = RACObserve(self, code);
        _successSubjectCode = [RACSubject subject];
        _failureSubjectCode = [RACSubject subject];
        _errorSubjectCode   = [RACSubject subject];
        _successSubjectGetCode   = [RACSubject subject];
        _failureSubjectGetCode   = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)validSignal {
    RACSignal *validSignal = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal] reduce:^id(NSString *userName, NSString *password){
        return @(userName.length > 0 && password.length >= 6);
    }];
    return validSignal;
}

- (RACSignal *)validSignalCode {
    RACSignal *validSignalCode = [RACSignal combineLatest:@[_phoneSignal, _codeSignal] reduce:^id(NSString *phone, NSString *code){
        return @(phone.length >= 11 && code.length >= 4);
    }];
    return validSignalCode;
}

- (RACSignal *)validSignalCodeBtn {
    RACSignal *validSignal = [RACSignal combineLatest:@[_phoneSignal] reduce:^id(NSString *phone){
        return @(phone.length > 0);
    }];
    return validSignal;
}

- (void)loginBtn{
    @weakify(self);
    NSDictionary *parameters = @{@"UserName":_userName, @"Password":_password};
    [WSYNetworking getLoginWithParameters:parameters success:^(id response){
        @strongify(self);
        if (![response[@"data"] isEqual:[NSNull null]]) {
//            [WSYUserDataTool setUserData:model.nickName forKey:USER_NICKNAME];
//            [WSYUserDataTool setUserData:model.icon forKey:USER_ICON];
//            [WSYUserDataTool setUserData:response[@"data"] forKey:USER_INFO];
//            [WSYUserDataTool setUserData:@1 forKey:USER_LOGIN];
            [self.successSubject sendNext:@"登录成功"];
        } else {
            [self.failureSubject sendNext:@"账号或者密码错误"];
        }
    } failure:^(NSError *error){
        @strongify(self);
        NSLog(@"%@",error);
        [self.errorSubject sendNext:@"登录失败"];
    }];
}

- (void)loginBtnCode{
//    [SMSSDK commitVerificationCode:_code phoneNumber:_phone zone:@"86" result:^(NSError *error) {
//        if (!error) {
            [self.successSubjectCode sendNext:@"登录成功"];
//        } else {
//            [self.errorSubjectCode sendNext:@"登录失败"];
//        }
//    }];
}
    
- (void)getCodeBtn {
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone zone:@"86" template:nil result:^(NSError *error) {
//        if (!error) {
            [self.successSubjectGetCode sendNext:@"获取成功"];
//        } else {
//            [self.failureSubjectGetCode sendNext:@"获取失败"];
//        }
//    }];
}

@end
