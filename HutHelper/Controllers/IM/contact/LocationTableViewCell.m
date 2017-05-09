//
//  LocationTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/9.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo{
    [self.chatView setMessage:msg user:userInfo];
}

@end
