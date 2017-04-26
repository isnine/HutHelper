//
//  ViewUtil.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewUtil : NSObject

+(UIButton *)buttonWithTitle:(NSString *)title
                       image:(UIImage *)image
            highlightedImage:(UIImage *)highlightedImage;


+ (UIImage *)imageByScalingToSize:(CGSize)targetSize
                      sourceImage:(UIImage *)sourceImage;

+ (UIImage *)resizeImageWithWidth:(CGFloat)width
                      sourceImage:(UIImage *)sourceImage;

@end
