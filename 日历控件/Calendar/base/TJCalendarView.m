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
@property(nonatomic,strong)UIPanGestureRecognizer *panGes;

@property(nonatomic)BOOL isPanStart;
@end

@interface TJCalendarView (UICollectionViewDelegate)<UICollectionViewDelegate,UICollectionViewDataSource>
@end

@interface TJCalendarView (ScrollView)<UIScrollViewDelegate>
@end

@interface TJCalendarView (Gesture)<UIGestureRecognizerDelegate>
- (void)handlePanGestureFrom:(UIPanGestureRecognizer *)recognizer;
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
    
    if (_configModel.configData.allowsSlidingGesture && _configModel.configData.allowsMultipleSelected) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureFrom:)];
        _panGes.minimumNumberOfTouches = 1;
        _panGes.maximumNumberOfTouches = 1;
        _panGes.delegate = self;
        [_calendarView addGestureRecognizer:_panGes];
    }
    
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
    _headerScrollView.userInteractionEnabled = NO;
    _headerScrollView.scrollEnabled = NO;
    _headerScrollView.showsHorizontalScrollIndicator = NO;
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

-(void)scrollToStartIndexPath {
    
    if (_configModel.configData.allowsMultipleSelected) {
        return;
    }
    
    if (!_configModel.selectStartIndexPath) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_configModel.calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            [_calendarView scrollToItemAtIndexPath:_configModel.selectStartIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            
        }else {
            [_calendarView setContentOffset:CGPointMake(_configModel.selectStartIndexPath.section * self.frame.size.width, 0)];
            if (_configModel.scrollToOffset) {
                _configModel.scrollToOffset(_calendarView.contentOffset,_configModel.selectStartIndexPath.section);
            }
        }
    });
   
    
    
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
    [cell resetCalendarData:data compareResult:[_configModel compareResultWithCalendarData:data]];
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


@implementation TJCalendarView (Gesture)

#pragma mark -- PanGestureDelegate
- (void)handlePanGestureFrom:(UIPanGestureRecognizer *)recognizer
{
    
    if (recognizer != _panGes) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:recognizer.view];
    NSIndexPath *indexPath = [self.calendarView indexPathForItemAtPoint:point];
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        [_configModel endPanGestureRecognizerIndexPath:indexPath];
        _calendarView.scrollEnabled = YES;
        return;
    }
    if (indexPath == nil) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [_configModel startPanGestureRecognizerIndexPath:indexPath];
          _calendarView.scrollEnabled = NO;
        return;
    }
      _calendarView.scrollEnabled = NO;
    [_configModel changePanGestureRecognizerIndexPath:indexPath];
    [_calendarView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:_panGes] && [otherGestureRecognizer isEqual:self.calendarView.panGestureRecognizer]){
        return YES;
    }
    return NO;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (!self.configModel.configData.allowsSlidingGesture) {
        return NO;
    }
    if (_panGes == gestureRecognizer) {
        CGPoint translation = [_panGes velocityInView:self.calendarView];
        if (self.configModel.calendarViewConfig.flowLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            return  fabs(translation.y) < fabs(translation.x);
        }
        return fabs(translation.x) < fabs(translation.y);
    }
    return YES;
}
@end




