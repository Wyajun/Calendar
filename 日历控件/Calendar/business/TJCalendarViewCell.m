//
//  TJCalendarCell.m
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarViewCell.h"
#import "Masonry.h"
#import "TJCalendarItem.h"

#import "macro.h"


@interface TJCalendarViewCell()
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *contentBackView;
@property(nonatomic,strong)UILabel *dayLab;//显示日期
@property(nonatomic,strong)TJCalendarItem *item;
@end
@implementation TJCalendarViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:_backView];
    
    
    _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.contentView addSubview:_contentBackView];
    
    
    _dayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _dayLab.font = [UIFont systemFontOfSize:15];
    _dayLab.textAlignment = NSTextAlignmentCenter;
    [_contentBackView addSubview:_dayLab];
    
}
-(void)resetCalendarData:(TJCalendarItem *)data compareResult:(TJDateCompareResult)compareResult {
    _item = data;
    _contentBackView.center = self.contentView.center;
//    GADate *date_ = [GADate dateFromNSDate:_data.date];
    //
//    if (_data.holidayTitle.length > 0) {
//        _dayLab.text = _data.holidayTitle;
//        _dayLab.font = kFontPF(10);
//    } else if (date_.isToday || date_.isTommorrow) {
//        _dayLab.text = date_.isToday ? @"今天" :@"明天";
//        _dayLab.font = kFontPF(10);
//    } else {
//        
//    }
    
    _dayLab.text = data.title;
    _dayLab.font = kFontPF(15);
    
    self.backView.backgroundColor = [self contentBackCololWithCompareResult:compareResult dataType:data.dataType];
    _contentBackView.backgroundColor = self.backView.backgroundColor;
    
    _dayLab.textColor = [self titleCololWithCompareResult:compareResult dataType:data.dataType vacantDayValid:YES];
    
    if (compareResult == TJDateCompareLeft && data.locationType != TJCalendarLocationRgiht) {
        [self changeBackViewConstraint:TJCalendarLocationLeft];
    }
    if (compareResult == TJDateCompareRight && data.locationType != TJCalendarLocationLeft) {
        [self changeBackViewConstraint:TJCalendarLocationRgiht];
    }
    if (compareResult == TJDateCompareContains) {
        [self changeBackViewConstraint:data.locationType];
    }
    
    _dayLab.backgroundColor = self.contentBackView.backgroundColor;
}


-(UIColor *)contentBackCololWithCompareResult:(TJDateCompareResult)compareResult dataType:(TJCalendarDataType)dataType {
    if (dataType == TJCalendarDataEmpty) {
        return [UIColor whiteColor];
    }
    switch (compareResult) {
        case TJDateCompareNone:
        case TJDateCompareGreaterThanRight:
        case TJDateCompareLessThanLeft:
            return [UIColor whiteColor];
            break;
        case TJDateCompareLeft:
        case TJDateCompareRight:
            return UIColorFromRGB(0xff6600);
            break;
        case TJDateCompareContains: {
            
            return UIColorFromRGB(0xfec09b);
            break;
        }
        default:
            break;
    }
    return [UIColor clearColor];
}


-(UIColor *)titleCololWithCompareResult:(TJDateCompareResult)compareResult dataType:(TJCalendarDataType)dataType vacantDayValid:(BOOL)vacantDayValid{
    if (dataType == TJCalendarDataEmpty) {
        return [UIColor whiteColor];
    }
    switch (compareResult) {
        case TJDateCompareLessThanStartDate:
            return UIColorFromRGB(0xdadada);
            break;
        case TJDateCompareNone:
        case TJDateCompareLessThanLeft:
        case TJDateCompareGreaterThanRight:{
            if (dataType == TJCalendarDataContent && vacantDayValid) {
                return UIColorFromRGB(0x333333);
            } else {
                return UIColorFromRGB(0xdadada);
            }
        }
            break;
        case TJDateCompareLeft:
        case TJDateCompareContains:
        case TJDateCompareRight:
            return [UIColor whiteColor];
            break;
        default:
            break;
    }
    return [UIColor clearColor];;
}



-(void)changeBackViewConstraint:(TJCalendarLocationType)type {
    switch (type) {
        case TJCalendarLocationLeft: {
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentBackView.mas_centerX);
                make.top.equalTo(self.contentBackView);
                make.right.mas_equalTo(0);
                make.height.equalTo(self.contentBackView);
            }];
            _contentBackView.layer.cornerRadius = 15;
            _contentBackView.clipsToBounds = YES;
        }
            
            break;
        case TJCalendarLocationRgiht: {
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentBackView);
                make.right.equalTo(self.contentBackView.mas_centerX);
                make.left.mas_equalTo(0);
                make.height.equalTo(self.contentBackView);
            }];
            _contentBackView.layer.cornerRadius = 15;
            _contentBackView.clipsToBounds = YES;
        }
            
            break;
        case TJCalendarLocationCenter: {
            [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.top.equalTo(self.contentBackView);
                make.left.mas_equalTo(0);
                make.height.equalTo(self.contentBackView);
            }];
            _contentBackView.layer.cornerRadius = 0;
            _contentBackView.clipsToBounds = NO;
        }
            break;
    }
    
}
@end
