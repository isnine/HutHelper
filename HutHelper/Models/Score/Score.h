//
//  Score.h
//  HutHelper
//
//  Created by nine on 2017/2/6.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject
-(NSArray *)getStudent;
-(int)getWtg;
-(double)getZxf;
-(double)getZxf:(NSString*)name;
-(NSString*)getScale;
-(NSArray*)getScore:(NSString*)name;
-(NSArray *)getScore;
+(NSString*)getGradeName:(NSString*)Name;
@end
