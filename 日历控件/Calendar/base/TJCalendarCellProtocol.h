//
//  TJCalendarCellProtocol.h
//  日历控件
//
//  Created by 王亚军 on 2017/8/14.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TJCalendarData;
@protocol TJCalendarCellProtocol <NSObject>
@property(nonatomic,strong)TJCalendarData *data;
@end
