//
//  UserInfoTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h> 


@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:22];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setInfo:(BmobIMUserInfo *)info{
    _info = info;
    
    self.nameLabel.text = info.name;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:[UIImage imageNamed:@"head"]];
}


@end
