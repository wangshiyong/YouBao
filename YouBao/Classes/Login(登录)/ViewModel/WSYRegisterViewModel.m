//
//  WSYRegisterViewModel.m
//  YouBao
//
//  Created by 王世勇 on 2018/6/26.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYRegisterViewModel.h"

#import <SMS_SDK/SMSSDK.h>

@interface WSYRegisterViewModel ()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *phoneSignal;
@property (nonatomic, strong) RACSignal *codeSignal;

@end

@implementation WSYRegisterViewModel

-(instancetype)init {
    if (self = [super init]) {
        _userNameSignal = RACObserve(self, userName);
        _passwordSignal = RACObserve(self, password);
        _phoneSignal = RACObserve(self, phone);
        _codeSignal = RACObserve(self, code);
        _successSubject = [RACSubject subject];
        _failureSubject = [RACSubject subject];
        _errorSubject   = [RACSubject subject];
        _successSubjectCode = [RACSubject subject];
        _errorSubjectCode   = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)validSignal {
    RACSignal *validSignal = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal, _phoneSignal, _codeSignal] reduce:^id(NSString *userName, NSString *password, NSString *phone, NSString *code){
        return @(userName.length > 0 && password.length >= 6 && phone.length >= 11 && code.length >= 4);
    }];
    return validSignal;
}

- (RACSignal *)validSignalCode {
    RACSignal *validSignal = [RACSignal combineLatest:@[_phoneSignal] reduce:^id(NSString *phone){
        return @(phone.length > 0);
    }];
    return validSignal;
}

- (void)loginBtnCode{
//    [SMSSDK commitVerificationCode:_code phoneNumber:_phone zone:@"86" result:^(NSError *error) {
//        if (!error) {
//            NSDictionary *parameters = @{@"UserName":self.phone, @"Nickname":self.userName, @"City":GPS_CITY ?[WSYUserDataTool getUserData:GPS_CITY] : @"未知", @"Password":self.password};
//            [WSYNetworking getRegisterWithParameters:parameters success:^(id response){
//                if ([response[@"resCode"] integerValue] == 0) {
//                    [self.successSubject sendNext:@"注册成功,请重新登录"];
//                } else {
//                    [self.failureSubject sendNext:@"注册失败"];
//                }
//            } failure:^(NSError *error){
//                NSLog(@"%@",error);
//                [self.errorSubject sendNext:@"注册失败"];
//            }];
//        } else {
//            [self.errorSubjectCode sendNext:@"短信验证码不正确"];
//        }
//    }];
}

- (void)getCodeBtn {
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phone zone:@"86" template:nil result:^(NSError *error) {
//        if (!error) {
            [self.successSubjectCode sendNext:@"短信验证码已发送"];
//        } else {
//            [self.errorSubjectCode sendNext:@"短信验证码发送失败"];
//        }
//    }];
}

@end
