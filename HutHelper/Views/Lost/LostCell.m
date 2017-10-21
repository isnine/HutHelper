//
//  LostCell.m
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostCell.h"
#import "Lost.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XWScanImage.h"
@implementation LostCell{
    UILabel *textLabel;
    UIImageView *imageView;
    UIImageView *imageViewBlack;
    UILabel *usernameLabel;
    UILabel *timeLabel;
    UIImageView *line;
    
    UIImageView *blackView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(UIImage*)UIViewToUIImageView:(UIView*)view{
    CGSize size = view.bounds.size;
    // 下面的方法：第一个参数表示区域大小；第二个参数表示是否是非透明的如果需要显示半透明效果，需要传NO，否则传YES；第三个参数是屏幕密度
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)draw{
    //背景
    if (!blackView) {
        blackView = [[UIImageView alloc]initWithFrame:self.bounds];
        blackView.backgroundColor=[self randomColor:_lostModel.blackColor];
        blackView.layer.masksToBounds = YES; //没这句话它圆不起来
        blackView.layer.cornerRadius = 5.0; //设置图片圆角的尺度
        blackView.userInteractionEnabled=NO;
      //  self.imageView=blackView;
        [self addSubview:blackView];
        self.imageView=blackView;
       // [self.shotoView addSubview:blackView];
    }
    //内容
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines=0;
        textLabel.font=[UIFont systemFontOfSize:15];
        textLabel.textColor=[UIColor whiteColor];
        textLabel.text=_lostModel.content;
        textLabel.frame=CGRectMake(SYReal(10), SYReal(5),SYReal(175),_lostModel.textHeight);
        [self addSubview:textLabel];
    }
    //图片
    int X=0,Y=_lostModel.textHeight+SYReal(10);
    if (_lostModel.pics.count==0) {
        Y-=SYReal(80);
    }else if (_lostModel.pics.count==1) {
        X=SYReal(55);
    }else{
        X=SYReal(15);
    }
    if(!imageView){
        for (int i=0; i<_lostModel.pics.count; i++) {
            if (i==1||i==3) {
                X+=SYReal(85);
            }else if(i==2){
                X=SYReal(15);
                Y+=SYReal(85);
            }
            //留白
            imageViewBlack=[[UIImageView alloc]initWithFrame:CGRectMake(X-SYReal(1), Y-SYReal(1), SYReal(77), SYReal(77))];
            imageViewBlack.backgroundColor=[UIColor whiteColor];
            [self addSubview:imageViewBlack];
            //加载图片
            imageView=[[UIImageView alloc]initWithFrame:CGRectMake(X, Y, SYReal(75), SYReal(75))];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Config.getApiImg,_lostModel.pics[i]]]
                         placeholderImage:[UIImage imageNamed:@"load_img"]];
            //中间切割
            imageView.contentMode =UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            //放大图片
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [imageView addGestureRecognizer:tapGestureRecognizer1];
            [imageView setUserInteractionEnabled:YES];
            [self addSubview:imageView];
        }
    }
    //横线
    if (!line) {
        line=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(10), Y+SYReal(80), SYReal(170), SYReal(1))];
        line.backgroundColor=[UIColor whiteColor];
        [self addSubview:line];
    }
    //发布人
    if (!usernameLabel) {
        usernameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(10), Y+SYReal(85), SYReal(175), SYReal(15))];
        usernameLabel.font=[UIFont systemFontOfSize:11];
        usernameLabel.textColor=[UIColor whiteColor];
        usernameLabel.text=_lostModel.username;
        [self addSubview:usernameLabel];
    }
    //时间
    if (!timeLabel) {
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(110), Y+SYReal(85), SYReal(175), SYReal(15))];
        timeLabel.font=[UIFont systemFontOfSize:11];
        timeLabel.textColor=[UIColor whiteColor];
        timeLabel.text=[_lostModel.created_on substringWithRange:NSMakeRange(0,10)];
        [self addSubview:timeLabel];
    }

  
}

-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

-(UIColor*)randomColor:(NSInteger)colors{
    switch (colors) {
        case 0:
            return RGB(176, 194, 225, 1);
            break;
        case 1:
            return RGB(156, 202, 171, 1);
            break;
        case 2:
            return RGB(193, 185, 226, 1);
            break;
        default:
            return RGB(152, 205, 222, 1);
            break;
    }
    return RGB(152, 205, 222, 1);
}
@end
