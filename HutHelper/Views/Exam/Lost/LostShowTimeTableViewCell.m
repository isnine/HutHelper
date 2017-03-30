//
//  LostShowTimeTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostShowTimeTableViewCell.h"

@implementation LostShowTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"LostShowTimeTableViewCell" owner:nil options:nil]lastObject];
}
@end
