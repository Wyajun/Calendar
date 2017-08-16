//
//  TJCalendarCellProtocol.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 日期与选中日期直接的比较结果
typedef NS_ENUM(NSUInteger,TJDateCompareResult)
{
    /// 还没有选择开始或结束
    TJDateCompareNone = 0,
    /// 小于初始化日期
    TJDateCompareLessThanStartDate = 1,
    /// 小于左侧
    TJDateCompareLessThanLeft = 2,
    /// 左侧
    TJDateCompareLeft = 3 ,
    /// 包含
    TJDateCompareContains = 4 ,
    /// 右侧
    TJDateCompareRight = 5,
    /// 大于右侧
    TJDateCompareGreaterThanRight = 6,
    /// 支持多选
    TJDateNoCompare = 7,
};

@class TJCalendarData;
@protocol TJCalendarCellProtocol <NSObject>

-(void)resetCalendarData:(TJCalendarData *)data compareResult:(TJDateCompareResult)compareResult;

@end
