//
//  TJGridView.m
//  日历控件
//
//  Created by 王亚军 on 16/5/25.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "TJGeneralGridView.h"
#import "masonry.h"
@interface TJGeneralGridView()
@property(nonatomic,strong) UICollectionView *collectView;
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;
@end
#define reuseIdentifier  @"ReuseIdentifier"
@interface TJGeneralGridView (Delegate)<UICollectionViewDelegate,UICollectionViewDataSource>


@end
@implementation TJGeneralGridView

-(instancetype)initWithCell:(Class)cell {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        
        _collectView.delegate = self;
        _collectView.dataSource = self;
        _collectView.scrollEnabled = NO;
        [self addSubview:_collectView];
        self.backgroundColor = [UIColor whiteColor ];
        [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [_collectView registerClass:cell forCellWithReuseIdentifier:reuseIdentifier];
    }
    return self;
}

-(void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    _layout.itemSize = itemSize;
}

-(void)setLineSpace:(CGFloat)lineSpace {
    _lineSpace = lineSpace;
    _layout.minimumLineSpacing = lineSpace;
}
-(void)setRowSpace:(CGFloat)rowSpace {
    _rowSpace = rowSpace;
    _layout.minimumInteritemSpacing = _rowSpace;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _collectView.backgroundColor = backgroundColor;
}
-(void)reloadData {
    [_collectView reloadData];
}
@end
@implementation TJGeneralGridView (Delegate)

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[UICollectionViewCell alloc] init];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gridSelectIndexPath) {
        self.gridSelectIndexPath(indexPath);
    }
}
@end
@implementation UICollectionViewCell (gridViewCell)
-(void)setCellData:(id)data {
    
}
@end