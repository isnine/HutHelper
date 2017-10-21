//
//  VedioModel.h
//  HutHelper
//
//  Created by Nine on 2017/4/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vedio : NSObject
/**浏览图地址*/
@property(nonatomic,copy)NSString *img;
/**视频名称*/
@property(nonatomic,copy)NSString *name;
/**视频列表*/
@property(nonatomic,copy)NSArray *vedioList;
-(instancetype)initWithDic:(NSDictionary*)Dic;
@end
