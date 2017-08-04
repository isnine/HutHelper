//
//  XXShop.h
//  WaterFallLayout
//
//  Created by sky on 16/6/6.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRShop : NSObject

@property (nonatomic, strong) NSNumber *h; // 高度
@property (nonatomic, strong) NSNumber *w; // 宽度
@property (nonatomic, copy) NSString *img; // 图片urlString
@property (nonatomic, copy) NSString *price; // 价格

@end
