//
//  Exam.h
//  HutHelper
//
//  Created by nine on 2017/5/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exam : NSObject
@property(nonatomic,copy)NSString* CourseName;
@property(nonatomic,copy)NSString* EndTime;
@property(nonatomic,copy)NSString* RoomName;
@property(nonatomic,copy)NSString* Starttime;
@property(nonatomic,copy)NSString* isset;
-(instancetype)initWithDic:(NSDictionary*)Dic;
-(instancetype)initWithCXDic:(NSDictionary*)Dic;
@end
