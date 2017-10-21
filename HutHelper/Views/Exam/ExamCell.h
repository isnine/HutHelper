//
//  ExamCell.h
//  HutHelper
//
//  Created by nine on 2017/1/11.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Label_ExamName;
@property (weak, nonatomic) IBOutlet UILabel *Label_ExamRoom;
@property (weak, nonatomic) IBOutlet UILabel *Label_ExamTime;
@property (weak, nonatomic) IBOutlet UILabel *Label_ExamLast;
@property (weak, nonatomic) IBOutlet UILabel *examDayLabel;


+(instancetype)tableViewCell;
@end
