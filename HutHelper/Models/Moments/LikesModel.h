//
//  LikesModel.h
//  HutHelper
//
//  Created by Nine on 2017/3/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikesModel : NSObject
-(instancetype)initWithDic:(NSDictionary*)Dic;
@property(nonatomic,copy)NSMutableArray *data;
@property(nonatomic,copy)NSString *msg;
@end
