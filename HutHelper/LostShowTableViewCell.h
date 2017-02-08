//
//  LostShowTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tit;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *locate;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UITextView *content;
+(instancetype)tableViewCell;
@end
