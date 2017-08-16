//
//  TJHorizontalCalendarView.m
//  日历控件
//
//  Created by 王亚军 on 2017/8/11.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "TJHorizontalCalendarView.h"

#import "TJGeneralCalendarView.h"
#import "TJGeneralCalendarConfigData.h"

#import "TJCalendarRoomStatusItem.h"
#import "TJCalendarHeaderView.h"
#import "TJCalendarDayWithVacantDescCell.h"
#import "CalendarDateUtil.h"
@interface TJHorizontalCalendarView ()
@property(nonatomic,strong)TJGeneralCalendarView *calendarView;
@end

@implementation TJHorizontalCalendarView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatCalendarView];
        
    }
    return self;
}

-(void)creatCalendarView {
    TJGeneralCalendarConfigData *viewConfig = [[TJGeneralCalendarConfigData alloc] init];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.headerReferenceSize = CGSizeMake(self.frame.size.width, 121);//头部视图的框架大小
    flowlayout.itemSize = CGSizeMake(self.frame.size.width/7, 40);
    flowlayout.minimumLineSpacing = 0;
    flowlayout.minimumInteritemSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    viewConfig.flowLayout = flowlayout;
    viewConfig.sectionHeader =  [TJCalendarHeaderView class];;
    viewConfig.calendarCellClass = [TJCalendarDayWithVacantDescCell class];
    
    viewConfig.allowsMultipleSelected = YES;
    viewConfig.startDate = [[NSDate date] afterMonth:3];;
    viewConfig.currentDate = [NSDate date];;
    viewConfig.endDate = nil;
    viewConfig.showMonth = 6;
    viewConfig.allowsSlidingGesture = YES;
    viewConfig.calendarDataClass = [TJCalendarRoomStatusItem class];
    viewConfig.calendarData = ^(TJCalendarData *calendarData) {
        TJCalendarRoomStatusItem *item = (TJCalendarRoomStatusItem *)calendarData;
        item.title = [calendarData.date dayTitle];
        item.vacantDayDesc = calendarData.path.row % 2 == 1 ? @"有房": @"无房";
    };
   
    
    TJGeneralCalendarView *calendarView = [[TJGeneralCalendarView alloc] initWithFrame:self.bounds calendarConfigData:viewConfig];
    [self addSubview:calendarView];
    
    calendarView.calendarSelectData = ^(NSArray<TJCalendarData *> *calendarDatas, TJCalendarData *calendarData, BOOL isSelect) {
//        NSLog(@"%@",@(calendarData.path.row));
        TJCalendarRoomStatusItem *item = (TJCalendarRoomStatusItem *)calendarData;
        item.isSelected = isSelect;
    };
     [calendarView scrollToStartIndexPath];
    
}


@end
