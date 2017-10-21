//
//  ExamCell.m
//  HutHelper
//
//  Created by nine on 2017/1/11.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ExamCell.h"


@implementation ExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/** 提供cell*/
+ (instancetype)tableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ExamCell" owner:nil options:nil] lastObject];
}
@end
