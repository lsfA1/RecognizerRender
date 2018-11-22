//
//  RecognizerRenderView.h
//  RecognizerRender
//
//  Created by 李少锋 on 2018/11/22.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RecognizerRenderViewBuildType)
{
    RecognizerRenderViewBuildTypeWhite,
    RecognizerRenderViewBuildTypeRed,
    RecognizerRenderViewBuildTypeSmall,
};

typedef NS_ENUM(NSInteger, SelectedCircleRenderType)
{
    SelectedCircleRenderTypeCenter,     //中心区域填充
    SelectedCircleRenderTypeAll,        //全部填充
};

@protocol RecognizerRenderViewDelegate <NSObject>

-(void)recognizerFinish:(nonnull NSArray*)recognizerArray;

@end

@interface RecognizerRenderView : UIView

@property(nullable, nonatomic, weak)id<RecognizerRenderViewDelegate> delegate;
//是否响应touch
@property(nonatomic)BOOL            recognizerEnable;
//选中的圆填充效果
@property(nonatomic)SelectedCircleRenderType    selectedRenderType;
//是否绘制连接线
@property(nonatomic)BOOL            isDrawLine;

-(instancetype)initWithRadius:(NSInteger)radius padding:(NSInteger)padding;
-(void)clearRecognizer;

-(void)setCircleStrokeColor:(NSString*)hexColor;
-(void)setCircleFillColor:(NSString*)hexColor;
-(void)setSelectedPoint:(NSArray*)selectedArray;

-(CGFloat)getRenderViewHeight;
-(CGFloat)getRenderViewWidth;

-(void)drawRecognizer;

@end

@interface RecognizerRenderView (Builder)

+ (instancetype)recognizerRenderViewWithBuildType:(RecognizerRenderViewBuildType)type;
- (void)changeBuildType:(RecognizerRenderViewBuildType)type;

@end

NS_ASSUME_NONNULL_END
