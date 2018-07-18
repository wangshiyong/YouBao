//
//  Macros.h
//  Albatross
//
//  Created by wangshiyong on 2017/11/27.
//  Copyright © 2017年 王世勇. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 屏幕高度 */
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 230
#define NAV_HEIGHT (iphoneX ? 88 : 64)
#define TABBAR_HEIGHT (iphoneX ? 83 : 49)

/*****************  屏幕适配  ******************/
#define iphone5 (kScreenHeight == 568)
#define iphoneX (kScreenHeight == 812)


/** RGB颜色(16进制) */
#define WSYColor_HEX(rgbValue, a) \
[UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((CGFloat)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define WSYColor(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define Color_Wathet  [UIColor colorWithRed:17.0/255.0 green:174.0/255.0 blue:243.0/255.0 alpha:1.0]
#define WSYTheme_Text  [UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0]
#define WSYTheme_Color  [UIColor colorWithRed:255.0/255.0 green:77.0/255.0 blue:78.0/255.0 alpha:1.0]


#define WSYFont(a)  [UIFont systemFontOfSize:a];
#define WSYBoldFont(a)  [UIFont boldSystemFontOfSize:a];

#define GoodsHomeSilderImagesArray @[@"http://gfs5.gomein.net.cn/T1obZ_BmLT1RCvBVdK.jpg",@"http://gfs9.gomein.net.cn/T1C3J_B5LT1RCvBVdK.jpg",@"http://gfs5.gomein.net.cn/T1CwYjBCCT1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1u8V_B4ET1RCvBVdK.jpg",@"http://gfs7.gomein.net.cn/T1zODgB5CT1RCvBVdK.jpg"]

#define HomeBottomViewGIFImage @"http://gfs8.gomein.net.cn/T1RbW_BmdT1RCvBVdK.gif"

#endif /* Macros_h */
