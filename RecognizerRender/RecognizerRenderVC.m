//
//  RecognizerRenderVC.m
//  RecognizerRender
//
//  Created by 李少锋 on 2018/11/22.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "RecognizerRenderVC.h"
#import <Masonry.h>
#import "RecognizerRenderView.h"
#import "Macros.h"

@interface RecognizerRenderVC ()<RecognizerRenderViewDelegate>

@property(nonatomic,strong)RecognizerRenderView *recognizerView;

@property(nonatomic,strong)RecognizerRenderView *indicataRecognizerView;

@property(nonatomic,strong)UILabel *stateLabel;

@property(nonatomic,copy)NSArray *passwordArray;

@property(nonatomic,strong)UIButton *resetButton;

@end

@implementation RecognizerRenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _indicataRecognizerView = [RecognizerRenderView recognizerRenderViewWithBuildType:RecognizerRenderViewBuildTypeSmall];
    _indicataRecognizerView.delegate = self;
    _indicataRecognizerView.recognizerEnable = NO;
    _indicataRecognizerView.selectedRenderType = SelectedCircleRenderTypeAll;
    CGFloat smallWidth = [_indicataRecognizerView getRenderViewWidth];
    CGFloat smallHeight = [_indicataRecognizerView getRenderViewHeight];
    [self.view addSubview:_indicataRecognizerView];
    [_indicataRecognizerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AdaptedHeight(70));
        make.right.equalTo(self.view).offset(-AdaptedWidth(40));
        make.width.equalTo(@(smallWidth));
        make.height.equalTo(@(smallHeight));
    }];
    
    _stateLabel=[[UILabel alloc]init];
    _stateLabel.text=@"请绘制手势密码";
    _stateLabel.font=[UIFont systemFontOfSize:15];
    _stateLabel.textColor=[UIColor blackColor];
    _stateLabel.numberOfLines=0;
    _stateLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(AdaptedHeight(170));
        make.height.equalTo(@(AdaptedHeight(60)));
    }];
    
    _recognizerView = [[RecognizerRenderView alloc] initWithRadius:AdaptedWidth(10) padding:AdaptedWidth(85)];
    _recognizerView.delegate = self;
    [_recognizerView changeBuildType:RecognizerRenderViewBuildTypeWhite];
    CGFloat width = [_recognizerView getRenderViewWidth];
    CGFloat height = [_recognizerView getRenderViewHeight];
    [self.view addSubview:_recognizerView];
    [_recognizerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AdaptedHeight(250));
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    _resetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_resetButton setTitle:@"重新设置" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetButton];
    [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(AdaptedHeight(40)));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark - YGRecognizerRenderViewDelegate
-(void)recognizerFinish:(NSArray *)recognizerArray
{
    if([recognizerArray count] < MIN_RECOGNIZER_NUMBER)
    {
        _stateLabel.text = @"至少连接4个点，请重新输入";
        [_recognizerView clearRecognizer];
        return;
    }
    
    if(_passwordArray)
    {
        if([_passwordArray isEqualToArray:recognizerArray])
        {
            [_indicataRecognizerView setSelectedPoint:_passwordArray];
            [_indicataRecognizerView drawRecognizer];
            _stateLabel.text = [NSString stringWithFormat:@"手势密码绘制成功\n连接的点分别是: %@ %@ %@ %@",_passwordArray[0],_passwordArray[1],_passwordArray[2],_passwordArray[3]];
            NSLog(@"手势密码绘制成功:\n%@",_passwordArray);
        }
        else
        {
            _stateLabel.text = @"与上一次绘制不一致，请重新绘制";
            [_recognizerView changeBuildType:RecognizerRenderViewBuildTypeRed];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.recognizerView clearRecognizer];
                [self.recognizerView changeBuildType:RecognizerRenderViewBuildTypeWhite];
            });
        }
    }
    else
    {
        _passwordArray = recognizerArray;
        _stateLabel.text = @"再次绘制以确认";
        [_recognizerView clearRecognizer];
    }
}

-(void)resetButtonClick{
    _passwordArray=nil;
    _stateLabel.text=@"请绘制手势密码";
    [_recognizerView clearRecognizer];
    [_indicataRecognizerView clearRecognizer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
