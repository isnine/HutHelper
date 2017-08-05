//
//  VedioModel.m
//  HutHelper
//
//  Created by Nine on 2017/4/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Vedio.h"

@implementation Vedio
-(instancetype)initWithDic:(NSDictionary*)Dic{
    self=[super init];
    if (self) {
        self.img=Dic[@"img"];
        self.name=Dic[@"name"];
        self.vedioList=Dic[@"vedioList"];
    }
    return self;
}
@end
