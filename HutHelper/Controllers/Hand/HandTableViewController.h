//
//  HandTableViewController.h
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandTableViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray      *myHandArray;
@property (nonatomic, copy) NSMutableArray      *otherHandArray;
@property (nonatomic, copy) NSString      *otherName;
@property (nonatomic,assign) Boolean      *isSelfGoods;
@end
