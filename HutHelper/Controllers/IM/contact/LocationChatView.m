//
//  LocationChatView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/3/9.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "LocationChatView.h"
#import "Masonry.h"
#import "UIButton+WebCache.h"

@interface LocationChatView ()

@property (strong, nonatomic) UIButton *locationButton;


@property (strong, nonatomic) UILabel *addressLabel;

@end



@implementation LocationChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIButton *)locationButton{
    if (!_locationButton) {
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.chatContentView addSubview:_locationButton];
    }
    
    return _locationButton;
}


-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.font = [UIFont systemFontOfSize:14.0f];
        _addressLabel.numberOfLines = 1;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        [self.chatContentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

-(void)setMessage:(BmobIMMessage *)msg user:(BmobIMUserInfo *)userInfo{
    [super setMessage:msg user:userInfo];
    
    [self.chatBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatContentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.locationButton.mas_bottom);
        make.left.equalTo(self.locationButton.mas_left);
        make.right.equalTo(self.locationButton.mas_right);
    }];
    
    self.addressLabel.text = msg.content;
    [self.locationButton setBackgroundImage:[UIImage imageNamed:@"location_default.9"] forState:UIControlStateNormal];
}

-(void)layoutViewsSelf{
    [super layoutViewsSelf];
    
    //布局
    [self.locationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatBackgroundImageView .mas_top).with.offset(6);
        make.left.equalTo(self.chatBackgroundImageView.mas_left).with.offset(6);
        make.width.equalTo(@(144));
        make.height.equalTo(@(126));
    }];
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.avatarBackgroundImageView.mas_left).with.offset(-8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(self.locationButton.mas_width).with.offset(20);
        make.height.greaterThanOrEqualTo(@140);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
    }];
    
    
}


-(void)layoutViewsOther{
    [super layoutViewsOther];
    
    //布局
    [self.locationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatBackgroundImageView .mas_top).with.offset(6);
        make.right.equalTo(self.chatBackgroundImageView.mas_right).with.offset(-6);
        make.width.equalTo(@(144));
        make.height.equalTo(@(126));
    }];
    
    [self.chatContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarBackgroundImageView.mas_right).with.offset(8);
        make.top.equalTo(self.avatarBackgroundImageView);
        make.width.equalTo(self.locationButton.mas_width).with.offset(20);
        make.height.greaterThanOrEqualTo(@140);
        make.bottom.equalTo(self.mas_bottom).with.offset(-8).with.priorityMedium();
    }];
}


@end
