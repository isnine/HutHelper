//
//  LoginViewController.h
//  HutHelper
//
//  Created by nine on 2016/10/17.
//  Copyright © 2016年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSDictionary (MyDictionary)
-(NSDictionary *)deleteAllNullValue;
@end
@interface LoginViewController : UIViewController
//教务系统用
@property(nonatomic,strong) NSString *userNameStr;
@property(nonatomic,strong) NSString *passWorldStr;
@property(nonatomic,strong) NSString *secCode;
@property (copy,nonatomic) NSString *viewState;

@property (nonatomic,strong) NSDictionary* cookieDictionary;
@end
