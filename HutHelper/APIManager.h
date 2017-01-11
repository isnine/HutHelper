//
//  APIManager.h
//  HutHelper
//
//  Created by nine on 2017/1/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject
@property (nonatomic, copy)NSString *studentNam;
-(NSString*)Login:(NSString*)UserName_String With:(NSString*)Password_String;
-(NSString*)GetClass;
@end
