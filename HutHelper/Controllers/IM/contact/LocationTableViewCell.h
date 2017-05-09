//
//  LocationTableViewCell.h
//  BmobIMDemo
//
//  Created by Bmob on 16/3/9.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationChatView.h"
@interface LocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet LocationChatView *chatView;

-(void)setMsg:(BmobIMMessage *)msg userInfo:(BmobIMUserInfo *)userInfo ;

@end
