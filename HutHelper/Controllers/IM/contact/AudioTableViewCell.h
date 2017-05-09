//
//  AudioTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 16/3/7.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioChatView.h"

@interface AudioTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AudioChatView *chatView;

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo ;

@end
