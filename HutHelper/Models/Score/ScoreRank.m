
//
//  ScoreRank.m
//  HutHelper
//
//  Created by Nine on 2017/4/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreRank.h"

@implementation ScoreRank

-(instancetype)initWithArray:(NSArray*)data{
    self=[super init];
    if (self) {
        self.rank=[data[0][0] objectForKey:@"MC"];
        self.GPA=[data[0][0] objectForKey:@"ZJD"];
        for (NSDictionary *eachDic in data[1]) {
            ScoreRank *scoreYearRank=[[ScoreRank alloc]initWithYearDic:eachDic];
            [self.yearMutableArray  addObject: scoreYearRank ];
        }
        for (NSDictionary *eachDic in data[2]) {
            ScoreRank *scoreTermRank=[[ScoreRank alloc]initWithTermDic:eachDic];
            [self.termMutableArray  addObject: scoreTermRank ];
        }
    }
    return  self;
}


-(instancetype)initWithYearDic:(NSDictionary*)yearDic{
    self=[super init];
    if (self) {
            self.year=[yearDic objectForKey:@"XN"];
            self.rank=[yearDic objectForKey:@"MC"];
            self.GPA=[yearDic objectForKey:@"ZJD"];
    }
    return  self;
}

-(instancetype)initWithTermDic:(NSDictionary*)termDic{
    self=[super init];
    if (self) {
        self.year=[termDic objectForKey:@"XN"];
        self.rank=[termDic objectForKey:@"MC"];
        self.term=[termDic objectForKey:@"XQ"];
        self.GPA=[termDic objectForKey:@"ZJD"];
    }
    return  self;
}


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
