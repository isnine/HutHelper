//
//  User.h
//  HutHelper
//
//  Created by nine on 2017/1/12.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
/**姓名*/
@property NSString *TrueName;
/**省份*/
@property NSString *address;
/**班级*/
@property NSString *class_name;
/**学院*/
@property NSString *dep_name;
/**头像无压缩*/
@property NSString *head_pic;
/**头像*/
@property NSString *head_pic_thumb;
/**最后一次登录*/
@property NSString *last_login;
/**性别*/
@property NSString *sex;
/**学号*/
@property NSString *studentKH;
/**昵称*/
@property NSString *username;
/**用户id*/
@property NSString *user_id;
-(instancetype)initWithDic:(NSDictionary*)Dic;
@end

