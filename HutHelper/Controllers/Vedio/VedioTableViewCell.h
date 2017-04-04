//
//  VedioTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/4/2.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VedioModel;
@interface VedioTableViewCell : UITableViewCell
-(void)drawLeft;
-(void)drawRight;
@property (nonatomic, weak) VedioModel *data;
@end
