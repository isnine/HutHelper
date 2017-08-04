//
//  NoticeTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UILabel *Body;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
+(instancetype)tableViewCell;
@end
