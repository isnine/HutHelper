//
//  ChatViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <BmobIMSDK/BmobIMSDK.h>


@interface ChatViewController : BaseViewController


@property (strong, nonatomic) BmobIMConversation *conversation;


@end
