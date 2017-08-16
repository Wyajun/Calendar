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
// 显示日期yyyy-mm-dd
-(NSString *)showYYYYMMdd;
// 显示日月MM月DD日
-(NSString *)showMMDD;
//显示日月
- (NSString *)showMM_DD;
//显示星期几
- (NSString *)showWeek;
// M.D
-(NSString *)showMMDD1;
//MM.dd
- (NSString *)showMmDd;
// 字符串转日期 yyyy-mm-dd
+(NSDate *)dateFormString:(NSString *)string;
// 计算两日期之间相隔几天
-(NSInteger)aFewDaysBetweenDate:(NSDate *)endDate;
// 计算两日期之间相隔几月
-(NSInteger)aFewMonthBetweenDate:(NSDate *)endDate;
// 当前零点时间
+(NSDate *)currentDateZeroTime;

-(BOOL)biggerThen:(NSDate *)date;

@end
@interface NSDate (Order)
// 计算两个日期之前的间隔
+ (NSArray *)getOrderRangeStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
+ (NSArray *)getOrderRangeTicketsUseDate:(NSDate *)startDate EndDate:(NSDate *)endDate;
- (NSString *)showWeekZHouWay;
@end

@interface NSDate (villa)
-(NSString *)showVillaDate;
@end

@interface NSDate (specialSaleSecKill)
-(NSString *)showSecKillTime;
@end

@interface NSDate (Date)
// 今天
- (BOOL) isToday;
// 明天
- (BOOL) isTomorrow;
// 后天
- (BOOL) isAfterTomorrow;
- (BOOL)  isYesterday;

+(NSDate *)getToday;

+(NSDate *)getTomorrow;
//判断两个时间是否是同一天
+ (BOOL) isEqualDay:(NSDate*) date1 date:(NSDate*)date2;
@end

