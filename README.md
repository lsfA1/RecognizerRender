# RecognizerRender
### 通过 CGContextRef绘制圆
```
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 241/255.0, 241/255.0, 241/255.0, self.strokeColorAlpha);
  CGContextSetRGBFillColor(context, 241/255.0, 241/255.0, 241/255.0, 1);
  CGContextSetLineWidth(context, lineWidth);
  CGContextAddArc(context, centerx, centery, self.radius, 0, 2*M_PI, 0);
  CGContextDrawPath(context, kCGPathFillStroke);//绘制填充
```
### 连接过程中在touchesMoved方法中判断是否经过为被选中状态下的圆
```
判断是否经过未被选中状态下的圆
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
```
### 经过圆就调用画圆的方法通过CGContextSetRGBStrokeColor和CGContextAddArc这个两个方法画出选择之后的圆
### 连线的过程中要在touchesMoved方法中调用划直线的方法CGContextMoveToPoint(context, start.x, start.y);CGContextAddLineToPoint(context, end.x, end.y);

### 调用的方法
```
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
```
![image](https://github.com/lsfA1/RecognizerRender/raw/master/RecognizerRender/img/01.png)
![image](https://github.com/lsfA1/RecognizerRender/raw/master/RecognizerRender/img/02.png)
![image](https://github.com/lsfA1/RecognizerRender/raw/master/RecognizerRender/img/03.png)
