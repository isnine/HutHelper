//
//  ChatBottomContentView.m
//  BmobIMDemo
//
//  Created by Bmob on 16/2/29.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatBottomContentView.h"
#import "Masonry.h"



@interface ChatBottomContentView ()


@end

@implementation ChatBottomContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


-(void)setupSubviews{
    
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"ChatBottomContentView" owner:self options:nil] firstObject];
   
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.photoLibButton setBackgroundImage:[UIImage imageNamed:@"chat_icon5"] forState:UIControlStateNormal];
    [self.photoLibButton setBackgroundImage:[UIImage imageNamed:@"chat_icon5_"] forState:UIControlStateHighlighted];
    [self.photoTakeButton setBackgroundImage:[UIImage imageNamed:@"chat_icon6"] forState:UIControlStateNormal];
    [self.photoTakeButton setBackgroundImage:[UIImage imageNamed:@"chat_icon6_"] forState:UIControlStateHighlighted];
    [self.locateButton setBackgroundImage:[UIImage imageNamed:@"chat_icon7"] forState:UIControlStateNormal];
    [self.locateButton setBackgroundImage:[UIImage imageNamed:@"chat_icon7_"] forState:UIControlStateHighlighted];
    
}


@end
