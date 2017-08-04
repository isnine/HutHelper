//
//  JRWaterFallLayout.m
//  WaterFallLayout
//
//  Created by sky on 16/6/6.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JRWaterFallLayout.h"

/** 默认参数 */
static const CGFloat JRDefaultColumnCount = 2; // 列数
static const CGFloat JRDefaultRowMargin = 10; // 行间距
static const CGFloat JRDefaultColumnMargin = 16; // 列间距
static const UIEdgeInsets JRDefaultEdgeInsets = {10, 10, 10, 10}; // edgeInsets

@interface JRWaterFallLayout()
{
    struct { // 记录代理是否响应选择子
        BOOL didRespondColumnCount : 1;
        BOOL didRespondColumnMargin : 1;
        BOOL didRespondRowMargin : 1;
        BOOL didRespondEdgeInsets : 1;
    } _delegateFlags;
    
}

/** cell的布局属性数组 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 每列的高度数组 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 最大Y值 */
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation JRWaterFallLayout

#pragma mark - 懒加载

- (NSMutableArray *)columnHeights
{
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - layout方法

/**
 *  准备布局
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 初始化列最大高度数组
    [self setupColumnHeightsArray];
    
    // 初始化item布局属性数组
    [self setupAttrsArray];
    
    // 设置代理方法的标志
    [self setupDelegateFlags];
    
    // 计算最大的Y值
    self.maxY = [self maxYWithColumnHeightsArray:self.columnHeights];
    
}

/**
 *  返回rect范围内的item的布局数组, (这个方法会频繁调用)
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}


/**
 *  返回indexPath位置的item布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 开始计算item的x, y, width, height
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat width = (collectionViewWidth - [self edgeInsets].left - [self edgeInsets].right - ([self columnCount] - 1) * [self columnMargin]) / [self columnCount];
    
    // 计算当前item应该摆放在第几列(计算哪一列高度最短)
    __block NSUInteger minColumn = 0; // 默认是第0列
    __block CGFloat minHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull heightNumber, NSUInteger idx, BOOL * _Nonnull stop) { // 遍历找出最小高度的列
        
        CGFloat height = [heightNumber doubleValue];
        
        if (minHeight > height) {
            minHeight = height;
            minColumn = idx;
        }
    }];
    
    
    CGFloat x = [self edgeInsets].left + minColumn * ([self columnMargin] + width);
    CGFloat y = minHeight + [self rowMargin];
    
    
    CGFloat height = [self.delegate waterFallLayout:self heightForItemAtIndex:indexPath.item width:width];
    
    attrs.frame = CGRectMake(x, y, width, height);
    
    // 更新数组中的最短列的高度
    self.columnHeights[minColumn] = @(y + height);
    
    return attrs;
}


/**
 *  返回collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.maxY + [self edgeInsets].bottom);
}

#pragma mark - 私有方法
/**
 *  因为返回代理方法调用的频率非常频繁, 所以prepareLayout的时候设置一次标志, 调用代理方法的时候就直接判断即可, 可提升效率
 */
- (void)setupDelegateFlags
{
    _delegateFlags.didRespondColumnCount = [self.delegate respondsToSelector:@selector(columnCountOfWaterFallLayout:)];
    
    _delegateFlags.didRespondColumnMargin = [self.delegate respondsToSelector:@selector(columnMarginOfWaterFallLayout:)];
    
    _delegateFlags.didRespondRowMargin = [self.delegate respondsToSelector:@selector(rowMarginOfWaterFallLayout:)];
    
    _delegateFlags.didRespondEdgeInsets = [self.delegate respondsToSelector:@selector(edgeInsetsOfWaterFallLayout:)];
}

- (CGFloat)maxYWithColumnHeightsArray:(NSArray *)array
{
    __block CGFloat maxY = 0;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber  *_Nonnull heightNumber, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([heightNumber doubleValue] > maxY) {
            maxY = [heightNumber doubleValue];
        }
    }];
    return maxY;
}

- (void)setupColumnHeightsArray
{
    // 清空最大高度数组
    [self.columnHeights removeAllObjects];
    
    // 初始化列高度
    for (int i = 0; i < [self columnCount]; i++) {
        [self.columnHeights addObject:@([self edgeInsets].top)];
    }
    
    
}

- (void)setupAttrsArray
{
    // 清空item布局属性数组
    [self.attrsArray removeAllObjects];
    
    // 计算item的attrs
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        @autoreleasepool { // 如果item数目过大容易造成内存峰值提高
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
            [self.attrsArray addObject:attrs];
        }
    }
}

#pragma mark - 根据情况返回参数
- (NSUInteger)columnCount
{
    return _delegateFlags.didRespondColumnCount ? [self.delegate columnCountOfWaterFallLayout:self] : JRDefaultColumnCount;
}

- (CGFloat)columnMargin
{
    return _delegateFlags.didRespondColumnMargin ? [self.delegate columnMarginOfWaterFallLayout:self] : JRDefaultColumnMargin;
}

- (CGFloat)rowMargin
{
    return _delegateFlags.didRespondRowMargin ? [self.delegate rowMarginOfWaterFallLayout:self] : JRDefaultRowMargin;
}

- (UIEdgeInsets)edgeInsets
{
    return _delegateFlags.didRespondEdgeInsets ? [self.delegate edgeInsetsOfWaterFallLayout:self] : JRDefaultEdgeInsets;
}


@end
