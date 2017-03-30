//
//  LostShowPhotoTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostShowPhotoTableViewCell.h"

@implementation LostShowPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"LostShowPhotoTableViewCell" owner:nil options:nil]lastObject];
}
@end
