//
//  JRWaterFallLayout.h
//  WaterFallLayout
//
//  Created by sky on 16/6/6.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRWaterFallLayout;

@protocol JRWaterFallLayoutDelegate <NSObject>

@required
// 返回index位置下的item的高度
- (CGFloat)waterFallLayout:(JRWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSUInteger)index width:(CGFloat)width;

@optional
// 返回瀑布流显示的列数
- (NSUInteger)columnCountOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout;
// 返回行间距
- (CGFloat)rowMarginOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout;
// 返回列间距
- (CGFloat)columnMarginOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout;
// 返回边缘间距
- (UIEdgeInsets)edgeInsetsOfWaterFallLayout:(JRWaterFallLayout *)waterFallLayout;

@end

@interface JRWaterFallLayout : UICollectionViewLayout

/** 代理 */
@property (nonatomic, weak) id<JRWaterFallLayoutDelegate> delegate;

@end
