//
//  ContactsViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
@interface ContactsViewController : UIViewController
@property (strong, nonatomic) BmobIMConversation *conversation;
@end
