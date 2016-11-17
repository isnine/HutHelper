//
//  UMShareMenuItem.m
//  UMSocialSDK
//
//  Created by umeng on 16/9/21.
//  Copyright © 2016年 UMeng. All rights reserved.
//

#import "UMShareMenuItem.h"

#define UMSocial_Name_Label_Height 15

@implementation UMShareMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.logoImageView = [[UIImageView alloc] init];
        [self addSubview:self.logoImageView];

        self.platformNameLabel = [[UILabel alloc] init];
        self.platformNameLabel.textAlignment = NSTextAlignmentCenter;
        self.platformNameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.platformNameLabel];
        
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self subviewsUpdate];   
    }
}

- (void)tapInSelf
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self.index);
    }
}


- (void)subviewsUpdate
{
    self.logoImageView.frame = CGRectMake(UMSocial_Name_Label_Height/2, 0, self.frame.size.width-UMSocial_Name_Label_Height, self.frame.size.height - UMSocial_Name_Label_Height);
    self.platformNameLabel.frame = CGRectMake(0, self.frame.size.height-UMSocial_Name_Label_Height-2, self.frame.size.width, UMSocial_Name_Label_Height);
}

- (void)reloadDataWithImage:(UIImage *)image platformName:(NSString *)platformName
{
    self.logoImageView.image = image;
    
    self.platformNameLabel.text = platformName;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
