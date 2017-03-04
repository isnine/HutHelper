//
//  MomentsCell.m
//  HutHelper
//
//  Created by Nine on 2017/3/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsCell.h"
#import "MomentsModel.h"
#import "CommentsModel.h"
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
    
    UILabel *commentNumLabel;
    UIButton *commentButton;
    UIImageView *commentImage;
    
    UIImageView *photoImg1;
    UIImageView *photoImg2;
    UIImageView *photoImg3;
    UIImageView *photoImg4;
    
    UIImageView *commentBackground;
    UILabel *commentLabel;
    UILabel *commentUsernameLabel;
    
    UIImageView *commentBackground2;
    UILabel *commentsTimeLabel;
    
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
    /**用户昵称*/
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(60), 0, SYReal(200),SYReal(50))];
    nameLabel.textColor=[UIColor colorWithRed:4/255.0 green:213/255.0 blue:192/255.0 alpha:1.0];
    nameLabel.text=_data.username;
    [self.contentView addSubview:nameLabel];
    /**发布时间*/
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(60),SYReal(20),SYReal(400) ,SYReal(50))];
    timeLabel.text=_data.created_on;
    timeLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    timeLabel.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    [self.contentView addSubview:timeLabel];
    /**头像按钮*/
    avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake(SYReal(15), SYReal(13), SYReal(35), SYReal(35));
    avatarButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    avatarButton.clipsToBounds = YES;
    [avatarButton addTarget:self action:@selector(btnAvatar) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:avatarButton];
    /**头像图片*/
    cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SYReal(40),SYReal(40))];
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
    contentLabel.font=[UIFont systemFontOfSize:15];
    contentLabel.text=_data.content;
    contentLabel.frame=CGRectMake(SYReal(20), SYReal(60),_data.textWidth,_data.textHeight);
    [self.contentView addSubview:contentLabel];
    /**图片*/
    if (_data.pics.count!=0) {
        [self loadPhoto];
    }
    /**评论按钮*/
    commentButton = [[UIButton alloc] init];
    commentButton.frame=CGRectMake(SYReal(350), SYReal(75)+_data.textHeight+_data.photoHeight, SYReal(20), SYReal(20));
    [self.contentView addSubview:commentButton];
    /**评论图片*/
    commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,SYReal(20),SYReal(20))];
    commentImage.center = commentButton.center;
    commentImage.image=[UIImage imageNamed:@"comment"];
    [self.contentView addSubview:commentImage];
    /**评论数*/
    commentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYReal(375), SYReal(75)+_data.textHeight+_data.photoHeight, SYReal(20),SYReal(20))];
    commentNumLabel.textColor=[UIColor colorWithRed:4/255.0 green:213/255.0 blue:192/255.0 alpha:1.0];
    commentNumLabel.text=[NSString stringWithFormat:@"%d",(short)_data.commentsModelArray.count];
    [self.contentView addSubview:commentNumLabel];
    /**评论*/
    [self loadComments];
}
-(void)loadComments{
    double sumHeight=0.0;
    for (int i=0; i<_data.commentsModelArray.count; i++) {
        /**评论背景*/
        CommentsModel *commentsModel=_data.commentsModelArray[i];
        commentBackground =[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(75)+_data.textHeight+_data.photoHeight+SYReal(23)+sumHeight, SYReal(374), SYReal(25)+commentsModel.commentsHeight)];
        commentBackground.backgroundColor=[UIColor colorWithRed:242/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        [self.contentView addSubview:commentBackground];
        /**评论*/
        commentLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(30), SYReal(75)+_data.textHeight+_data.photoHeight+SYReal(28)+sumHeight,SYReal(COMMENTS_WEIGHT), commentsModel.commentsHeight)];
        commentLabel.numberOfLines=0;
        commentLabel.text=commentsModel.comment;
        commentLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:commentLabel];
        /**评论用户昵称*/
        commentUsernameLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(30), SYReal(75)+_data.textHeight+_data.photoHeight+SYReal(28)+sumHeight+commentsModel.commentsHeight+SYReal(5),  SYReal(354), SYReal(10))];
        commentUsernameLabel.text=commentsModel.username;
        commentUsernameLabel.textColor=[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        commentUsernameLabel.font=[UIFont systemFontOfSize:8];
        [self.contentView addSubview:commentUsernameLabel];
        /**评论发布时间*/
        commentsTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(SYReal(320)+SYReal(15), SYReal(75)+_data.textHeight+_data.photoHeight+SYReal(28)+sumHeight+commentsModel.commentsHeight+SYReal(5),  SYReal(60), SYReal(10))];
        commentsTimeLabel.text=commentsModel.created_on;
        commentsTimeLabel.font=[UIFont systemFontOfSize:9];
        commentsTimeLabel.textColor=[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
        [self.contentView addSubview:commentsTimeLabel];
        commentBackground2 =[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(75)+_data.textHeight+_data.photoHeight+SYReal(23)+sumHeight+SYReal(25)+commentsModel.commentsHeight, SYReal(374),SYReal(2))];
        commentBackground2.backgroundColor=[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
        [self.contentView addSubview:commentBackground2];
        
        sumHeight+=SYReal(25)+commentsModel.commentsHeight+SYReal(2);
    }
}
-(void)loadPhoto{
    if (_data.pics.count==1) {
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,_data.photoHeight*1.77, _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]] placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.contentView addSubview:photoImg1];
        }];
    }else if (_data.pics.count==2){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
    }else if (_data.pics.count==3){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
        photoImg3=[[UIImageView alloc] init];
        photoImg3.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight+_data.photoHeight,_data.photoHeight*1.77, _data.photoHeight);
        [photoImg3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[2]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg3];
        _data.photoHeight+=_data.photoHeight;
    }else if (_data.pics.count==4){
        photoImg1=[[UIImageView alloc] init];
        photoImg1.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[0]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg1];
        photoImg2=[[UIImageView alloc] init];
        photoImg2.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight,SYReal(184), _data.photoHeight);
        [photoImg2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[1]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg2];
        photoImg3=[[UIImageView alloc] init];
        photoImg3.frame=CGRectMake(SYReal(20),SYReal(70)+_data.textHeight+_data.photoHeight,SYReal(184), _data.photoHeight);
        [photoImg3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[2]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg3];
        photoImg4=[[UIImageView alloc] init];
        photoImg4.frame=CGRectMake(SYReal(206),SYReal(70)+_data.textHeight+_data.photoHeight,SYReal(184), _data.photoHeight);
        [photoImg4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.pics[3]]]
                     placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.contentView addSubview:photoImg4];
        _data.photoHeight+=_data.photoHeight;
    }
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
