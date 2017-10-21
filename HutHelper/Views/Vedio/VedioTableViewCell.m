//
//  VedioTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "VedioTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Vedio.h"
#import "ZFPlayerModel.h"
#import "AppDelegate.h"
#import "VedioPlayViewController.h"
static const int kPhotoWidth=206;//图片宽度
static const int kPhotoHeight=kPhotoWidth/1.6;//图片高度
static const int kPhoto2_x=kPhotoWidth+12;//右边图片起始x坐标
static const int kLabel_x=kPhoto2_x+10;//右边Label起始x坐标
static const int kLabelWidth=kPhotoWidth-13;//Label宽度
static const int kLabel_y=kPhotoHeight+8;//label起始y坐标
static const int kLabel2_y=kLabel_y+15;

static const int kPhotoTopWidth=414;//顶部图片宽度
static const int kPhotoTopHeight=kPhotoTopWidth/1.6;//顶部图片高度
static const int kPhotoTop2_x=kPhotoTopWidth+2;//顶部图片起始x坐标
static const int kLabelTop_x=kPhotoTop2_x+10;//顶部Label起始x坐标
static const int kLabelTop_y=kPhotoTopHeight-35;//顶部label起始y坐标
static const int kLabelTop2_y=kPhotoTopHeight-15;

@implementation VedioTableViewCell{
    UIImageView *leftImg;
    UIImageView *rightImg;
    UIButton *leftButton;
    UIButton *rightButton;
    UILabel   *leftLabel;
    UILabel   *rightLabel;
    
    UILabel   *leftLabel2;
    UILabel   *rightLabel2;
    
    UILabel   *leftlistNum;
    UILabel   *rightlistNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)drawLeft{
    /**左边图片*/
    leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getVedio480p],_dataLeft.img]]
               placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:leftImg];
    /**左边按钮*/
    leftButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [leftButton addTarget:self action:@selector(btnLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftButton];
    /**左边标题*/
    leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(10), SYReal(kLabel_y), SYReal(kLabelWidth), SYReal(15))];
    leftLabel.text=_dataLeft.name;
    [self.contentView addSubview:leftLabel];
    /**左边描述*/
    leftLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(10), SYReal(kLabel2_y), SYReal(kLabelWidth), SYReal(15))];
    leftLabel2.text=[_dataLeft.vedioList[0] objectForKey:@"title"];
    leftLabel2.textColor=[UIColor lightGrayColor];
    leftLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:leftLabel2];
    
    leftlistNum=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kPhotoWidth-56), SYReal(kPhotoHeight-18), SYReal(200), SYReal(20))];
    leftlistNum.text=[NSString stringWithFormat:@"更新至%ld集",_dataLeft.vedioList.count];
    leftlistNum.textColor=[UIColor whiteColor];
    leftlistNum.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:10];
    [self.contentView addSubview:leftlistNum];
}

-(void)drawRight{
    /**右边图片*/
    rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(kPhoto2_x), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [rightImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getVedio480p],_dataRight.img]]
                placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:rightImg];
    /**右边按钮*/
    rightButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(kPhoto2_x), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [rightButton addTarget:self action:@selector(btnRight) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:rightButton];
    /**右边标题*/
    rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabel_x), SYReal(kLabel_y), SYReal(kLabelWidth), SYReal(15))];
    rightLabel.text=_dataRight.name;
    [self.contentView addSubview:rightLabel];
    /**右边描述*/
    rightLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabel_x), SYReal(kLabel2_y), SYReal(kLabelWidth), SYReal(15))];
    rightLabel2.text=[_dataRight.vedioList[_dataRight.vedioList.count-1] objectForKey:@"title"];
    rightLabel2.textColor=[UIColor lightGrayColor];
    rightLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:rightLabel2];
    
    rightlistNum=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kPhotoWidth-67+kPhoto2_x), SYReal(kPhotoHeight-18), SYReal(200), SYReal(20))];
    rightlistNum.text=[NSString stringWithFormat:@"更新至%ld集",_dataRight.vedioList.count];
    rightlistNum.textColor=[UIColor whiteColor];
    rightlistNum.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:10];
    [self.contentView addSubview:rightlistNum];
}

-(void)drawTop{
    /**顶部图片*/
    leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(5), SYReal(kPhotoTopWidth), SYReal(kPhotoTopHeight))];
    [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getVedio480p],_dataLeft.img]]
               placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:leftImg];
    /**顶部按钮*/
    leftButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(kPhotoTopWidth), SYReal(kPhotoTopHeight))];
    [leftButton addTarget:self action:@selector(btnLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftButton];
    /**顶部标题*/
    leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(kLabelTop_y), SYReal(kPhotoTopWidth), SYReal(15))];
    leftLabel.text=_dataLeft.name;
    leftLabel.textColor=[UIColor whiteColor];
    leftLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:19];
    [self.contentView addSubview:leftLabel];
    /**顶部描述*/
    leftLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(kLabelTop2_y), SYReal(kPhotoTopWidth), SYReal(15))];
    leftLabel2.text=[_dataLeft.vedioList[0] objectForKey:@"title"];
    leftLabel2.textColor=[UIColor whiteColor];
    leftLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:14];
    [self.contentView addSubview:leftLabel2];
    leftlistNum=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kPhotoTopWidth-63), SYReal(kPhotoTopHeight-14), SYReal(200), SYReal(20))];
    leftlistNum.text=[NSString stringWithFormat:@"更新至%ld集",_dataLeft.vedioList.count];
    leftlistNum.textColor=[UIColor whiteColor];
    leftlistNum.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:10];
    [self.contentView addSubview:leftlistNum];
}
#pragma - 按钮
-(void)btnLeft{
    AppDelegate *temp=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    VedioPlayViewController *vedio=[[VedioPlayViewController alloc]init];
    vedio.listUrl=_dataLeft.vedioList;
    vedio.name=_dataLeft.name;
    vedio.img=_dataLeft.img;
    [temp.mainNavigationController pushViewController:vedio animated:YES];
}
-(void)btnRight{
    AppDelegate *temp=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    VedioPlayViewController *vedio=[[VedioPlayViewController alloc]init];
    vedio.listUrl=_dataRight.vedioList;
    vedio.name=_dataRight.name;
    vedio.img=_dataRight.img;
    [temp.mainNavigationController pushViewController:vedio animated:YES];
}
@end
