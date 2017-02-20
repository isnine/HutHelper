//
//  LeftUserTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LeftUserTableViewCell.h"

@implementation LeftUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"LeftUserTableViewCell" owner:NULL options:NULL] lastObject];
}
@end
