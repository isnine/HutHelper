//
//  UserDetailViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "BaseViewController.h"


@interface UserDetailViewController : BaseViewController

@property (strong, nonatomic) BmobIMUserInfo *userInfo;

@end
