//
//  ScoreTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/2/7.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Class;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Xf;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
+(instancetype)tableViewCell;
@end
