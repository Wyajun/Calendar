//
//  TJGeneralCalendarConfigData.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TJCalendarData;
@interface TJGeneralCalendarConfigData : NSObject

#pragma --mark view设置相关
/// 注册显示的cell
@property(nonatomic,strong)Class calendarCellClass;
/// 注册显示的header
@property(nonatomic,strong)Class sectionHeader;
/// CalendarView的布局 通collectionView
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
/// 日历的滚动方向 默认垂直方向
@property(nonatomic)UICollectionViewScrollDirection scrollDirection;
#pragma --mark 数据相关
/// 开始时间
@property(nonatomic,strong)NSDate *startDate;
/// 当前时间
@property(nonatomic,strong)NSDate *currentDate;
/// 结束时间
@property(nonatomic,strong)NSDate *endDate;
/// 展示月份数量
@property(nonatomic)NSUInteger showMonth;
/// 表示支持多选 默认为NO
@property(nonatomic)BOOL allowsMultipleSelected;
/// 表示支持手势滑动  默认为NO
@property(nonatomic)BOOL allowsSlidingGesture;

/// 返回每个生成的TJCalendarData对象 用于其他初始化
@property(nonatomic,copy)void(^calendarData)(TJCalendarData *calendarData);
/// 日历数据类 必须继承TJCalendarData
@property(nonatomic,strong)Class calendarDataClass;

@end
