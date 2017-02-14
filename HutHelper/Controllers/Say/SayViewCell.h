//
//  SayViewCell.h
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SayViewCell : UITableViewCell
/** cell*/
+ (instancetype)tableViewCell;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *created_on;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@end
