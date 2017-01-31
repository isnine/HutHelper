//
//  SayCommitViewCell.h
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SayCommitViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CommitName;
@property (weak, nonatomic) IBOutlet UITextView *CommitContent;
@property (weak, nonatomic) IBOutlet UILabel *CommitTime;
@property (weak, nonatomic) IBOutlet UIButton *delectButton;
+(instancetype)tableViewCell;
@end
