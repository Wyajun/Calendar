//
//  TJCalendarCell.m
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarDayWithVacantDescCell.h"
#import "Masonry.h"
#import "macro.h"
#import "TJCalendarRoomStatusItem.h"
@interface TJCalendarDayWithVacantDescCell(){
    NSInteger nomalFontSize_;
    NSInteger festivalFontSize_;
    NSInteger megTextFontSize_;
    NSInteger currentFontSize_;
    CGFloat cirleBackViewWidth_;
    CGFloat backViewPosiontX_;
    CGFloat backViewPosiontY_;
    
}
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *contentBackView;
@property(nonatomic,strong)UILabel *dayLab;//显示日期
@property(nonatomic,strong)UILabel *dayDesc;//显示标签
@property(nonatomic) BOOL hasFinishUpdateLayout;
@property(nonatomic,strong)TJCalendarRoomStatusItem *item;
@end
@implementation TJCalendarDayWithVacantDescCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self initCommonConfig];
        [self initView];
    }
    return self;
}

- (void)initCommonConfig
{
    cirleBackViewWidth_ = 36;
    nomalFontSize_ = 14, festivalFontSize_ = 10, megTextFontSize_ = 10;
    backViewPosiontX_ = (self.frame.size.width- cirleBackViewWidth_)/2.f;
    backViewPosiontY_ = (self.frame.size.height - cirleBackViewWidth_)/2.f;
}

- (void)initView{
    
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:_backView];
   
    
    _contentBackView = [[UIView alloc] initWithFrame:CGRectMake(backViewPosiontX_, backViewPosiontY_, cirleBackViewWidth_, cirleBackViewWidth_)];
    _contentBackView.center = self.contentView.center;
    [self.contentView addSubview:_contentBackView];
    
    
    _dayLab = [[UILabel alloc] init];
    _dayLab.font = kFontPF(14);
    _dayLab.textAlignment = NSTextAlignmentCenter;
    [_contentBackView addSubview:_dayLab];

    
    _dayDesc = [[UILabel alloc] init];
    _dayDesc.textAlignment = NSTextAlignmentCenter;
    _dayDesc.font = kFontPF(megTextFontSize_);
    [_contentBackView addSubview:_dayDesc];
}

-(void)resetCalendarData:(TJCalendarRoomStatusItem *)data compareResult:(TJDateCompareResult)compareResult {
    _item = data;
    _contentBackView.center = self.contentView.center;
    
    _dayLab.text = data.title;
    _dayLab.font = kFontPF(15);
     currentFontSize_ = nomalFontSize_;
    if (data.isSelected) {
       self.backView.backgroundColor = UIColorFromRGB(0xfec09b);
    }else {
       self.backView.backgroundColor = [UIColor whiteColor];
    }
    //[self contentBackCololWithCompareResult:compareResult dataType:data.dataType];
    _contentBackView.backgroundColor = self.backView.backgroundColor;
    
    _dayLab.textColor = UIColorFromRGB(0x333333); //[self titleCololWithCompareResult:compareResult dataType:data.dataType vacantDayValid:NO];
    _dayDesc.textColor = UIColorFromRGB(0x333333); //[self titleCololWithCompareResult:compareResult dataType:data.dataType vacantDayValid:NO];
    _dayDesc.text = data.vacantDayDesc;
//    if (compareResult == TJDateCompareLeft && data.locationType != TJCalendarLocationRgiht) {
//        [self changeBackViewConstraint:TJCalendarLocationLeft];
//    }
//    if (compareResult == TJDateCompareRight && data.locationType != TJCalendarLocationLeft) {
//        [self changeBackViewConstraint:TJCalendarLocationRgiht];
//    }
//    if (compareResult == TJDateCompareContains) {
//        [self changeBackViewConstraint:data.locationType];
//    }
    
    _dayLab.backgroundColor = self.contentBackView.backgroundColor;
    _dayDesc.backgroundColor = _dayLab.backgroundColor;
    
    
    //
    [self updateCustomviewsLayout];

}

-(void)updateCustomviewsLayout
{
    CGFloat fontDiffSize = nomalFontSize_ - currentFontSize_;
    CGFloat textSpaceValue = floorf((cirleBackViewWidth_ - currentFontSize_ - megTextFontSize_) / 3);
    CGFloat dayTextPositionY = textSpaceValue + fontDiffSize / 2;
    CGFloat msgTextPositionY = 2 * floorf((cirleBackViewWidth_ - nomalFontSize_ - megTextFontSize_) / 3) + nomalFontSize_;
    CGFloat dayTextWithoutMsgTextPositionY = ( cirleBackViewWidth_ - currentFontSize_ ) / 2.f;
    CGFloat textY_ = self.item.vacantDayDesc.length > 0 ? dayTextPositionY: dayTextWithoutMsgTextPositionY;
    //
    _dayLab.frame = CGRectMake(0, textY_, cirleBackViewWidth_, currentFontSize_);
    if (self.item.vacantDayDesc.length > 0) {
        _dayDesc.frame = CGRectMake(0, msgTextPositionY, cirleBackViewWidth_, megTextFontSize_);
        _dayDesc.hidden = NO;
    } else {
        _dayDesc.hidden = YES;
    }
   
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
                return UIColorFromRGB(0x333333);
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
