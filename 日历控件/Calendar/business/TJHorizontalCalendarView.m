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

#import "TJCalendarItem.h"
#import "TJCalendarHeaderView.h"
#import "TJCalendarViewCell.h"
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
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    viewConfig.flowLayout = flowlayout;
    viewConfig.sectionHeader =  [TJCalendarHeaderView class];;
    viewConfig.calendarCellClass = [TJCalendarViewCell class];
    
    

    viewConfig.startDate = nil;
    viewConfig.currentDate = [NSDate date];;
    viewConfig.endDate = nil;
    viewConfig.showMonth = 6;
    viewConfig.calendarDataClass = [TJCalendarItem class];
    viewConfig.calendarData = ^(TJCalendarData *calendarData) {
        TJCalendarItem *item = (TJCalendarItem *)calendarData;
        item.title = [calendarData.date showMMDD];
    };
   
    
    TJGeneralCalendarView *calendarView = [[TJGeneralCalendarView alloc] initWithFrame:self.bounds calendarConfigData:viewConfig];
    [self addSubview:calendarView];
    
    calendarView.calendarSelectData = ^(NSArray<TJCalendarData *> *calendarDatas, TJCalendarData *calendarData, BOOL isSelect) {
        NSLog(@"%@",calendarData.date);
    };

    
}


@end
