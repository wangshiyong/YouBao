//
//  WSYAccountPsdView.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "WSYAccountPsdView.h"

@interface WSYAccountPsdView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *showPwd;

@end

@implementation WSYAccountPsdView

#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)showPwd:(id)sender {
    self.showPwd.selected = !self.showPwd.selected;
    if (!self.showPwd.selected) {
        self.pwdText.secureTextEntry = YES;
    } else {
        self.pwdText.secureTextEntry = NO;
    }
}

@end
