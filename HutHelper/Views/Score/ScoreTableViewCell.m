//
//  ScoreTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/7.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil]lastObject];
}
@end
