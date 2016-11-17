//
//  UMShareMenuItem.h
//  UMSocialSDK
//
//  Created by umeng on 16/9/21.
//  Copyright © 2016年 UMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMShareMenuItem : UIView

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UILabel *platformNameLabel;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void (^tapActionBlock)(NSInteger index);

- (void)reloadDataWithImage:(UIImage *)image platformName:(NSString *)platformName;



@end
