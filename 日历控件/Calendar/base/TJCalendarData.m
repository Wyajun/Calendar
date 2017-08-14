//
//  TJCalendarData.m
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarData.h"

@interface TJCalendarData()
@property(nonatomic)TJCalendarDataType dataType;
@property(nonatomic)TJCalendarLocationType  locationType;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSIndexPath *path;
@property(nonatomic)BOOL isCurrentMonthDate;
@end
@implementation TJCalendarData
-(instancetype)initWithDateType:(TJCalendarDataType)dataType locationType:(TJCalendarLocationType)locationType date:(NSDate *)date path:(NSIndexPath *)path currentMonthDate:(BOOL)isCurrentMonthDate{
    self = [super init];
    if (self) {
        _dataType = dataType;
        _locationType = locationType;
        _date = date;
        _path = path;
        _isCurrentMonthDate = isCurrentMonthDate;
    }
    return self;
}
@end
