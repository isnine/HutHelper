//
//  Hand.h
//  HutHelper
//
//  Created by nine on 2017/8/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hand : NSObject
/**物品名称*/
@property(nonatomic,copy)NSString *title;
/**图片地址*/
@property(nonatomic,copy)NSString *image;
/**价格*/
@property(nonatomic,copy)NSString *prize;
/**发布时间*/
@property(nonatomic,copy)NSString *created_on;
/**商品id*/
@property(nonatomic,copy)NSString *good_id;

-(instancetype)initWithDic:(NSDictionary*)Dic;
@end
