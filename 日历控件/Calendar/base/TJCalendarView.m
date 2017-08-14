//
//  TJCalendarView.m
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJCalendarView.h"
#import "CalendarDateUtil.h"
#import "TJCalendarConfigModel.h"
#import "TJCalendarHeaderViewProtocol.h"
#import "TJCalendarData.h"
#import "masonry.h"
#import "TJCalendarCellProtocol.h"
@interface TJCalendarView()
@property(nonatomic,strong)UIScrollView *headerScrollView;
@property(nonatomic,strong)UICollectionView *calendarView;
@property(nonatomic,strong)NSArray *months;
@end

@interface TJCalendarView (UICollectionViewDelegate)<UICollectionViewDelegate,UICollectionViewDataSource>
@end

@interface TJCalendarView (ScrollView)<UIScrollViewDelegate>
@end

#define kCalendarCellReuseIdentifier  @"kCalendarCellReuseIdentifier"
#define kCalendarCellHeaderView  @"kCalendarCellHeaderView"
@implementation TJCalendarView


-(void)creatCollectionView {
   
    _calendarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_configModel.calendarViewConfig.flowLayout];
    [_calendarView registerClass:_configModel.calendarViewConfig.calendarCellClass  forCellWithReuseIdentifier:kCalendarCellReuseIdentifier];
    _calendarView.showsVerticalScrollIndicator = NO;
    _calendarView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_calendarView];
    
    NSInteger top = 0;
    if (_configModel.calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        top = _configModel.calendarViewConfig.flowLayout.headerReferenceSize.height;
        [self creatHeadrScrollView];
        
    }else {
        [_calendarView registerClass:_configModel.calendarViewConfig.sectionHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarCellHeaderView];
    }
    
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    _calendarView.delegate = self;
    _calendarView.dataSource = self;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.calendarView.backgroundColor = backgroundColor;
}


-(void)setConfigModel:(TJCalendarConfigModel *)configModel {
    _configModel = configModel;
    _months = configModel.monthArrs;
    [self creatCollectionView];
    
}

-(void)creatHeadrScrollView {
    
    _calendarView.pagingEnabled = YES;
    CGSize size = _configModel.calendarViewConfig.flowLayout.headerReferenceSize;
    _headerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _headerScrollView.contentSize = CGSizeMake(size.width * _configModel.configData.showMonth, size.height);
    [self addSubview:_headerScrollView];
    
    for (NSInteger index = 0; index < _configModel.configData.showMonth; index ++) {
        UICollectionReusableView<TJCalendarHeaderViewProtocol> *headerView = [[_configModel.calendarViewConfig.sectionHeader alloc] initWithFrame:CGRectMake(size.width * index, 0, size.width, size.height)];
        NSArray *list = _configModel.monthArrs[index];
        TJCalendarData *data = list[15];
        headerView.data = data;
        [_headerScrollView addSubview:headerView];
    }
    _configModel.calendarViewConfig.flowLayout.headerReferenceSize = CGSizeZero;
    
    
}

@end

@implementation TJCalendarView (UICollectionViewDelegate)

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _months.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *list = _months[section];
    return list.count;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(self.configModel.calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return nil;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView<TJCalendarHeaderViewProtocol> *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCalendarCellHeaderView forIndexPath:indexPath];
        NSArray *list = _configModel.monthArrs[indexPath.section];
        TJCalendarData *data = list[15];
        headerView.data = data;
        return headerView;
    }
    return nil;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<TJCalendarCellProtocol>* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarCellReuseIdentifier forIndexPath:indexPath];
    NSArray *list = _months[indexPath.section];
    TJCalendarData *data = list[indexPath.row];
    cell.data = data;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *list = _months[indexPath.section];
    TJCalendarData *data = list[indexPath.row];
    [_configModel setSelectCalendarData:data];
    [collectionView reloadData];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *list = _months[indexPath.section];
    TJCalendarData *data = list[indexPath.row];
   
    TJDateCompareResult compareResult = [_configModel compareResultWithCalendarData:data];
    return (compareResult != TJDateCompareLessThanStartDate) && (data.dataType != TJCalendarDataEmpty) ;
}
@end


@implementation TJCalendarView (ScrollView)

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _calendarView) {
        _headerScrollView.contentOffset = _calendarView.contentOffset;
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_configModel.calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal && _configModel.scrollToOffset) {
        _configModel.scrollToOffset(scrollView.contentOffset, scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
@end



