//
//  NoticeTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "NoticeShowViewController.h"
#import "AppDelegate.h"
@implementation NoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle]loadNibNamed:@"NoticeTableViewCell" owner:nil options:nil]lastObject];
}
- (IBAction)showBtn:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *noticeData=[defaults objectForKey:@"Notice"];
    [defaults setObject:noticeData[((UITableViewCell*)[[sender superview]superview]).tag] forKey:@"NoticeShow"];
    
    [Config pushViewController:@"NoticeShow"];
    
}

@end
