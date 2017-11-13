//
//  UserNameCell.m
//  HutHelper
//
//  Created by nine on 2017/11/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "UserHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
@interface UserHeaderCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *headImgView;

@end
@implementation UserHeaderCell

-(instancetype)initWithName:(NSString*)nameStr withInfo:(NSString*)imgUrlStr reuseIdentifier:(NSString *)reuseIdentifier{
    self.nameStr=nameStr;
    self.imgUrlStr=imgUrlStr;
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.headImgView];
    }
    return self;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = self.nameStr;
        _nameLabel.textAlignment = 1;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]init];
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Config.getApiImg,self.imgUrlStr]]
                       placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                  if ([Config getCacheImg]!=nil) {
                                      _headImgView.image=[self circleImage:[UIImage imageWithData:[Config getCacheImg]]];
                                  }else if ((!Config.getHeadPicThumb)||[Config.getHeadPicThumb isEqualToString:@""]) {
                                      if ([Config.getSex isEqualToString:@"男"]) {
                                          _headImgView.image=[UIImage imageNamed:@"img_user_boy"];
                                      }else{
                                          _headImgView.image=[UIImage imageNamed:@"img_user_girl"];
                                      }
                                  }else{
                                       _headImgView.image=[self circleImage:image];
                                  }
                                  
                              }];
    }
    return _headImgView;
}
-(void)layoutSubviews{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-630);
        make.bottom.mas_equalTo(-10);
    }];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(350);
        make.right.mas_equalTo(-290);
        make.bottom.mas_equalTo(-5);
    }];
}

-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
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
