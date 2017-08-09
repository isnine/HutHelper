//
//  LostCell.h
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Lost;
@interface LostCell : UICollectionViewCell
@property (nonatomic,weak) Lost *lostModel;
@property (nonatomic,strong)UIImageView *imageView;
@property(copy,nonatomic) UIView *shotoView;
-(void)draw;
@end
