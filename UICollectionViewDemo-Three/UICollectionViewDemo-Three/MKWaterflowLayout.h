//
//  MKWaterflowLayout.h
//  UICollectionViewDemo-Three
//
//  Created by 穆康 on 15/3/25.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKWaterflowLayout;

@protocol MKWaterflowLayoutDelegate <NSObject>

@required
/**
 * 返回indexPath位置cell的宽高比
 */
- (CGFloat)waterflowLayout:(MKWaterflowLayout *)waterflowLayout widthHeightRatioForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/** 返回每一行之间的间距 */
- (CGFloat)rowMarginInWaterflowLayout:(MKWaterflowLayout *)waterflowLayout;

/** 返回每一列之间的间距 */
- (CGFloat)columnMarginInWaterflowLayout:(MKWaterflowLayout *)waterflowLayout;

/** 返回列数 */
- (CGFloat)columnCountInWaterflowLayout:(MKWaterflowLayout *)waterflowLayout;

/** 返回每一 section 之间的间距 top, left, bottom, right */
- (UIEdgeInsets)insetsInWaterflowLayout:(MKWaterflowLayout *)waterflowLayout;

@end

@interface MKWaterflowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MKWaterflowLayoutDelegate> delegate;

@end
