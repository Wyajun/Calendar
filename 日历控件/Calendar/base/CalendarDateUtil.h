//
//  DateUtil.h
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDate (YJCalender)
-(NSUInteger)monthDays;
// 对应日期偏移days天
-(NSDate *)afterDay:(NSInteger)days;
// 对应日期偏移month月
-(NSDate *)afterMonth:(NSInteger)month;
// 日期对应的月
-(NSInteger)monthWithDate;
// 日期对应的年
-(NSInteger)yearWithDate;
// 这月的开始日期
-(NSDate *)monthStartDate;
// 日期显示天数
-(NSString *)dayTitle;
// 日期对应的这周的开始日期
-(NSInteger)numbersOfWeek;
// 日期对应的在这月偏移量
-(NSInteger)monthOffset;
// 对应节假日日期的key
-(NSString *)dayKey;
// 显示日月
-(NSString *)showMMDD;
// 计算两日期之间相隔几天
-(NSInteger)aFewDaysBetweenDate:(NSDate *)endDate;
// 计算两日期之间相隔几月
-(NSInteger)aFewMonthBetweenDate:(NSDate *)endDate;
@end
