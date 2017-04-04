//
//  VedioModel.h
//  HutHelper
//
//  Created by Nine on 2017/4/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VedioModel : NSObject
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSArray *vedioList;
-(instancetype)initWithDic:(NSDictionary*)Dic;
@end
