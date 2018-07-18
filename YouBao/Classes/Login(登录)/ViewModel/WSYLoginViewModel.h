//
//  WSYLoginViewModel.h
//  YouBao
//
//  Created by 王世勇 on 2018/5/24.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSYLoginViewModel : NSObject

@property (nonatomic, strong) NSString   *userName;
@property (nonatomic, strong) NSString   *password;
@property (nonatomic, strong) NSString   *phone;
@property (nonatomic, strong) NSString   *code;

@property (nonatomic, strong) RACSubject *successSubject;
@property (nonatomic, strong) RACSubject *failureSubject;
@property (nonatomic, strong) RACSubject *errorSubject;
@property (nonatomic, strong) RACSubject *successSubjectCode;
@property (nonatomic, strong) RACSubject *failureSubjectCode;
@property (nonatomic, strong) RACSubject *errorSubjectCode;
@property (nonatomic, strong) RACSubject *successSubjectGetCode;
@property (nonatomic, strong) RACSubject *failureSubjectGetCode;

/**
 *  按钮是否可点信息
 */
- (RACSignal *)validSignal;
- (RACSignal *)validSignalCode;
- (RACSignal *)validSignalCodeBtn;

- (void)getCodeBtn;
- (void)loginBtn;
- (void)loginBtnCode;

@end
