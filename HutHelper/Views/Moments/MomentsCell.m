//
//  MomentsCell.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsCell.h"
#import "MomentsModel.h"
#import "Config.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+LXAdd.h"
@interface MomentsCell ()
@end

@implementation MomentsCell{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *contentLabel;
    UIButton *avatarButton;
    UIImageView *cornerImage;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)draw{
    NSLog(@"%lf %lf",([UIScreen mainScreen].bounds.size.height),([UIScreen mainScreen].bounds.size.width));
    /**用户昵称*/
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SYReal(200),SYReal(50))];
    nameLabel.textColor=[UIColor colorWithRed:4/255.0 green:213/255.0 blue:192/255.0 alpha:1.0];
    nameLabel.text=_data.username;
    [self.contentView addSubview:nameLabel];
    /**发布时间*/
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20,SYReal(400) ,SYReal(50))];
    timeLabel.text=_data.created_on;
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    timeLabel.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    [self.contentView addSubview:timeLabel];
    /**头像按钮*/
    avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake(SIZE_GAP_LEFT, SIZE_GAP_TOP, SIZE_AVATAR, SIZE_AVATAR);
    avatarButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    avatarButton.clipsToBounds = YES;
    [avatarButton addTarget:self action:@selector(btnAvatar) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:avatarButton];
    /**头像*/
    cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_AVATAR+5, SIZE_AVATAR+5)];
    cornerImage.center = avatarButton.center;
    [cornerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.head_pic_thumb]] placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (![[NSString stringWithFormat:API_IMG,_data.head_pic_thumb] isEqualToString:INDEX]) {
            cornerImage.image=[self circleImage:image];
        }
    }];
    [self.contentView addSubview:cornerImage];
    /**说说内容*/
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines=0;
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.text=_data.content;
    contentLabel.frame=CGRectMake(20, 60,_data.textWidth,_data.textHeight);
    [self.contentView addSubview:contentLabel];
}
#pragma mark - 按钮事件
-(void)btnAvatar{
    NSLog(@"头像被点击");
}
-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width , image.size.height );
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
@end
