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
@property NSString *last_use;
/**性别*/
@property NSString *active;
/**学号*/
@property NSString *studentKH;
/**昵称*/
@property NSString *username;
/**用户id*/
@property NSString *user_id;
/**签名*/
@property NSString *bio;
-(instancetype)initWithDic:(NSDictionary*)Dic;
@end

@interface UserNew : NSObject
/**用户id*/
@property NSString *user_id;
/**学号*/
@property NSString *studentKH;
/**姓名*/
@property NSString *TrueName;
/**昵称*/
@property NSString *username;
/**学院*/
@property NSString *dep_name;
/**班级*/
@property NSString *class_name;
/**省份*/
@property NSString *address;
/**性别*/
@property NSString *active;
/**最后一次登录*/
@property NSString *last_use;
/**签名*/
@property NSString *bio;
/**头像无压缩*/
@property NSString *head_pic;
/**头像*/
@property NSString *head_pic_thumb;
/**token*/
@property NSString *remember_code_app;

-(instancetype)initWithDic:(NSDictionary*)Dic;
@end
