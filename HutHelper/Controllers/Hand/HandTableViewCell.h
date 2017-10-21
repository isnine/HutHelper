//
//  HandTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UIImageView *blackImg2;
@property (weak, nonatomic) IBOutlet UIImageView *shadowblack2;
@property (weak, nonatomic) IBOutlet UIButton *Button2;

@property (nonatomic, copy) NSMutableArray      *handArray;
@property (nonatomic,assign) Boolean      *isSelfGoods;
+(instancetype)tableviewcell;
@end
