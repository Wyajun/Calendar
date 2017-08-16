//
//  TJCalendarView.h
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJCalendarConfigModel;
@interface TJCalendarView : UIView
@property(nonatomic,strong)TJCalendarConfigModel *configModel;
/// 使开始选中的cell可见
-(void)scrollToStartIndexPath;
@end
