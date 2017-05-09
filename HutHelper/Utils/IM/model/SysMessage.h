//
//  SysMessage.h
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface SysMessage : BmobObject

@property (strong, nonatomic) BmobUser *fromUser;

@property (strong, nonatomic) BmobUser *toUser;

@property (strong, nonatomic) NSNumber *type;

@end
