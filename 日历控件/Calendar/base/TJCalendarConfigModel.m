//
//  TJCalendarConfigModel.m
//  日历控件
//
//  Created by 王亚军 on 16/5/24.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarConfigModel.h"
#import "CalendarDateUtil.h"
#import "CalendarDateUtil.h"
#import "TJCalendarData.h"


@interface TJCalendarConfigModel()
@property(nonatomic,strong)NSMutableArray *listMonths;
@property(nonatomic,strong)NSIndexPath *startIndexPath;
@property(nonatomic,strong)NSIndexPath *selectStartIndexPath;
@property(nonatomic,strong)NSIndexPath *selectEndIndexPath;
@property(nonatomic,strong)TJCalendarDataConfig *configData;
-(void)creatMonthArrs;
-(void)setSelectIndex:(NSIndexPath *)path;
@end

@interface TJHorizontalCalendarConfigModel:TJCalendarConfigModel

@end
@interface TJVerticalCalendarConfigModel:TJCalendarConfigModel

@end


@implementation TJCalendarConfigModel

+(instancetype)configModelWithCalendarConfigData:(TJCalendarDataConfig *)configData calendarViewConfig:(TJCalendarViewConfig *)calendarViewConfig {
    if (calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return [[TJHorizontalCalendarConfigModel alloc] initWithCalendarConfigData:configData calendarViewConfig:calendarViewConfig];
    }
    return [[TJVerticalCalendarConfigModel alloc] initWithCalendarConfigData:configData calendarViewConfig:calendarViewConfig];
}

-(instancetype)initWithCalendarConfigData:(TJCalendarDataConfig *)configData calendarViewConfig:(TJCalendarViewConfig *)calendarViewConfig{
    self = [super init];
    if (self) {
        _configData = configData;
        _calendarViewConfig = calendarViewConfig;
        [self creatMonthArrs];
    }
    return self;
}

-(NSInteger)monthStartOffset:(NSDate *)date {
    NSUInteger weekStart = [date monthStartDate].numbersOfWeek;
    NSInteger monthOffset = [date monthOffset];
    return monthOffset + weekStart -2;
    
}
-(NSArray *)monthArrs {
    return [self.listMonths copy];
}

-(void)setSelectCalendarData:(TJCalendarData *)calendarData {
    if (self.configData.allowsMultipleSelected) {
        if ([self.listMonths containsObject:calendarData]) {
            [self.listMonths removeObject:calendarData];
            self.calendarSelectData(self.selectCalendarDatas,calendarData,NO);
        }else {
            [self.listMonths addObject:calendarData];
            self.calendarSelectData(self.selectCalendarDatas,calendarData,YES);
        }
        
    }else {
        [self setSelectIndex:calendarData.path];
        if (self.calendarSelectData) {
            self.calendarSelectData(self.selectCalendarDatas,calendarData,YES);
        }
        
    }
    
}

-(void)setSelectIndex:(NSIndexPath *)path {
    
}

-(void)creatMonthArrs {
    
}
-(TJDateCompareResult)compareResultWithCalendarData:(TJCalendarData *)TJCalendarData {
    return -1;
}
@end

@implementation TJVerticalCalendarConfigModel

-(void)creatMonthArrs {
    self.listMonths = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = self.configData.currentDate;
    
    NSDate *date = [currentDate monthStartDate];
    for (int i = 0; i < self.configData.showMonth; i++) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSUInteger count = date.monthDays;
        NSUInteger weekStart = date.numbersOfWeek;
        for (int w = 0; w < weekStart -1 ; w ++) {
            TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataEmpty locationType:TJCalendarLocationLeft date:[date afterDay:w - weekStart] path:[NSIndexPath indexPathForRow:w inSection:i] currentMonthDate:NO];
            self.configData.calendarData(calendarData);
            calendarData.configModel = self;
            [list addObject:calendarData];
        }
        NSDate *sDate = date;
        for (int j = 0; j < count; j++) {
            TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataContent locationType:TJCalendarLocationRgiht date:sDate path:[NSIndexPath indexPathForRow:list.count inSection:i] currentMonthDate:YES];
            self.configData.calendarData(calendarData);
            calendarData.configModel = self;
            [list addObject:calendarData];
            sDate = [sDate afterDay:1];
        }
        [self.listMonths addObject:list];
        date = [date afterMonth:1];
    }
}

-(void)setSelectIndex:(NSIndexPath *)path {
    
    if (self.selectStartIndexPath && self.selectEndIndexPath) {
        self.selectEndIndexPath = nil;
        self.selectStartIndexPath = nil;
        self.selectStartIndexPath = path;
        return ;
    }
    
    if (!self.selectStartIndexPath) {
        self.selectStartIndexPath = path;
        return;
    }
    if (self.selectStartIndexPath.section > path.section) {
        self.selectEndIndexPath = self.selectStartIndexPath;
        self.selectStartIndexPath = path;
    }
    if (self.selectStartIndexPath.section == path.section) {
        if (self.selectStartIndexPath.row > path.row) {
            self.selectEndIndexPath = self.selectStartIndexPath;
            self.selectStartIndexPath = path;
        }
        if (self.selectStartIndexPath.row == path.row) {
            return;
        }
    }
    self.selectEndIndexPath = path;
    
}

-(TJDateCompareResult)compareResultWithCalendarData:(TJCalendarData *)calendarData {
    if (self.configData.allowsMultipleSelected) {
        return -1;
    }
    return [self compareWithIndex:calendarData.path];
}

-(TJDateCompareResult )compareWithIndex:(NSIndexPath *)indexpath {
    if ((indexpath.section == self.startIndexPath.section)) {
        if (indexpath.row < self.startIndexPath.row) {
            return TJDateCompareLessThanStartDate;
        }
    }
    if(!self.selectStartIndexPath) {
        return TJDateCompareNone;
    }
    if (indexpath.section < self.selectStartIndexPath.section) {
        return TJDateCompareNone;
    }
    if ((indexpath.section == self.selectStartIndexPath.section)) {
        if (indexpath.row < self.selectStartIndexPath.row) {
            return TJDateCompareLessThanLeft;
        }
        if (indexpath.row == self.selectStartIndexPath.row) {
            return TJDateCompareLeft;
        }
    }
    if(!self.selectEndIndexPath) {
        return TJDateCompareNone;
    }
    
    if (indexpath.section < self.selectEndIndexPath.section) {
        return TJDateCompareContains;
    }
    
    if ((indexpath.section == self.selectEndIndexPath.section)) {
        if (indexpath.row > self.selectEndIndexPath.row) {
            return TJDateCompareGreaterThanRight;
        }
        if (indexpath.row == self.selectEndIndexPath.row) {
            return TJDateCompareRight;
        }
        if (indexpath.row < self.selectEndIndexPath.row) {
            return TJDateCompareContains;
        }
    }
    return TJDateCompareGreaterThanRight;
    
}

@end


@implementation TJHorizontalCalendarConfigModel

-(void)creatMonthArrs {
    self.listMonths = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = self.configData.currentDate;
    
    NSDate *monthDate = currentDate;
    for (int i = 0; i < self.configData.showMonth; i++) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSDate *date = [monthDate monthStartDate];
        NSUInteger count = date.monthDays;
        NSUInteger weekStart = date.numbersOfWeek;
        NSDate *sdate = [date afterDay:-weekStart+1];
        for (NSInteger wday = 0; wday < 7; wday++) {
            NSDate *weekDate = [sdate afterDay:wday];
            NSInteger monthCount = weekStart + count -2;
            for (NSInteger w = 0; w < 6; w++) {
                if ( (w == 0 && wday < weekStart - 1) || wday + w*7 > monthCount) {
                    TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataEmpty locationType:TJCalendarLocationLeft date:weekDate path:[NSIndexPath indexPathForRow:w + wday * 6 inSection:i] currentMonthDate:NO];
                    self.configData.calendarData(calendarData);
                    calendarData.configModel = self;
                    [list addObject:calendarData];
                }else  {
                    TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataContent locationType:TJCalendarLocationRgiht date:weekDate path:[NSIndexPath indexPathForRow:list.count inSection:i] currentMonthDate:YES];
                    self.configData.calendarData(calendarData);
                    calendarData.configModel = self;
                    [list addObject:calendarData];
                }
               weekDate = [weekDate afterDay:7];
            }
        }
      [self.listMonths addObject:list];
      monthDate = [monthDate afterMonth:1];
    }
}

-(void)setSelectIndex:(NSIndexPath *)path {
    
    if (self.selectStartIndexPath && self.selectEndIndexPath) {
        self.selectEndIndexPath = nil;
        self.selectStartIndexPath = nil;
        self.selectStartIndexPath = path;
        return ;
    }
    
    if (!self.selectStartIndexPath) {
        self.selectStartIndexPath = path;
        return;
    }
    if (self.selectStartIndexPath.section > path.section) {
        self.selectEndIndexPath = self.selectStartIndexPath;
        self.selectStartIndexPath = path;
    }
    if (self.selectStartIndexPath.section == path.section) {
        if (self.selectStartIndexPath.row > path.row) {
            self.selectEndIndexPath = self.selectStartIndexPath;
            self.selectStartIndexPath = path;
        }
        if (self.selectStartIndexPath.row == path.row) {
            return;
        }
    }
    self.selectEndIndexPath = path;
}

-(TJDateCompareResult)compareResultWithCalendarData:(TJCalendarData *)calendarData {
    if (self.configData.allowsMultipleSelected) {
        return -1;
    }
    return [self compareWithIndex:calendarData.path];
}

-(TJDateCompareResult )compareWithIndex:(NSIndexPath *)indexpath {
    if ((indexpath.section == self.startIndexPath.section)) {
        if (indexpath.row < self.startIndexPath.row) {
            return TJDateCompareLessThanStartDate;
        }
    }
    if(!self.selectStartIndexPath) {
        return TJDateCompareNone;
    }
    if (indexpath.section < self.selectStartIndexPath.section) {
        return TJDateCompareNone;
    }
    if ((indexpath.section == self.selectStartIndexPath.section)) {
        if (indexpath.row < self.selectStartIndexPath.row) {
            return TJDateCompareLessThanLeft;
        }
        if (indexpath.row == self.selectStartIndexPath.row) {
            return TJDateCompareLeft;
        }
    }
    if(!self.selectEndIndexPath) {
        return TJDateCompareNone;
    }
    
    if (indexpath.section < self.selectEndIndexPath.section) {
        return TJDateCompareContains;
    }
    
    if ((indexpath.section == self.selectEndIndexPath.section)) {
        if (indexpath.row > self.selectEndIndexPath.row) {
            return TJDateCompareGreaterThanRight;
        }
        if (indexpath.row == self.selectEndIndexPath.row) {
            return TJDateCompareRight;
        }
        if (indexpath.row < self.selectEndIndexPath.row) {
            return TJDateCompareContains;
        }
    }
    return TJDateCompareGreaterThanRight;
    
}

@end

@implementation TJCalendarDataConfig



@end



@implementation TJCalendarViewConfig

@end





