//
//  SayViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "SayViewCell.h"

@implementation SayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)tableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SayViewCell" owner:nil options:nil] lastObject];
}
@end
