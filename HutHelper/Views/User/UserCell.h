//
//  UserCell.h
//  HutHelper
//
//  Created by nine on 2017/11/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *infoStr;

-(instancetype)initWithName:(NSString*)nameStr withInfo:(NSString*)infoStr reuseIdentifier:(NSString *)reuseIdentifier;
@end
