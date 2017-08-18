//
//  ChatChoiceTableViewCell.h
//  HutHelper
//
//  Created by nine on 2017/8/15.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatUser;
@interface ChatChoiceTableViewCell : UITableViewCell
@property (nonatomic,copy) ChatUser *chatUser;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;



@end
