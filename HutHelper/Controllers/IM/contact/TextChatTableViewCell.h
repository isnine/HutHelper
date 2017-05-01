//
//  ChatTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/22.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextChatView.h"
#import <BmobIMSDK/BmobIMSDK.h>

@interface TextChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TextChatView *chatView;

//@property (strong, nonatomic) BIMMessage *msg;

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo ;

@end
