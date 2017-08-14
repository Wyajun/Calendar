//
//  TJGridView.h
//  日历控件
//
//  Created by 王亚军 on 16/5/25.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJGeneralGridView : UIView
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,copy)void (^gridSelectIndexPath)(NSIndexPath *indexpath);
@property(nonatomic)CGSize itemSize;
@property(nonatomic)CGFloat lineSpace;
@property(nonatomic)CGFloat rowSpace;
-(void)reloadData;
@end


@protocol gridViewCellProtocol <NSObject>

-(void)setCellData:(id)data;
@end

@interface UICollectionViewCell (gridViewCell)<gridViewCellProtocol>

@end