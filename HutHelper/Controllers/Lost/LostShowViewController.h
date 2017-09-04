//
//  LostShowViewController.h
//  HutHelper
//
//  Created by nine on 2017/8/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lost;
@interface LostShowViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic,weak) Lost *lostModel;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic,assign) Boolean  *isSelf;
@end
