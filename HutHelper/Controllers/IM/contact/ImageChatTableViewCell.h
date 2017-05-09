//
//  ImageChatTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 16/3/2.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageChatView.h"

@interface ImageChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ImageChatView *chatView;

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo ;

@end
