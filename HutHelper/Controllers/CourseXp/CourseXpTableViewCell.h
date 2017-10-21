//
//  CourseXpTableViewCell.h
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseXp;
@interface CourseXpTableViewCell : UITableViewCell
@property (nonatomic, weak) CourseXp *data;
-(void)draw;
@end
