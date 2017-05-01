//
//  ChatView.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/22.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobIMSDK/BmobIMSDK.h>
#import "Masonry.h"
#import <BmobSDK/Bmob.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AppManager.h"

@interface ChatView : UIView

@property (strong, nonatomic) UIButton *avatarButton;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *avatarBackgroundImageView;

@property (strong, nonatomic) UIImageView *chatBackgroundImageView;

@property (strong, nonatomic) UIView *chatContentView;



@property (strong, nonatomic) BmobIMMessage *msg;

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo ;

-(void)layoutViewsSelf;

-(void)layoutViewsOther;

@end
