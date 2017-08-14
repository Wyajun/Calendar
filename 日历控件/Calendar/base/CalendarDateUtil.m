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

-(NSString *)dayTitle {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"dd";
    });
    return [formatter stringFromDate:self];
}
-(NSString *)dayKey {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"YYYYMMdd";
    });
    return [formatter stringFromDate:self];
}
-(NSString *)showMMDD {
    static  NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        formatter.dateFormat = @"MM月dd日";
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
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
            calendar = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
        }else {
            calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        }
        
        [calendar setFirstWeekday:1];
        NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [calendar setTimeZone:destinationTimeZone];
        
    });
    
    return calendar;
    
}

@end
