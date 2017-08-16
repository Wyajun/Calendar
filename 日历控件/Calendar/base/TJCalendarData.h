//
//  TJCalendarData.h
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 控制日历显示边界问题 只要用于月开始空白和月末空白
typedef NS_ENUM(NSInteger, TJCalendarDataType) {
    TJCalendarDataEmpty = 0,   //不显示
    TJCalendarDataContent = 1,  // 内容
};

/// 当前日期在最左边 最右边 中间
typedef NS_ENUM(NSInteger, TJCalendarLocationType) {
    TJCalendarLocationLeft = 0,   //
    TJCalendarLocationCenter = 1,  //
    TJCalendarLocationRgiht = 2,
};

@interface TJCalendarData : NSObject
@property(nonatomic,readonly)TJCalendarDataType dataType;
@property(nonatomic,readonly)TJCalendarLocationType  locationType;
@property(nonatomic,strong,readonly)NSDate *date;
@property(nonatomic,strong,readonly)NSIndexPath *path;
/// 是不是包含在当前月中
@property(nonatomic,readonly)BOOL isCurrentMonthDate;
-(instancetype)initWithDateType:(TJCalendarDataType)dataType locationType:(TJCalendarLocationType )locationType date:(NSDate *)date path:(NSIndexPath *)path currentMonthDate:(BOOL)isCurrentMonthDate;
@end
