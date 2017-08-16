//
//  DateUtil.m
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import "CalendarDateUtil.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
   #define TJDayCalendarUnit  NSDayCalendarUnit
   #define TJMonthCalendarUnit NSMonthCalendarUnit
   #define TJCalendarUnitYear  NSYearCalendarUnit
   #define TJCalendarUnitWeekday NSWeekdayCalendarUnit
#else
   #define TJDayCalendarUnit  NSCalendarUnitDay
   #define TJMonthCalendarUnit NSCalendarUnitMonth
   #define TJCalendarUnitYear  NSCalendarUnitYear
   #define TJCalendarUnitWeekday NSCalendarUnitWeekday
#endif





@implementation NSDate (YJCalender)
- (NSString *)showMmDd{
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"MM.dd";
    });
    return [formatter stringFromDate:self];
}
-(NSString *)dayTitle {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"d";
    });
    return [formatter stringFromDate:self];
}
-(NSString *)dayKey {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"yyyyMMdd";
    });
    return [formatter stringFromDate:self];
}
-(NSString *)showYYYYMMdd {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return [formatter stringFromDate:self];
 
}
+(NSDate *)dateFormString:(NSString *)string {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return [formatter dateFromString:string];
}
-(NSString *)showMMDD {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"M月d日";
    });
    return [formatter stringFromDate:self];
}
- (NSString *)showMM_DD{
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"MM-dd";
    });
    return [formatter stringFromDate:self];

}
- (NSString *)showWeek{
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"EEEE";
    });
    return [formatter stringFromDate:self];
}


-(NSString *)showMMDD1 {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"M.d";
    });
    return [formatter stringFromDate:self];
}

-(NSUInteger)monthDays {
    NSCalendar *calendar = [NSDate calendar];
    
    NSRange range = [calendar rangeOfUnit:TJDayCalendarUnit inUnit:TJMonthCalendarUnit forDate:self];
    
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;

}

-(NSInteger)monthOffset {
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *comps = [calendar components:TJDayCalendarUnit fromDate:self];
    return  comps.day;
}

-(NSInteger)monthWithDate
{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *comps = [calendar components:TJMonthCalendarUnit fromDate:self];
    return  comps.month;
}
-(NSInteger)yearWithDate
{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *comps = [calendar components:TJCalendarUnitYear fromDate:self];
    return  comps.year;
}
- (NSInteger)dayWithDate{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *comps = [calendar components:TJCalendarUnitYear fromDate:self];
    return  comps.day;
}
-(NSInteger)numbersOfWeek
{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *comps = [calendar components:TJCalendarUnitWeekday fromDate:self];
    return  comps.weekday;
}
-(NSDate *)afterDay:(NSInteger)days
{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = days;
    return  [calendar dateByAddingComponents:dayComponent toDate:self options:0];
}
-(NSDate *)afterMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSDate calendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.month = month;
    return  [calendar dateByAddingComponents:dayComponent toDate:self options:0];
}

-(NSDate *)monthStartDate
{
    NSCalendar *calendar = [NSDate calendar];
    NSInteger monthNumber = [self monthWithDate];
    NSInteger yearNumber = [self yearWithDate];
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:1];
    [dateComponentsForDate setMonth:monthNumber];
    [dateComponentsForDate setYear:yearNumber];
    NSDate *date =  [calendar dateFromComponents:dateComponentsForDate];
    return date;
    
}
+(NSDate *)currentDateZeroTime {
    
    NSDate *date = [NSDate date];
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    NSString *dateSting =  [formatter stringFromDate:date];
    return [formatter dateFromString:dateSting];
}
-(NSInteger)aFewDaysBetweenDate:(NSDate *)endDate {
    NSCalendar *gregorian = [NSDate calendar];
    NSDateComponents *comps = [gregorian components:TJDayCalendarUnit fromDate:self toDate:endDate  options:0];
    return comps.day;
}
-(NSInteger)aFewMonthBetweenDate:(NSDate *)endDate {
    NSInteger currentYear = self.yearWithDate;
    NSInteger currentMonth = self.monthWithDate;
    
    NSInteger endYear = endDate.yearWithDate;
    NSInteger endMonth = endDate.monthWithDate;
    
    return (currentYear - endYear)*12 + currentMonth - endMonth;

}

+(NSCalendar *)calendar {
    
    static  NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [calendar setFirstWeekday:1];
        NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [calendar setTimeZone:destinationTimeZone];
        
    });
    
    return calendar;
    
}

-(BOOL)biggerThen:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

@end
@implementation NSDate (Order)

+ (NSArray *)getOrderRangeStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate{
    //  计算两个日期之间的 差距
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSDate *currentDate = [NSDate currentDateZeroTime];
    
    NSInteger day = [startDate aFewDaysBetweenDate:currentDate];
    NSInteger days = [startDate aFewDaysBetweenDate:endDate];
    int  currentStart = 0;
    if (day == 0) {
        currentStart = 1;
    }
    
    
    for ( int i=currentStart; i<=days; i++) {
        NSDate *date = [startDate afterDay:i];
        [array addObject:date];
    }
    return array;
}
+ (NSArray *)getOrderRangeTicketsUseDate:(NSDate *)startDate EndDate:(NSDate *)endDate{

    //  计算两个日期之间的 差距
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSInteger days = [startDate aFewDaysBetweenDate:endDate];
    for ( int i=0; i<=days; i++) {
        NSDate *date = [startDate afterDay:i];
        [array addObject:date];
    }
    return array;

}
- (NSString *)showWeekZHouWay{
    NSArray *array= @[@"",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    return [array objectAtIndex:[self numbersOfWeek]];
}



@end

@implementation NSDate (villa)

-(NSString *)showVillaDate {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"yyyy.MM.dd";
    });
    return [formatter stringFromDate:self];
}

@end

@implementation NSDate (specialSaleSecKill)

-(NSString *)showSecKillTime {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"HH:MM";
    });
    return [formatter stringFromDate:self];

}

@end

@implementation NSDate (Date)

//判断两个时间是否是同一天
+ (BOOL) isEqualDay:(NSDate*) date1 date:(NSDate*)date2
{
    NSString* date1Str = [date1 showYYYYMMdd];
    NSString* date2Str = [date2 showYYYYMMdd];
    if ([date1Str isEqualToString:date2Str]) {
        return YES;
    }
    return NO;
}

// 今天
- (BOOL) isToday {
    
    NSDate* today = [NSDate getToday];
    return [NSDate isEqualDay:self date:today];
}

// 明天
- (BOOL) isTomorrow {
    NSDate* today = [NSDate getTomorrow];
    return [NSDate isEqualDay:self date:today];
}
-(BOOL)isYesterday {
   
    NSDate* today = [NSDate getYesterday];
    return [NSDate isEqualDay:self date:today];
}
// 后天
- (BOOL) isAfterTomorrow {
    
    NSDate* today = [NSDate getAfterTomorrow];
    return [NSDate isEqualDay:self date:today];
}

+(NSDate *)getToday {
    return [NSDate date];
}

+(NSDate *)getTomorrow {
    NSDate* tomorrow = [[NSDate alloc]initWithTimeIntervalSinceNow: 86400];// 明天
    return tomorrow;
}
+(NSDate *)getYesterday {
    NSDate* tomorrow = [[NSDate alloc]initWithTimeIntervalSinceNow: -86400];// 昨天
    return tomorrow;
}
+(NSDate *)getAfterTomorrow {
    NSDate* afterTomorrow = [[NSDate alloc]initWithTimeIntervalSinceNow: 172800];//后天
    return afterTomorrow;
}
@end









