//
//  TJCalendarHeaderView.m
//  日历控件
//
//  Created by 王亚军 on 16/5/24.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarHeaderView.h"
#import "TJCalendarConfigModel.h"
#import "masonry.h"
#import "TJCalendarData.h"
#import "CalendarDateUtil.h"
@interface TJCalendarHeaderView()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)TJCalendarData *item;
@end
@implementation TJCalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setup];
    }
    return self;
}
-(void)setup {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont boldSystemFontOfSize:16];
    _titleLab.textColor =  [UIColor blueColor];
    [self addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(30);
    }];
    NSArray *weeks = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *tmpView = self;
    for (NSString *weektitle in weeks) {
        UILabel *weekLab = [[UILabel alloc] init];
        weekLab.text = weektitle;
        weekLab.textAlignment = NSTextAlignmentCenter;
        weekLab.font = [UIFont systemFontOfSize:15];
        weekLab.textColor = [UIColor blueColor];
        [self addSubview:weekLab];
        [weekLab mas_makeConstraints:^(MASConstraintMaker *make) {
          
            make.top.mas_equalTo(_titleLab.mas_bottom).with.offset(30);
            make.height.mas_equalTo(20);
            if (tmpView != self) {
                make.width.equalTo(tmpView.mas_width);
                make.left.mas_equalTo(tmpView.mas_right);
            }else {
                make.left.mas_equalTo(tmpView);
            }
        }];
        tmpView = weekLab;
    }
    [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
    }];
}

-(void)setData:(TJCalendarData *)data {
     NSString *title = [NSString stringWithFormat:@"%@年%@月",@([data.date yearWithDate]),@([data.date monthWithDate])];
     _titleLab.text = title;
    _item = data;
}
-(TJCalendarData *)data {
    return _item;
}

@end
