//
//  VedioTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VedioModel.h"

@implementation VedioTableViewCell{
    UIImageView *leftImg;
    UIImageView *rightImg;
    UIButton *leftButton;
    UIButton *rightButton;
    UILabel   *leftLabel;
    UILabel   *rightLabel;
    
    UILabel   *leftLabel2;
    UILabel   *rightLabel2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)drawLeft{
     /**左边图片*/
    leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(159), SYReal(100))];
    [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.img]]
                 placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:leftImg];
     /**左边按钮*/
    leftButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(159), SYReal(100))];
    [self.contentView addSubview:leftButton];
     /**左边标题*/
    leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(102), SYReal(150), SYReal(15))];
    leftLabel.text=_data.name;
    [self.contentView addSubview:leftLabel];
    /**左边描述*/
    leftLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(118), SYReal(150), SYReal(15))];
    leftLabel2.text=[_data.vedioList[0] objectForKey:@"title"];
    leftLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:leftLabel2];
    
}
-(void)drawRight{
    /**右边图片*/
    rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(160), SYReal(0), SYReal(159), SYReal(100))];
    [self.contentView addSubview:rightImg];
    /**右边按钮*/
    rightButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(160), SYReal(0), SYReal(159), SYReal(100))];
    [self.contentView addSubview:rightButton];
    /**右边标题*/
    rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(169), SYReal(102), SYReal(150), SYReal(15))];
    rightLabel.text=@"标题";
    [self.contentView addSubview:rightLabel];
    /**右边描述*/
    rightLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(169), SYReal(118), SYReal(150), SYReal(15))];
    rightLabel2.text=@"描述";
    rightLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:rightLabel2];
    
}

@end
