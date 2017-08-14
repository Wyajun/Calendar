//
//  TJCalendarViewCell.m
//  日历控件
//
//  Created by 王亚军 on 2017/8/11.
//  Copyright © 2017年 王亚军. All rights reserved.
//

#import "TJCalendarViewCell.h"
#import "masonry.h"
#import "TJCalendarConfigModel.h"
#import "TJCalendarItem.h"
@interface TJCalendarViewCell ()
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *contentBackView;
@property(nonatomic,strong)UILabel *dayLab;//显示日期
@property(nonatomic,strong)UILabel *dayDesc;//显示标签
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
    
    
    _contentBackView = [[UIView alloc] init];
    [self.contentView addSubview:_contentBackView];
    [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _dayLab = [[UILabel alloc] init];
    _dayLab.font = [UIFont systemFontOfSize:15];
    _dayLab.textAlignment = NSTextAlignmentCenter;
    [_contentBackView addSubview:_dayLab];
    
    
    _dayDesc = [[UILabel alloc] init];
    _dayDesc.font = [UIFont systemFontOfSize:11];
    [_contentBackView addSubview:_dayDesc];
}


-(void)setData:(TJCalendarItem *)data {
    
    _item = data;
    _dayDesc.text = @"";
    TJCalendarConfigModel *configModel = data.configModel ;
    _dayLab.text = data.title;
    
    TJDateCompareResult compareResult = [configModel compareResultWithCalendarData:data];
    _dayDesc.textColor = _dayLab.textColor;
    if (compareResult == TJDateCompareLeft || compareResult == TJDateCompareRight) {
        _contentBackView.layer.cornerRadius = 20;
        _contentBackView.clipsToBounds = YES;
        [self.dayLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(0);
        }];
        [self.dayDesc mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dayLab.mas_bottom).with.offset(3);
            make.centerX.mas_equalTo(0);
        }];
        
        
    }else {
        [self.dayLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        _contentBackView.layer.cornerRadius = 0;
        _contentBackView.clipsToBounds = NO;
        //        self.backView.backgroundColor = [configModel backCololWithCompareResult:TJDateCompareNone];
    }
    
    if (compareResult == TJDateCompareLeft) {
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentBackView.mas_centerX);
            make.top.equalTo(self.contentBackView);
            make.right.mas_equalTo(0);
            make.height.equalTo(self.contentBackView);
        }];
        _dayDesc.text = @"入住";
    }
    if (compareResult == TJDateCompareRight) {
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentBackView);
            make.right.equalTo(self.contentBackView.mas_centerX);
            make.left.mas_equalTo(0);
            make.height.equalTo(self.contentBackView);
        }];
        _dayDesc.text = @"离开";
    }
    if (compareResult == TJDateCompareContains) {
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.equalTo(self.contentBackView);
            make.left.mas_equalTo(0);
            make.height.equalTo(self.contentBackView);
        }];
        //         self.backView.backgroundColor = [configModel backCololWithCompareResult:TJDateCompareContains];
    }
    
    if (self.data.dataType == TJCalendarDataEmpty) {
        
        _dayLab.text = @"";
        self.contentBackView.backgroundColor = self.backView.backgroundColor;
    }
    _dayLab.backgroundColor = [UIColor redColor];
    _dayDesc.backgroundColor = _dayLab.backgroundColor;
}
-(TJCalendarItem *)data {
    return _item;
}
-(void)didSelectItemAtCalendarData:(TJCalendarItem *)data {
    
}

@end
