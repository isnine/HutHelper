//
//  LostShowTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostShowTableViewCell.h"

@implementation LostShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"LostShowTableViewCell" owner:nil options:nil]lastObject];
}
@end
