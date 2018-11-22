//
//  RecognizerRenderView.m
//  RecognizerRender
//
//  Created by 李少锋 on 2018/11/22.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "RecognizerRenderView.h"
#import "Macros.h"

const int rowCount = 3;
const int colCount = 3;
const int normalBorderWidth = 3;
const int selectBorderWidth = 10;

@interface AreaRect : NSObject

@property(nonatomic)CGPoint     center;
@property(nonatomic)NSInteger   index;

@end

@implementation AreaRect

@end

@interface RecognizerRenderView()

@property(nonatomic)CGFloat     padding;
@property(nonatomic, strong)NSMutableArray*     circleAreaArray;    //9个圆的显示区域集合
@property(nonatomic, strong)NSMutableArray*     renderPointArray;   //选中的点集合
@property(nonatomic)CGPoint     movedPoint;

@property(nonatomic)CGFloat   radius;
@property(nonatomic)NSInteger   selectRadius;

@property(nonatomic)CGFloat     strokeColorRed;
@property(nonatomic)CGFloat     strokeColorGreen;
@property(nonatomic)CGFloat     strokeColorBlue;
@property(nonatomic)CGFloat     strokeColorAlpha;

@property(nonatomic)CGFloat     fillColorRed;
@property(nonatomic)CGFloat     fillColorGreen;
@property(nonatomic)CGFloat     fillColorBlue;
@property(nonatomic)CGFloat     fillColorAlpha;

@property(nonatomic)BOOL isBigSelect;//是否是大圆连接状态

@end

@implementation RecognizerRenderView

-(instancetype)initWithRadius:(NSInteger)radius padding:(NSInteger)padding
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.circleAreaArray = [[NSMutableArray alloc] init];
        self.renderPointArray = [[NSMutableArray alloc] init];
        self.movedPoint = CGPointZero;
        
        self.radius = radius;
        self.recognizerEnable = YES;
        self.padding = padding;
        self.circleStrokeColor = THEME_COLOR;
        self.selectedRenderType = SelectedCircleRenderTypeCenter;
        self.isDrawLine = YES;
        self.isBigSelect=YES;
        
        NSUInteger hexValue = strtoul([THEME_COLOR UTF8String], 0, 16);
        if(hexValue == ERANGE)
        {
            hexValue = 0;
        }
        self.strokeColorAlpha = ((hexValue & 0xFF000000) >> 24) / 255.0;
        self.strokeColorRed = ((hexValue & 0x00FF0000) >> 16) / 255.0;
        self.strokeColorGreen = ((hexValue & 0x0000FF00) >> 8) / 255.0;
        self.strokeColorBlue = (hexValue & 0x000000FF) / 255.0;
        
        self.fillColorRed = self.strokeColorRed;
        self.fillColorGreen = self.strokeColorGreen;
        self.fillColorBlue = self.strokeColorBlue;
        self.fillColorAlpha = self.strokeColorAlpha;
    }
    return self;
}

-(CGFloat)getRenderViewWidth
{
    return colCount * (self.radius + selectBorderWidth) * 2 + (colCount - 1) * self.padding;
}

-(CGFloat)getRenderViewHeight
{
    return rowCount * (self.radius + selectBorderWidth) * 2 + (rowCount - 1) * self.padding;
}

-(void)setCircleStrokeColor:(NSString*)hexColor
{
    NSUInteger hexValue = strtoul([hexColor UTF8String], 0, 16);
    if(hexValue == ERANGE)
    {
        hexValue = 0;
        
    }
    self.strokeColorAlpha = ((hexValue & 0xFF000000) >> 24) / 255.0;
    self.strokeColorRed = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    self.strokeColorGreen = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    self.strokeColorBlue = (hexValue & 0x000000FF) / 255.0;
}

-(void)setCircleFillColor:(NSString*)hexColor
{
    NSUInteger hexValue = strtoul([hexColor UTF8String], 0, 16);
    if(hexValue == ERANGE)
    {
        hexValue = 0;
    }
    self.fillColorAlpha = ((hexValue & 0xFF000000) >> 24) / 255.0;
    self.fillColorRed = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    self.fillColorGreen = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    self.fillColorBlue = (hexValue & 0x000000FF) / 255.0;
}

-(void)setSelectedPoint:(NSArray *)selectedArray
{
    self.renderPointArray = [NSMutableArray arrayWithArray:selectedArray];
}

-(void)drawRecognizer
{
    [self setNeedsDisplay];
}

-(void)clearRecognizer
{
    [self.renderPointArray removeAllObjects];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //绘制线条
    if(self.isDrawLine)
    {
        NSUInteger count = [self.renderPointArray count];
        if(count > 0)
        {
            CGPoint lastPoint = CGPointZero;
            for(NSUInteger i = 0;i < count;++i)
            {
                AreaRect* area = [self.circleAreaArray objectAtIndex:[[self.renderPointArray objectAtIndex:i] intValue]];
                if(i < count - 1)
                {
                    AreaRect* nextArea = [self.circleAreaArray objectAtIndex:[[self.renderPointArray objectAtIndex:i+1] intValue]];
                    [self drawLineWithFrom:area.center AndEnd:nextArea.center];
                }
                
                lastPoint = area.center;
            }
            
            if(!CGPointEqualToPoint(self.movedPoint, CGPointZero))
            {
                [self drawLineWithFrom:lastPoint AndEnd:self.movedPoint];
            }
        }
    }
    
    //绘制手势所需的9个圆
    for(int i = 0;i < rowCount;++i)
    {
        for(int j = 0;j < colCount;++j)
        {
            CGFloat centerx = 0.0;
            CGFloat centery = 0.0;
            centerx = self.padding * j + (self.radius + selectBorderWidth) * 2 * j + self.radius + selectBorderWidth;
            centery = self.padding * i + (self.radius + selectBorderWidth) * 2 * i + self.radius + selectBorderWidth;
            
            AreaRect* rect;
            NSInteger index = i * rowCount + j;
            if(self.circleAreaArray.count > index)
            {
                rect = [self.circleAreaArray objectAtIndex:index];
            }
            else
            {
                rect = [[AreaRect alloc] init];
                rect.center = CGPointMake(centerx, centery);
                rect.index = index;
                [self.circleAreaArray addObject:rect];
            }
            
            BOOL isSelect = NO;
            for(NSNumber* number in self.renderPointArray)
            {
                if([number intValue] == rect.index)
                {
                    isSelect = YES;
                    break;
                }
            }
            if(isSelect)
            {
                if(_isBigSelect){
                    [self drawStrokeCircleInCenterX:centerx centerY:centery lineWidth:selectBorderWidth];
                    AreaRect* area = [self.circleAreaArray objectAtIndex:rect.index];
                    [self drawFillCircleInCenterX:area.center.x centerY:area.center.y strokeColorRed:self.fillColorRed strokeColorGreen:self.fillColorGreen strokeColorBlue:self.fillColorBlue strokeColorAlpha:self.fillColorAlpha];
                }
                else{
                    [self drawStrokeCircleInCenterX:centerx centerY:centery lineWidth:4];
                    AreaRect* area = [self.circleAreaArray objectAtIndex:rect.index];
                    [self drawFillCircleInCenterX:area.center.x centerY:area.center.y strokeColorRed:self.fillColorRed strokeColorGreen:self.fillColorGreen strokeColorBlue:self.fillColorBlue strokeColorAlpha:self.fillColorAlpha];
                }
            }
            else
            {
                [self drawStrokeCircleInCenterX:centerx centerY:centery lineWidth:normalBorderWidth];
            }
            
        }
    }
}

#pragma mark - draw method

-(void)drawStrokeCircleInCenterX:(CGFloat)centerx centerY:(CGFloat)centery lineWidth:(CGFloat)lineWidth
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 241/255.0, 241/255.0, 241/255.0, self.strokeColorAlpha);
    CGContextSetRGBFillColor(context, 241/255.0, 241/255.0, 241/255.0, 1);
    CGContextSetLineWidth(context, lineWidth);
    CGContextAddArc(context, centerx, centery, self.radius, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFillStroke);//绘制填充
}

-(void)drawFillCircleInCenterX:(CGFloat)centerx centerY:(CGFloat)centery strokeColorRed:(CGFloat)red strokeColorGreen:(CGFloat)green strokeColorBlue:(CGFloat)blue strokeColorAlpha:(CGFloat)alpha
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    if(self.isBigSelect){
        CGContextSetRGBStrokeColor(context, self.strokeColorRed, self.strokeColorGreen, self.strokeColorBlue, self.strokeColorAlpha);
        CGContextSetLineWidth(context, AdaptedHeight(10));
    }
    else{
        CGContextSetRGBStrokeColor(context, self.strokeColorRed, self.strokeColorGreen, self.strokeColorBlue, self.strokeColorAlpha);
    }
    if(self.selectedRenderType == SelectedCircleRenderTypeAll)
    {
        CGContextAddArc(context, centerx, centery, self.radius, 0, 2*M_PI, 0);
    }
    else
    {
        CGContextAddArc(context, centerx, centery, self.radius+5, 0, 2*M_PI, 0);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawLineWithFrom:(CGPoint)start AndEnd:(CGPoint)end
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, self.fillColorRed, self.fillColorGreen, self.fillColorBlue, self.fillColorAlpha);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextStrokePath(context);
}

#pragma mark - touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.recognizerEnable)
        return;
    
    if([touches count] > 1)
        return;
    
    [self.renderPointArray removeAllObjects];
    
    for(UITouch* touch in touches)
    {
        CGPoint pos = [touch locationInView:self];
        [self checkTouchCirce:pos];
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.recognizerEnable)
        return;
    
    if([touches count] > 1)
        return;
    
    if([self.renderPointArray count] < 1)
        return;
    
    for(UITouch* touch in touches)
    {
        CGPoint pos = [touch locationInView:self];
        if(![self checkTouchCirce:pos])
        {
            self.movedPoint = pos;
        }
        [self setNeedsDisplay];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.recognizerEnable)
        return;
    
    if(self.renderPointArray.count < 1)
        return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(recognizerFinish:)])
    {
        [self.delegate recognizerFinish:[NSArray arrayWithArray:self.renderPointArray]];
    }
    
    //    [self.renderPointArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - check method

-(BOOL)isPointInRect:(CGPoint)pos AndRect:(CGRect)rect
{
    if(pos.x < rect.origin.x || pos.x > (rect.origin.x + rect.size.width))
        return NO;
    
    if(pos.y < rect.origin.y || pos.y > (rect.origin.y + rect.size.height))
        return NO;
    
    return YES;
}

//返回值YES表示有新的圆被触碰到，返回NO表示没有触碰到新的圆
-(BOOL)checkTouchCirce:(CGPoint)pos
{
    for(AreaRect* area in self.circleAreaArray)
    {
        CGRect rect = CGRectMake(area.center.x - self.radius*3, area.center.y - self.radius*3, self.radius * 6, self.radius * 6);
        if([self isPointInRect:pos AndRect:rect])
        {
            //检测是否是已经经过的点
            for(NSNumber* number in self.renderPointArray)
            {
                if([number intValue] == area.index)
                {
                    return NO;
                }
            }
            [self.renderPointArray addObject:@(area.index)];
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation RecognizerRenderView (Builder)

+ (instancetype)recognizerRenderViewWithBuildType:(RecognizerRenderViewBuildType)type {
    RecognizerRenderView *renderView = [[RecognizerRenderView alloc] initWithRadius:AdaptedWidth(25) padding:AdaptedHeight(60)];
    renderView.selectedRenderType = SelectedCircleRenderTypeAll;
    [renderView changeBuildType:type];
    return renderView;
}

- (void)changeBuildType:(RecognizerRenderViewBuildType)type {
    switch (type) {
        case RecognizerRenderViewBuildTypeWhite://连接选中的颜色
            [self setCircleFillColor:COLOR_FFFC2B2D];
            [self setCircleStrokeColor:COLOR_FEE9EA];
            self.recognizerEnable = YES;
            self.isBigSelect=YES;
            break;
        case RecognizerRenderViewBuildTypeRed://连线错误的颜色
            [self setCircleFillColor:COLOR_FF999999];
            [self setCircleStrokeColor:COLOR_F1F1F1];
            self.recognizerEnable = NO;
            self.isBigSelect=YES;
            break;
        case RecognizerRenderViewBuildTypeSmall:
            self.isDrawLine = NO;
            self.recognizerEnable = NO;
            self.radius = AdaptedWidth(4);
            self.selectRadius=6.0;
            self.padding = AdaptedWidth(8);
            self.isBigSelect=NO;
            [self setCircleFillColor:COLOR_FFFC2B2D];  //红色
            [self setCircleStrokeColor:COLOR_FFFC2B2D]; //红色
            break;
        default:
            break;
    }
    [self drawRecognizer];
}

@end

