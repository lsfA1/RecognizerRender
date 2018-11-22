//
//  Macros.h
//  RecognizerRender
//
//  Created by 李少锋 on 2018/11/22.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

//判断是否 IphoneX
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//适配方案
//不同屏幕尺寸字体适配（320，568是因为效果图为IPHONE5 如果不是则根据实际情况修改）
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define Iphone6sPlus_Height                    667.0//iphone6 的屏幕高度
#define Main_Screen_Height_For_Adjustify       (kDevice_Is_iPhoneX ? Iphone6sPlus_Height : Main_Screen_Height)
#define kScreenWidthRatio       (Main_Screen_Width / 375.0)
#define kScreenHeightRatio      (Main_Screen_Height_For_Adjustify / 667.0)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)

#define THEME_COLOR     @"0xffffffff"    //主题颜色
#define COLOR_FFFC2B2D  @"0xfffc2b2d"//红色
#define COLOR_FEE9EA    @"0xfffee9ea"
#define COLOR_FF999999  @"0xff999999"
#define COLOR_F1F1F1    @"0xfff1f1f1"

#define MIN_RECOGNIZER_NUMBER       4

#endif /* Macros_h */
