//
//  TJCalendarRoomStatusItem.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/15.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "TJCalendarData.h"

@interface TJCalendarRoomStatusItem : TJCalendarData
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *vacantDayDesc;
@property(nonatomic)BOOL isSelected;
@end
