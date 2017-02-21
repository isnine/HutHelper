//
//  Config.m
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Config.h"
static int Isxp ;
static int Issay ;
@implementation Config
+ (void)setIsxp:(int )bools
{
    Isxp = bools;
}
+ (int )getIsxp
{
    return Isxp;
}
+ (void)setIssay:(int )bools
{
    Issay = bools;
}
+ (int )getIssay
{
    return Issay;
}
@end
