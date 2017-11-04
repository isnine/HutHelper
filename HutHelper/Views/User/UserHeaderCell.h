//
//  UserNameCell.h
//  HutHelper
//
//  Created by nine on 2017/11/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderCell : UITableViewCell
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *imgUrlStr;

-(instancetype)initWithName:(NSString*)nameStr withInfo:(NSString*)imgUrlStr reuseIdentifier:(NSString *)reuseIdentifier;
@end
