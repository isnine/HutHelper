//
//  CommitViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CommitViewCell.h"

@implementation CommitViewCell

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
    return [[[NSBundle mainBundle] loadNibNamed:@"CommitViewCell" owner:nil options:nil] lastObject];
}
@end
