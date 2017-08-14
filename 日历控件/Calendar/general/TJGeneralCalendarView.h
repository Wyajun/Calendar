//
//  TJGeneralCalendarView.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJGeneralCalendarConfigData.h"
@interface TJGeneralCalendarView : UIView

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

/**
 ** 所有选中的TJCalendarData
 ** 不是多选则正序排列 负责乱序
 **
 */
@property(nonatomic,strong,readonly)NSArray *selectCalendarDatas;

-(instancetype)initWithFrame:(CGRect)frame calendarConfigData:(TJGeneralCalendarConfigData *)configData;
@end
