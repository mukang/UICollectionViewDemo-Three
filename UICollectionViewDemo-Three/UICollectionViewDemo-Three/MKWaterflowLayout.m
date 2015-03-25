//
//  MKWaterflowLayout.m
//  UICollectionViewDemo-Three
//
//  Created by 穆康 on 15/3/25.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

#import "MKWaterflowLayout.h"

#define MKCollectionViewWidth self.collectionView.frame.size.width

/** 每一行之间的间距 */
static const CGFloat MK_Default_Row_Margin = 10;

/** 每一列之间的间距 */
static const CGFloat MK_Default_Column_Margin = 10;

/** 每一 section 之间的间距 top, left, bottom, right */
static const UIEdgeInsets MK_Default_Insets = {10, 10, 10, 10};

/** 默认的列数 */
static const CGFloat MK_Default_Column_Count = 3;


@interface MKWaterflowLayout ()

/** 每一列的最大Y值数组 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 这行代码的目的：能够使用点语法 */

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (CGFloat)columnCount;
- (UIEdgeInsets)insets;

@end


@implementation MKWaterflowLayout

#pragma mark - 懒加载

- (NSMutableArray *)columnMaxYs {
    
    if (_columnMaxYs == nil) {
        
        _columnMaxYs = [[NSMutableArray alloc] init];
    }
    
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray {
    
    if (_attrsArray == nil) {
        
        _attrsArray = [[NSMutableArray alloc] init];
    }
    
    return _attrsArray;
}


#pragma mark - 实现内部方法

- (CGSize)collectionViewContentSize {
    
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    
    for (NSUInteger i = 1; i < self.columnMaxYs.count; i ++) {
        
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        if (destMaxY < columnMaxY) {
            
            destMaxY = columnMaxY;
        }
    }
    
    return CGSizeMake(0, destMaxY + self.insets.bottom);
}


- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    
    for (NSUInteger i = 0; i < self.columnCount; i ++) {
        
        [self.columnMaxYs addObject:@(self.insets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attrs];
    }
}


/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrsArray;
}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    // 水平方向上的总间距
    CGFloat xMargin = self.insets.left + self.insets.right + (self.columnCount - 1) * self.columnMargin;
    
    // cell的宽度
    CGFloat w = (MKCollectionViewWidth - xMargin) / self.columnCount;
    
    // cell的高度
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath];
    
    // 找出最短那一列的最大Y值和列号
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    
    NSUInteger destColumn = 0;
    
    for (NSUInteger i = 1; i < self.columnMaxYs.count; i ++) {
        
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        if (destMaxY > columnMaxY) {
            
            destMaxY = columnMaxY;
            
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = self.insets.left + (w + self.columnMargin) * destColumn;
    
    // cell的y值
    CGFloat y = destMaxY;
    
    if (destMaxY != self.insets.top) {
        
        y = destMaxY + self.rowMargin;
    }
    
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}


#pragma mark - 处理代理数据

- (CGFloat)rowMargin {
    
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        
        return [self.delegate rowMarginInWaterflowLayout:self];
    }
    
    return MK_Default_Row_Margin;
}

- (CGFloat)columnMargin {
    
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        
        return [self.delegate columnMarginInWaterflowLayout:self];
    }
    
    return MK_Default_Column_Margin;
}

- (CGFloat)columnCount {
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        
        return [self.delegate columnCountInWaterflowLayout:self];
    }
    
    return MK_Default_Column_Count;
}

- (UIEdgeInsets)insets {
    
    if ([self.delegate respondsToSelector:@selector(insetsInWaterflowLayout:)]) {
        
        return [self.delegate insetsInWaterflowLayout:self];
    }
    
    return MK_Default_Insets;
}

@end
