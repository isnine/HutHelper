//
//  ViewUtil.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil


+(UIButton *)buttonWithTitle:(NSString *)title
                       image:(UIImage *)image
            highlightedImage:(UIImage *)highlightedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    
    
    return button;

}

+ (UIImage *)imageByScalingToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) ==NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

+ (UIImage *)resizeImageWithWidth:(CGFloat)width
                      sourceImage:(UIImage *)sourceImage{
    CGFloat resizeH = 0.0f;
    CGFloat resizeW = 0.0f;
    CGFloat oldH    = sourceImage.size.height;
    CGFloat oldW    = sourceImage.size.width;
    CGFloat centerX = 0.0f;
    CGFloat centerY = 0.0f;
    
    resizeW = width;
    resizeH = oldH * resizeW/oldW;
    
    UIGraphicsBeginImageContext(CGSizeMake((int) resizeW, (int)resizeH));
    [sourceImage drawInRect:CGRectMake(centerX, centerY,(int) resizeW, (int)resizeH)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
