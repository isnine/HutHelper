//
//  Hand.m
//  HutHelper
//
//  Created by nine on 2017/8/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Hand.h"

@implementation Hand
-(instancetype)initWithDic:(NSDictionary*)Dic{
    self=[super init];
    if (self) {
        self.created_on=Dic[@"created_on"];
        self.good_id=Dic[@"id"];
        self.image=Dic[@"image"];
        self.prize=Dic[@"prize"];
        self.title=Dic[@"title"];
    }
    return self;
}
@end
