//
//  VedioTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VedioModel;
@class ZFPlayerModel;
@interface VedioTableViewCell : UITableViewCell
-(void)drawLeft;
-(void)drawRight;
@property (nonatomic, weak) VedioModel *data;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end
