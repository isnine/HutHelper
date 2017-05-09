//
//  BaseViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BaseViewController : UIViewController

-(void)setupSubviews;

-(void)setDefaultLeftBarButtonItem;

-(void)goback;

-(void)showLoading;

-(void)hideLoading;

-(void)showInfomation:(NSString *)info;

-(void)showProgress:(CGFloat)progress;

@end
