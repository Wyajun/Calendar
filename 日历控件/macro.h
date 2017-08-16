//
//  macro.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/15.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#ifndef macro_h
#define macro_h

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define kFontPF(x)          [UIFont fontWithName:@"PingFangSC-Light" size:x]

#endif /* macro_h */
