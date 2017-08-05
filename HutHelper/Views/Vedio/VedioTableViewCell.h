//
//  VedioTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Vedio;
@class ZFPlayerModel;
@interface VedioTableViewCell : UITableViewCell
-(void)drawLeft;
-(void)drawRight;
-(void)drawTop;
@property (nonatomic, weak) Vedio *dataLeft;
@property (nonatomic, weak) Vedio *dataRight;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end
