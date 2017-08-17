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

@property(nonatomic,strong)TJCalendarData *startData;
@property(nonatomic,strong)TJCalendarData *endData;

@property(nonatomic,strong)NSIndexPath *panSelectStartIndexPath;
@property(nonatomic,strong)NSIndexPath *panChangeIndexPath;
@property(nonatomic)BOOL isStartSelected;
@property(nonatomic,strong)TJCalendarDataConfig *configData;

@property(nonatomic,strong)NSMutableArray *selectCalendarDatas;
@property(nonatomic,strong)NSMutableArray *panselectCalendarDatas;
-(void)creatMonthArrs;
-(void)setSelectIndex:(TJCalendarData *)data;
@end

static int indexPaths[] = {0,6,12,18,24,30,36,1,7,13,19,25,31,37,2,8,14,20,26,32,38,3,9,15,21,27,33,39,4,10,16,22,28,34,40,5,11,17,23,29,35,41};

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
        _selectCalendarDatas = [NSMutableArray arrayWithCapacity:10];
        [self creatMonthArrs];
        if (configData.startDate) {
            self.selectStartIndexPath = [NSIndexPath indexPathForRow:[self monthStartOffset:configData.startDate] inSection:[configData.startDate aFewMonthBetweenDate:configData.currentDate]];
        }
        
        if (configData.endDate) {
            self.selectEndIndexPath = [NSIndexPath indexPathForRow:[self monthStartOffset:configData.endDate]  inSection:[configData.endDate aFewMonthBetweenDate:configData.currentDate]];
        }
        
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
    if (self.configData.allowsMultipleSelected ) {
        if (_panSelectStartIndexPath) {
            return;
        }
        if ([self.selectCalendarDatas containsObject:calendarData]) {
            [_selectCalendarDatas removeObject:calendarData];
            self.calendarSelectData(self.selectCalendarDatas,calendarData,NO);
        }else {
            [_selectCalendarDatas addObject:calendarData];
            self.calendarSelectData(self.selectCalendarDatas,calendarData,YES);
        }
        
    }else {
        [self setSelectIndex:calendarData];
        if (self.calendarSelectData) {
            self.calendarSelectData(self.selectCalendarDatas,calendarData,YES);
        }
        
    }
    
}

-(void)creatMonthArrs {
    
}

-(void)setSelectIndex:(TJCalendarData *)data {
    
    NSIndexPath *path = data.path;
    if (self.selectStartIndexPath && self.selectEndIndexPath) {
        self.selectEndIndexPath = nil;
        self.selectStartIndexPath = nil;
        self.selectStartIndexPath = path;
        self.startData = data;
        return ;
    }
    
    if (!self.selectStartIndexPath) {
        self.selectStartIndexPath = path;
        self.startData = data;
        return;
    }
    if (self.selectStartIndexPath.section > path.section) {
        self.selectEndIndexPath = self.selectStartIndexPath;
        self.selectStartIndexPath = path;
        
        self.endData = self.startData;
        self.startData = data;
    }
    if (self.selectStartIndexPath.section == path.section) {
        if (self.selectStartIndexPath.row > path.row) {
            self.selectEndIndexPath = self.selectStartIndexPath;
            self.selectStartIndexPath = path;
            self.endData = self.startData;
            self.startData = data;
        }
        if (self.selectStartIndexPath.row == path.row) {
            return;
        }
    }
    self.selectEndIndexPath = path;
    self.endData = data;
}

-(TJDateCompareResult)compareResultWithCalendarData:(TJCalendarData *)calendarData {
    if (self.configData.allowsMultipleSelected) {
        return TJDateNoCompare;
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

-(TJCalendarLocationType)dataLocationTypeWithIndex:(NSUInteger)index {
    
    NSInteger weekStart = index%7;
    if (weekStart == 0) {
        return  TJCalendarLocationLeft;
    }else if (weekStart == 6) {
        return  TJCalendarLocationRgiht;
    }else {
        return  TJCalendarLocationCenter;
    }
}


-(void)adjustStartDate:(NSDate *)startDate {
    /// 校验输入入日期 日期必须大于等于当前这月的开始日期
    if (_configData.startDate && [startDate biggerThen:_configData.startDate]) {
        _configData.startDate = nil;
    }
    if (_configData.endDate && [startDate biggerThen:_configData.endDate]) {
        _configData.endDate = nil;
    }
    
}

-(void)adjustEndDate:(NSDate *)endDate {
    /// 校验输入入日期 日期必须小于等于最后一天的日期
    if (_configData.startDate && [_configData.startDate biggerThen:endDate]) {
        _configData.startDate = nil;
    }
    if (_configData.endDate && [_configData.endDate biggerThen:endDate]) {
        _configData.endDate = nil;
    }
    /// 开始日期必须大于结束日期
    if (_configData.startDate && _configData.endDate) {
        if ([_configData.startDate biggerThen:_configData.endDate]) {
            _configData.endDate = nil;
        }
    }
    /// 如果开始时间错误则清除结束时间
    if (!_configData.startDate) {
        _configData.endDate = nil;
    }
}


-(void)startPanGestureRecognizerIndexPath:(NSIndexPath *)indexPath {
    [self resetIsStartSelectedWithIndexPath:indexPath];
}

-(void)changePanGestureRecognizerIndexPath:(NSIndexPath *)indexPath {
    [self panChanegeCalendarSelectData:indexPath];
}

-(void)endPanGestureRecognizerIndexPath:(NSIndexPath *)indexPath {
    if(indexPath) {
        [self panChanegeCalendarSelectData:indexPath];
    }
    
    for (TJCalendarData *data in _panselectCalendarDatas) {
        if(_isStartSelected) {
            if ([_selectCalendarDatas containsObject:data]) {
                continue;
            }else {
                [_selectCalendarDatas addObject:data];
            }
        }else {
            [_selectCalendarDatas removeObject:data];
        }
    }
    _panSelectStartIndexPath = nil;
    _panChangeIndexPath = nil;
}

-(void)panChanegeCalendarSelectData:(NSIndexPath *)endIndexPath {
    if (!_panSelectStartIndexPath) {
         [self resetIsStartSelectedWithIndexPath:endIndexPath];
        return;
    }
    if (_panChangeIndexPath) {
        if (_panChangeIndexPath.section == endIndexPath.section && _panChangeIndexPath.row == endIndexPath.row) {
            return;
        }
    }
    _panChangeIndexPath = endIndexPath;
    NSArray *startItems = self.listMonths[_panSelectStartIndexPath.section];
    NSArray *endItems = self.listMonths[endIndexPath.section];
    
    TJCalendarData *startItem = startItems[_panSelectStartIndexPath.row];
    TJCalendarData *endItem = endItems[endIndexPath.row];
    
    NSIndexPath *panStartIndexPath = startItem.path;
    NSIndexPath *panEndIndexPath = endItem.path;
    
    BOOL isSelected = _isStartSelected;
    
    for (TJCalendarData *data in _panselectCalendarDatas) {
        if([_selectCalendarDatas containsObject:data]) {
            self.calendarSelectData(self.selectCalendarDatas,data,YES);
        }else {
            self.calendarSelectData(self.selectCalendarDatas,data,NO);
        }
    }
    _panselectCalendarDatas = [NSMutableArray arrayWithCapacity:10];
    
    if (panStartIndexPath.section > panEndIndexPath.section) {
        panEndIndexPath = startItem.path;
        panStartIndexPath = endItem.path;
    }
    if (panStartIndexPath.section == panEndIndexPath.section) {
        if (panStartIndexPath.row > panEndIndexPath.row) {
            panEndIndexPath = startItem.path;
            panStartIndexPath = endItem.path;
        }
        if (panStartIndexPath.row == panEndIndexPath.row) {
            [self panChangeCalendarData:endItem isSelected:isSelected ];
            return;
        }
    }
    if (panStartIndexPath.section < panEndIndexPath.section) {
        NSArray *items = self.listMonths[panStartIndexPath.section];
        NSInteger count = items.count;
        for (NSInteger row = panStartIndexPath.row ; row < count ; row ++ ) {
            NSInteger column = [self rowReal:row];
            if (column >= count) {
                continue;
            }
            TJCalendarData *data = items[column];
            [self panChangeCalendarData:data isSelected:isSelected ];
        }
    }
    for (NSInteger section = panStartIndexPath.section + 1; section < panEndIndexPath.section; section++) {
        NSArray *items = self.listMonths[section];
        NSInteger count = items.count;
        for (NSInteger row = 0 ; row < count ; row ++ ) {
            NSInteger column = [self rowReal:row];
            if (column >= count) {
                continue;
            }
            TJCalendarData *data = items[column];
            [self panChangeCalendarData:data isSelected:isSelected];
        }
    }
    
    if (panStartIndexPath.section < panEndIndexPath.section) {
        NSArray *items = self.listMonths[panEndIndexPath.section];
        NSInteger count = panEndIndexPath.row;
        for (NSInteger row = 0 ; row <= count ; row ++ ) {
            NSInteger column = [self rowReal:row];
            if (column >= items.count) {
                continue;
            }
            TJCalendarData *data = items[column];
            [self panChangeCalendarData:data isSelected:isSelected];
        }
    }else {
        NSArray *items = self.listMonths[panEndIndexPath.section];
        NSInteger count = panEndIndexPath.row;
        for (NSInteger row = panStartIndexPath.row ; row <= count ; row ++ ) {
            NSInteger column = [self rowReal:row];
            if (column >= items.count) {
                continue;
            }
            TJCalendarData *data = items[column];
            [self panChangeCalendarData:data isSelected:isSelected];
        }
    }
    
    
    
}

-(NSInteger )rowReal:(NSInteger)row {
    if (_calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return row;
    }
    return indexPaths[row];
}
-(void)panChangeCalendarData:(TJCalendarData *)data isSelected:(BOOL)isSelected  {
   
    if (data.dataType != TJCalendarDataEmpty) {
        [_panselectCalendarDatas addObject:data];
        self.calendarSelectData(self.selectCalendarDatas,data,isSelected);
    }

}


-(NSArray *)selectCalendarDatas {
    if (self.configData.allowsMultipleSelected) {
        return _selectCalendarDatas;
    }
    if (self.startData && self.endData) {
        return @[self.startData,self.endData];
    }
    if (self.startData) {
        return @[self.startData];
    }
    return @[];
}

-(void)resetIsStartSelectedWithIndexPath:(NSIndexPath *)path {
    
    if (_panSelectStartIndexPath) {
        return;
    }
    _panSelectStartIndexPath = path;
     NSArray *startItems = self.listMonths[_panSelectStartIndexPath.section];
    TJCalendarData *startItem = startItems[_panSelectStartIndexPath.row];
    _isStartSelected = ![_selectCalendarDatas containsObject:startItem];
    _panselectCalendarDatas = [NSMutableArray array];
}


@end

@implementation TJVerticalCalendarConfigModel

-(void)creatMonthArrs {
    self.listMonths = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = self.configData.currentDate;
    self.startIndexPath = [NSIndexPath indexPathForRow:[self monthStartOffset:currentDate] inSection:0];
    NSDate *monthDate = currentDate;
    NSDate *date = [monthDate monthStartDate];
    [self adjustStartDate:date];
    for (int i = 0; i < self.configData.showMonth; i++) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSUInteger count = date.monthDays;
        NSUInteger weekStart = date.numbersOfWeek;
        for (int w = 0; w < weekStart -1 ; w ++) {
            TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataEmpty locationType:TJCalendarLocationLeft date:[date afterDay:w - weekStart + 1] path:[NSIndexPath indexPathForRow:w inSection:i] currentMonthDate:NO];
            self.configData.calendarData(calendarData);
            [list addObject:calendarData];
        }
        NSDate *sDate = date;
        for (int j = 0; j < count; j++) {
            
            TJCalendarLocationType locationType = TJCalendarLocationCenter;
            if (j == 0) {
                locationType = TJCalendarLocationLeft;
            }else if (j == count - 1) {
                locationType = TJCalendarLocationRgiht;
            }else {
                locationType = [self dataLocationTypeWithIndex:list.count];
            }
            
            TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataContent locationType:locationType date:sDate path:[NSIndexPath indexPathForRow:list.count inSection:i] currentMonthDate:YES];
            self.configData.calendarData(calendarData);
            [list addObject:calendarData];
            sDate = [sDate afterDay:1];
        }
        weekStart = sDate.numbersOfWeek;
        if (weekStart != 1) {
           for (NSInteger index = weekStart - 1; index < 7; index++) {
                TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataEmpty locationType:TJCalendarLocationLeft date:sDate  path:[NSIndexPath indexPathForRow:list.count inSection:i] currentMonthDate:NO];
                self.configData.calendarData(calendarData);
                [list addObject:calendarData];
                sDate = [sDate afterDay:1];
            }
        }
        
        
        [self.listMonths addObject:list];
        monthDate = [monthDate afterMonth:1];
        date = [monthDate monthStartDate];
    }
    TJCalendarData *data = [[self.listMonths lastObject] lastObject];
    NSDate *endDate = data.date;
    [self adjustEndDate:endDate];
    
    
}



@end


@implementation TJHorizontalCalendarConfigModel

-(void)creatMonthArrs {
    self.listMonths = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = self.configData.currentDate;
    self.startIndexPath = [NSIndexPath indexPathForRow:[self monthStartOffset:currentDate] inSection:0];
    
    NSDate *monthDate = currentDate;
    NSDate *startDate = [currentDate monthStartDate];
    
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
                
                NSInteger row = w*7 + wday ;
                if ( (w == 0 && wday < weekStart - 1) || row > monthCount) {
                    TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataEmpty locationType:TJCalendarLocationLeft date:weekDate path:[NSIndexPath indexPathForRow:row inSection:i] currentMonthDate:NO];
                    self.configData.calendarData(calendarData);
                    [list addObject:calendarData];
                }else  {
                    
                    TJCalendarLocationType locationType = TJCalendarLocationCenter;
                    if (wday == 0) {
                        locationType = TJCalendarLocationLeft;
                    }else if (wday == 6) {
                        locationType = TJCalendarLocationRgiht;
                    }else {
                        locationType = [self dataLocationTypeWithIndex:row];
                    }
                    TJCalendarData *calendarData = [[self.configData.calendarDataClass alloc] initWithDateType:TJCalendarDataContent locationType:locationType date:weekDate path:[NSIndexPath indexPathForRow:row inSection:i] currentMonthDate:YES];
                    self.configData.calendarData(calendarData);
                    [list addObject:calendarData];
                }
               weekDate = [weekDate afterDay:7];
            }
        }
      [self.listMonths addObject:list];
      monthDate = [monthDate afterMonth:1];
    }
    NSDate *endDate = [[monthDate monthStartDate] afterDay:-1];
    
    [self adjustStartDate:startDate];
    [self adjustEndDate:endDate];
    
    
}



@end

@implementation TJCalendarDataConfig



@end



@implementation TJCalendarViewConfig

@end





