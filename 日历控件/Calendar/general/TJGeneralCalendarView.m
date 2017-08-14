//
//  TJGeneralCalendarView.m
//  日历控件
//
//  Created by 王亚军 on 2017/8/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "TJGeneralCalendarView.h"
#import "TJCalendarConfigModel.h"
#import "TJCalendarView.h"
@interface TJGeneralCalendarView ()
@property(nonatomic,strong)TJGeneralCalendarConfigData *configData;
@property(nonatomic,strong)TJCalendarConfigModel *configModel;
@end

@implementation TJGeneralCalendarView

-(instancetype)initWithFrame:(CGRect)frame calendarConfigData:(TJGeneralCalendarConfigData *)configData {
    self = [super initWithFrame:frame];
    if (self) {
        _configData = configData;
        [self initCalendarView];
    }
    return self;
}

-(void)initCalendarView {
    TJCalendarViewConfig *viewConfig = [[TJCalendarViewConfig alloc] init];
   
    viewConfig.flowLayout = _configData.flowLayout;
    viewConfig.sectionHeader =_configData.sectionHeader;
    viewConfig.calendarCellClass = _configData.calendarCellClass;
    
    
    TJCalendarDataConfig *dataConfig = [[TJCalendarDataConfig alloc] init];
    dataConfig.startDate = _configData.startDate;
    dataConfig.currentDate = _configData.currentDate;
    dataConfig.endDate = _configData.endDate;
    dataConfig.showMonth = _configData.showMonth;
    dataConfig.calendarDataClass = _configData.calendarDataClass;
    dataConfig.calendarData = _configData.calendarData;
    dataConfig.allowsMultipleSelected = _configData.allowsMultipleSelected;
    dataConfig.allowsSlidingGesture = _configData.allowsSlidingGesture;
    
    
    TJCalendarConfigModel *configModel = [TJCalendarConfigModel configModelWithCalendarConfigData:dataConfig calendarViewConfig:viewConfig];
    
    TJCalendarView *calendarView = [[TJCalendarView alloc] initWithFrame:self.bounds];
    [self addSubview:calendarView];
    calendarView.configModel = configModel;
    _configModel = configModel;
}

-(NSArray *)selectCalendarDatas {
    return _configModel.selectCalendarDatas;
}

-(void)setCalendarSelectData:(void (^)(NSArray<TJCalendarData *> *, TJCalendarData *, BOOL))calendarSelectData {
    _configModel.calendarSelectData = calendarSelectData;
}
@end
