//
//  LeftUserTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/2/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Head;
@property (weak, nonatomic) IBOutlet UILabel *Username;
+(instancetype)tableViewCell;
@end
