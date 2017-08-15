//
//  ChatUser.h
//  HutHelper
//
//  Created by nine on 2017/8/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatUser : NSObject
/**姓名*/
@property NSString *TrueName;
/**user_id*/
@property NSString *user_id;
/**班级*/
@property NSString *class_name;
/**学院*/
@property NSString *dep_name;
/**头像无压缩*/
@property NSString *head_pic;
/**头像*/
@property NSString *head_pic_thumb;
/**最后一次登录*/
@property NSString *last_use;
/**性别*/
@property NSString *sex;
-(instancetype)initWithDic:(NSDictionary*)Dic;
@end
