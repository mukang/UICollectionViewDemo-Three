//
//  MKCollectionViewController.m
//  UICollectionViewDemo-Three
//
//  Created by 穆康 on 15/3/25.
//  Copyright (c) 2015年 穆康. All rights reserved.
//

#import "MKCollectionViewController.h"
#import "MKWaterflowLayout.h"

@interface MKCollectionViewController () <UICollectionViewDataSource, MKWaterflowLayoutDelegate>

@end

@implementation MKCollectionViewController

static NSString * const ID = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKWaterflowLayout *layout = [[MKWaterflowLayout alloc] init];
    
    layout.delegate = self;
    
    // 切换布局
    self.collectionView.collectionViewLayout = layout;
    
    
}

#pragma mark - <MKWaterflowLayoutDelegate>

- (CGFloat)waterflowLayout:(MKWaterflowLayout *)waterflowLayout widthHeightRatioForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat m = 10;
    
    return m / (arc4random_uniform(20) + 1);
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>



@end
