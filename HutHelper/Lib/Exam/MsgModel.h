//
//  MsgModel.h
//  demo1
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MsgModel : NSObject
@property (strong,nonatomic) NSString * address;//地点
@property (strong,nonatomic) NSString * motive;//目的
@property (strong,nonatomic) NSString * date;//时间

@property (strong,nonatomic) UIColor * color;
@end
