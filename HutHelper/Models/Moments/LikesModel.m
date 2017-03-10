//
//  LikesModel.m
//  HutHelper
//
//  Created by Nine on 2017/3/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LikesModel.h"

@implementation LikesModel
-(instancetype)initWithDic:(NSDictionary*)Dic{
    self=[super init];
    if (self) {
        self.data=Dic[@"data"];
        self.msg=Dic[@"msg"];
    }
    return self;
}
@end
