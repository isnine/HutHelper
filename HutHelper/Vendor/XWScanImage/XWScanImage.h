//
//  XWScanImage.h
//  XWScanImageDemo
//
//  Created by 邱学伟 on 16/4/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XWScanImage : NSObject
/**
*  浏览大图
*
*  @param currentImageview 图片所在的imageView
*/
+(void)scanBigImageWithImageView:(UIImageView *)currentImageview;
@end
