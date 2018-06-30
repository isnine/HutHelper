
//
//  ScoreRank.m
//  HutHelper
//
//  Created by Nine on 2017/4/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreRank.h"

@implementation ScoreRank

-(instancetype)initWithArray:(NSDictionary*)data{
    self=[super init];
    if (self) {
        for (NSDictionary *eachDic in [data objectForKey:@"xqrank"]) {
            ScoreRank *scoreTermRank=[[ScoreRank alloc]initWithTermDic:eachDic];
            [self.termMutableArray  addObject: scoreTermRank ];
        }
        for (NSDictionary *eachDic in [data  objectForKey:@"xnrank"]) {
            ScoreRank *scoreYearRank=[[ScoreRank alloc]initWithYearDic:eachDic];
            [self.yearMutableArray addObject: scoreYearRank ];
        }
        
    }
    return  self;
}

#pragma mark - 字典
-(instancetype)initWithYearDic:(NSDictionary*)yearDic{
    self=[super init];
    if (self) {
            self.year=[yearDic objectForKey:@"xn"];
            self.bjRank=[yearDic objectForKey:@"bjrank"];
            self.zyRank=[yearDic objectForKey:@"zyrank"];
            self.GPA=[yearDic objectForKey:@"zhjd"];
    }
    return  self;
}

-(instancetype)initWithTermDic:(NSDictionary*)termDic{
    self=[super init];
    if (self) {
        self.year=[termDic objectForKey:@"xn"];
        self.bjRank=[termDic objectForKey:@"bjrank"];
        self.zyRank=[termDic objectForKey:@"zyrank"];
        self.GPA=[termDic objectForKey:@"zhjd"];
        self.term=[termDic objectForKey:@"xq"];
    }
    return  self;
}


#pragma mark - 数组
-(NSMutableArray *)yearMutableArray{
    if (!_yearMutableArray) {
        _yearMutableArray = [NSMutableArray array];
    }
    return _yearMutableArray;
}
-(NSMutableArray *)termMutableArray{
    if (!_termMutableArray) {
        _termMutableArray = [NSMutableArray array];
    }
    return _termMutableArray;
}
@end
