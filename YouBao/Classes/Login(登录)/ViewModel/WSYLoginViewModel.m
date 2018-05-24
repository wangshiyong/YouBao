//
//  WSYLoginViewModel.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYLoginViewModel.h"

@interface WSYLoginViewModel ()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *loginSignal;

@end

@implementation WSYLoginViewModel

-(instancetype)init{
    if (self = [super init]) {
        _userNameSignal = RACObserve(self, userName);
        _passwordSignal = RACObserve(self, password);
        _successSubject = [RACSubject subject];
        _failureSubject = [RACSubject subject];
        _errorSubject   = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)validSignal {
    RACSignal *validSignal = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal] reduce:^id(NSString *userName, NSString *password){
        return @(userName.length >= 11 && password.length >= 6);
    }];
    return validSignal;
}

- (void)loginBtn{
    [_successSubject sendNext:@"登录成功"];
//    [_failureSubject sendNext:@"登录失败"];
//    [_errorSubject sendNext:@"登录错误"];
}

@end
