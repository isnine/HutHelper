//
//  Lost.h
//  HutHelper
//
//  Created by nine on 2017/8/4.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lost : NSObject
-(instancetype)initWithDic:(NSDictionary *)dic;
/**拾起物品*/
@property(nonatomic,copy)NSString *tit;
/**内容*/
@property(nonatomic,copy)NSString *content;
/**发布人*/
@property(nonatomic,copy)NSString *username;
/**发布人头像*/
@property(nonatomic,copy)NSString *head_pic;
/**发布人学院*/
@property(nonatomic,copy)NSString *dep_name;
/**发布时间*/
@property(nonatomic,copy)NSString *created_on;
/**拾取时间*/
@property(nonatomic,copy)NSString *time;
/**拾取地点*/
@property(nonatomic,copy)NSString *locate;
/**联系电话*/
@property(nonatomic,copy)NSString *phone;
/**发布人id*/
@property(nonatomic,copy)NSString *user_id;
/**物品id*/
@property(nonatomic,copy)NSString *id;
/**说说的小图*/
@property(nonatomic,copy)NSMutableArray *pics;
/**背景颜色*/
@property(nonatomic,assign)NSInteger blackColor;
/**文本高度*/
@property(nonatomic,assign)double textHeight;
/**文本宽度*/
@property(nonatomic,assign)double textWidth;
/**照片高度*/
@property(nonatomic,assign)double photoHeight;
@end
