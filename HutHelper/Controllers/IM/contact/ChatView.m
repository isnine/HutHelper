//
//  ChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/22.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatView.h"
#import "BmobIMDemoPCH.h"


@interface ChatView ()



@end


@implementation ChatView

-(UIImageView *)avatarBackgroundImageView{
    if (!_avatarBackgroundImageView) {
        _avatarBackgroundImageView = [[UIImageView alloc] init];
        
        [self addSubview:_avatarBackgroundImageView];
    }
    
    return _avatarBackgroundImageView;
}

-(UIView *)chatContentView{
    if (!_chatContentView) {
        _chatContentView = [[UIView alloc] init];
        [self addSubview:_chatContentView];
    }
    return _chatContentView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel                 = [[UILabel alloc] init];
        _timeLabel.font            = [ UIFont systemFontOfSize:12];
        [_timeLabel.layer setCornerRadius:3];
        [_timeLabel.layer setMasksToBounds:YES];
        _timeLabel.backgroundColor = [UIColor colorWithR:227 g:228 b:232];
        [self addSubview:_timeLabel];
        _timeLabel.textColor       = [UIColor colorWithR:136 g:136 b:136];
        _timeLabel.textAlignment   = NSTextAlignmentCenter;
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@140);
            make.top.equalTo(self.mas_top).with.offset(8);
            make.height.equalTo(@19);
        }];
    }
    return _timeLabel;
}

-(UIButton *)avatarButton{
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_avatarButton];
        [_avatarButton.layer setMasksToBounds:YES];
        [_avatarButton.layer setCornerRadius:20];
    }
    
    return _avatarButton;
}







-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo {
    self.msg = msg;
    
    self.avatarBackgroundImageView.image = [UIImage imageNamed:@"head_bg"];
    self.timeLabel.text = [[AppManager defaultManager].dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.msg.updatedTime / 1000.0f] ];
    
    BmobUser *loginUser = [BmobUser getCurrentUser];
    if ([_msg.fromId isEqualToString:loginUser.objectId]) {
       [self layoutViewsSelf];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[loginUser objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];
    }else{
        [self layoutViewsOther];
        [self.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userInfo.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];
    }
    

}

-(void)setMsg:(BmobIMMessage *)msg{
    _msg = msg;
    
}

-(UIImageView *)chatBackgroundImageView{
    if (!_chatBackgroundImageView) {
        _chatBackgroundImageView = [[UIImageView alloc] init];
        [self.chatContentView addSubview:_chatBackgroundImageView];
        
    }
    return _chatBackgroundImageView;
}



#pragma mark - self layout



-(void)layoutViewsSelf{
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"bg_chat_right_nor"];

}






#pragma mark - other layout


-(void)layoutViewsOther{
    [self.avatarBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.avatarBackgroundImageView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    self.chatBackgroundImageView.image = [UIImage imageNamed:@"bg_chat_left_nor"] ;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
