//
//  ViewController.m
//  RecognizerRender
//
//  Created by 李少锋 on 2018/11/22.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "RecognizerRenderVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"设置手势密码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

-(void)buttonClick{
    RecognizerRenderVC *goVC=[[RecognizerRenderVC alloc]init];
    [self.navigationController pushViewController:goVC animated:YES];
}

@end
