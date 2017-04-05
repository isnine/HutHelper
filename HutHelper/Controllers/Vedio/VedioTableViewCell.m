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
#import "ZFPlayerModel.h"
#import "AppDelegate.h"
#import "MoviePlayerViewController.h"
#import "VedioPlayViewController.h"
static const int kPhotoWidth=206;//图片宽度
static const int kPhotoHeight=129;//图片高度
static const int kPhoto2_x=kPhotoWidth+2;//右边图片起始x坐标
static const int kLabel_x=kPhoto2_x+10;//右边Label起始x坐标
static const int kLabel_y=kPhotoHeight+8;//label起始y坐标
static const int kLabel2_y=kLabel_y+15;
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
    NSLog(@"%lf,%lf",DeviceMaxHeight,DeviceMaxWidth);
    /**左边图片*/
    leftImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.img]]
               placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:leftImg];
    /**左边按钮*/
    leftButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(0), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [leftButton addTarget:self action:@selector(btnLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:leftButton];
    /**左边标题*/
    leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(kLabel_y), SYReal(kPhotoWidth), SYReal(15))];
    leftLabel.text=_data.name;
    [self.contentView addSubview:leftLabel];
    /**左边描述*/
    leftLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(8), SYReal(kLabel2_y), SYReal(kPhotoWidth), SYReal(15))];
    leftLabel2.text=[_data.vedioList[0] objectForKey:@"title"];
    leftLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:leftLabel2];
    
}
-(void)drawRight{
    /**右边图片*/
    rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(kPhoto2_x), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [rightImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:API_IMG,_data.img]]
                placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.contentView addSubview:rightImg];
    /**右边按钮*/
    rightButton=[[UIButton alloc]initWithFrame:CGRectMake(SYReal(kPhoto2_x), SYReal(0), SYReal(kPhotoWidth), SYReal(kPhotoHeight))];
    [self.contentView addSubview:rightButton];
    /**右边标题*/
    rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabel_x), SYReal(kLabel_y), SYReal(kPhotoWidth), SYReal(15))];
    rightLabel.text=_data.name;
    [self.contentView addSubview:rightLabel];
    /**右边描述*/
    rightLabel2=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(kLabel_x), SYReal(kLabel2_y), SYReal(kPhotoWidth), SYReal(15))];
    rightLabel2.text=[_data.vedioList[0] objectForKey:@"title"];
    rightLabel2.font=[UIFont fontWithName:@"HelveticaNeue-Light"  size:12];
    [self.contentView addSubview:rightLabel2];
    
}
#pragma - 按钮
-(void)btnLeft{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MoviePlayerViewController *moviePlayerViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"VedioPlay"];
    moviePlayerViewController.listUrl=_data.vedioList;
    moviePlayerViewController.name=_data.name;
     moviePlayerViewController.img=_data.img;
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:moviePlayerViewController animated:YES];
//    AppDelegate *temp=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    VedioPlayViewController *tese=[[VedioPlayViewController alloc]init];
//    [temp.mainNavigationController pushViewController:tese animated:YES];
}
@end
