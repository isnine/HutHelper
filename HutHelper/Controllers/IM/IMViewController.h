//
//  IMViewController.h
//  HutHelper
//
//  Created by Nine on 2017/4/26.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
@interface IMViewController : UIViewController
@property (strong, nonatomic) BmobIMConversation *conversation;
@end
