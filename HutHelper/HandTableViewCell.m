//
//  HandTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandTableViewCell.h"

@implementation HandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)tableviewcell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
}
@end
