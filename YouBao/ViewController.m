//
//  ViewController.m
//  YouBao
//
//  Created by 王世勇 on 2018/5/21.
//  Copyright © 2018年 王世勇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"UINavigationBar使用总结";
     self.navigationController.navigationBar.barTintColor = [UIColor redColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
