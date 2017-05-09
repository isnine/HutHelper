//
//  TextChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/2.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "TextChatView.h"
#import "BmobIMDemoPCH.h"

@implementation TextChatView

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.chatContentView addSubview:_contentLabel];
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 70 - 70;
    }
    return _contentLabel;
}

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo {
    [super setMessage:msg user:userInfo];
        
    self.contentLabel.text = msg.content;
}


-(void)layoutViewsSelf{
    [super layoutViewsSelf];
    
    
    self.contentLabel.hidden = NO;
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chatBackgroundImageView.mas_centerY);
        make.left.equalTo(self.chatContentView.mas_left).with.offset(8);
        make.right.equalTo(self.chatContentView.mas_right).with.offset(-20);
    }];
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarBackgroundImageView.mas_left).with.offset(-8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.lessThanOrEqualTo(@(kScreenWidth - 70));
        make.height.equalTo(self.contentLabel.mas_height).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
    }];
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    self.contentLabel.textColor = [UIColor whiteColor];
}
-(void)layoutViewsOther{
    [super layoutViewsOther];
    
    self.contentLabel.hidden = NO;
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBackgroundImageView.mas_right).with.offset(8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.lessThanOrEqualTo(@(kScreenWidth - 70));
        make.height.equalTo(self.contentLabel.mas_height).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
    }];
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(8, 24, 18, 24));
        make.centerY.equalTo(self.chatBackgroundImageView.mas_centerY);
        make.left.equalTo(self.chatContentView.mas_left).with.offset(20);
        make.right.equalTo(self.chatContentView.mas_right).with.offset(-8);
    }];
    self.contentLabel.textColor = [UIColor colorWithR:47 g:39 b:37];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
