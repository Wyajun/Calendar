//
//  TJCalendarConfigModel.h
//  日历控件
//
//  Created by 王亚军 on 16/5/24.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TJCalendarCellProtocol.h"

@class TJCalendarData;

@class TJCalendarDataConfig,TJCalendarViewConfig;

@interface TJCalendarConfigModel : NSObject

+(instancetype)configModelWithCalendarConfigData:(TJCalendarDataConfig *)configData calendarViewConfig:(TJCalendarViewConfig *)calendarViewConfig;
/// 当前的月数数据
@property(nonatomic,strong,readonly)NSArray *monthArrs;
/// 所有选中的TJCalendarData
@property(nonatomic,strong,readonly)NSArray *selectCalendarDatas;
/// view配置
@property(nonatomic,strong,readonly)TJCalendarViewConfig *calendarViewConfig;
/// 数据配置
@property(nonatomic,strong,readonly)TJCalendarDataConfig *configData;
/// 开始的选中indexpath 不支持多选
@property(nonatomic,strong,readonly)NSIndexPath *selectStartIndexPath;
/*
 选中calendarData 如果allowsMultipleSelection为YES则会取消calendarData
 其他请看实现逻辑
 */
-(void)setSelectCalendarData:(TJCalendarData *)calendarData;
/// 比较当前日期设置日期的位置 具体请看实现逻辑
-(TJDateCompareResult)compareResultWithCalendarData:(TJCalendarData *)TJCalendarData;

/// 手势滑动使用
/// 手势第一个接触到的item
-(void)startPanGestureRecognizerIndexPath:(NSIndexPath *)indexPath;
/// 手势改变
-(void)changePanGestureRecognizerIndexPath:(NSIndexPath *)indexPath;
/// 手势最后接触到的item
-(void)endPanGestureRecognizerIndexPath:(NSIndexPath *)indexPath;

#pragma --mark 回调
/* 但有日期变更的时候，会回调此方法
 * calendarDatas 现有保存的日期 allowsMultipleSelection 为NO 按时间大小排序 其他无序
 * calendarData  此刻选中的数据
 * isSelect      是取消还是添加
 */
@property(nonatomic,copy)void(^calendarSelectData)(NSArray <TJCalendarData *>*calendarDatas,TJCalendarData *calendarData, BOOL isSelect);



/**
 *横向分页回调
 */
@property(nonatomic,copy)void (^scrollToOffset)(CGPoint offset,NSInteger index);
@end


@interface TJCalendarDataConfig : NSObject
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

@interface TJCalendarViewConfig : NSObject
@property(nonatomic,strong)Class calendarCellClass;
@property(nonatomic,strong)Class sectionHeader;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@end






