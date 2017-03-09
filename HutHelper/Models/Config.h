//
//  Config.h
//  HutHelper
//
//  Created by nine on 2017/2/10.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUTAPI.h"
@class User;
#define HideAllHUD  [MBProgressHUD hideHUDForView:self.view animated:YES];
#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define SYReal(value) ((value)/414.0f*[UIScreen mainScreen].bounds.size.width)
@interface Config : NSObject

+ (void)setIs:(int )Is;
+ (int )getIs;
+(void)addNotice;
+(User*)getUser;
@end
