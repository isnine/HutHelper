//
//  LeftItemTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/2/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *Img;
@property (weak, nonatomic) IBOutlet UILabel *Text;
+(instancetype)tableViewCell;
@end
