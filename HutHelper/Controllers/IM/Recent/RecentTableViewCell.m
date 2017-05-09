//
//  RecentTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/29.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RecentTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation RecentTableViewCell

//-(instancetype)init{
//
//}

- (void)awakeFromNib {
    // Initialization code
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:25];
//    self.tipImageView.image = [[UIImage imageNamed:@"icon_xiaoxi_qibao"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEntity:(BmobIMConversation *)entity{
    _entity = entity;
    self.titleLabel.text = entity.conversationTitle;
    self.contentLabel.text = entity.conversationDetail;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:entity.conversationIcon] placeholderImage:[UIImage imageNamed:@"head"]];
    if (entity.unreadCount > 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%d",entity.unreadCount];
        self.tipImageView.hidden = NO;
    }else{
        self.numberLabel.text = nil;
        self.tipImageView.hidden = YES;
    }
}

@end
