//
//  ScoreRank.h
//  HutHelper
//
//  Created by Nine on 2017/4/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreRank : NSObject
//总排名与绩点
@property (nonatomic,copy)NSString *bjRank;
@property (nonatomic,copy)NSString *zyRank;
@property (nonatomic,copy)NSString *GPA;
//学年排名与绩点
@property (nonatomic,copy)NSMutableArray *yearMutableArray;
@property (nonatomic,copy)NSMutableArray *year2MutableArray;
@property (nonatomic,copy)NSString *year;
//学期排名与绩点
@property (nonatomic,copy)NSMutableArray *termMutableArray;
@property (nonatomic,copy)NSMutableArray *term2MutableArray;
@property (nonatomic,copy)NSString *term;

-(instancetype)initWithBjTermArray:(NSDictionary*)data;
-(instancetype)initWithArray:(NSDictionary*)data;
@end


