//
//  MomentsTableView.h
//  HutHelper
//
//  Created by Nine on 2017/3/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentsTableView : UITableView
-(void)HiddenMJ;
-(void)beginload;
-(void)reload;
@property(nonatomic,copy)NSDictionary *JSONDic;
@property(nonatomic,copy)NSDictionary *LikesDic;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withSay:(NSDictionary *)JSONDic withSayLike:(NSDictionary *)LikesDic;
@end
