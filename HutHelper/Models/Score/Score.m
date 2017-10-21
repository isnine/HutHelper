//
//  Score.m
//  HutHelper
//
//  Created by nine on 2017/2/6.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "Score.h"
#import "JSONKit.h"
@implementation Score

/**
 从NSUserDefaults读取成绩并放到数组
 
 @return 成绩数组
 */
-(NSArray *)getScore{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"Score"];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];
    return array_score;
}

/**
 得到未通过的课程数目
 
 @return 未通过的课程
 */
-(int)getWtg{
    NSArray *array_score             = [self getScore];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *xf_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *score_select2=[NSMutableArray arrayWithCapacity:30];
    
    int wtg=0;
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
        NSString *string_xf= [dict1 objectForKey:@"XF"];//学期
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
        if ([string_name isEqual:[NSNull null]]) {
            string_name       = @"NULL";//名字
        }
        if ([string_score isEqual:[NSNull null]]) {
            string_score          = @"0";//成绩
        }
        if ([string_xn isEqual:[NSNull null]]) {
            string_xn         = @"NULL";//学期
        }
        if ([string_xq isEqual:[NSNull null]]) {
            string_xq         = @"NULL";//学期
        }
        if ([string_score2 isEqual:[NSNull null]]) {
            string_score2         = @"0";//学期
        }
        if ([string_xf isEqual:[NSNull null]]) {
            string_xf         = @"0.1";//学期
        }
        if ([string_cxbj isEqual:[NSNull null]]) {
            string_cxbj         = @"NULL";//学期
        }
        
        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        
        if (int_score<60&&int_score<int_score2) {
            int_score=int_score2;
        }
        
        if (int_score<60) {
            wtg++;
        }
        if([string_cxbj isEqualToString:@"1"]){
            wtg=wtg-1;
            
        }
        
    }
    if (wtg<0) {
        wtg=0;
    }
    
    return wtg;
}


/**
 所有学期的总绩点
 
 @return 总绩点
 */
-(double)getZxf{
    NSArray *array_score             = [self getScore];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *xf_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *score_select2=[NSMutableArray arrayWithCapacity:30];
    double zjd=0.0;
    double zxf=0.0;
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
        NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记
        NSString *string_xf= [dict1 objectForKey:@"XF"];//学期
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
        if ([string_name isEqual:[NSNull null]])  string_name       = @"NULL";//名字
        
        if ([string_score isEqual:[NSNull null]])  string_score          = @"0";//成绩
        
        if ([string_xn isEqual:[NSNull null]])    string_xn         = @"NULL";//学期
        
        if ([string_xq isEqual:[NSNull null]])  string_xq         = @"NULL";//学期
        
        if ([string_score2 isEqual:[NSNull null]]) string_score2         = @"0";//学期
        
        if ([string_xf isEqual:[NSNull null]])  string_xf         = @"0.1";//学期
        
        if ([string_cxbj isEqual:[NSNull null]]) string_cxbj         = @"NULL";//学期
        
        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        
        if (int_score<60&&int_score<int_score2) {
            int_score=int_score2;
        }
        if(int_score>=60){
            zjd=zjd+(int_score*1.0-50.0)*double_xf/10.0;
        }
        zxf=zxf+double_xf*1.0;
        
        if([string_cxbj isEqualToString:@"1"]){
            zxf=zxf-double_xf*1.0;
        }
        
        
    }
    
    double z=zjd/zxf;
    return z;
}


/**
 得到各个学期的总学分

 @param name 学期名
 @return 该学期的绩点
 */
-(double)getZxf:(NSString*)name{
    NSArray *array_score             = [self getScore];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *xf_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *score_select2=[NSMutableArray arrayWithCapacity:30];
    double zjd=0.0;
    double zxf=0.0;
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
        NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记
        NSString *string_xf= [dict1 objectForKey:@"XF"];//学期
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
        if ([string_name isEqual:[NSNull null]]) {
            string_name       = @"NULL";//名字
        }
        if ([string_score isEqual:[NSNull null]]) {
            string_score          = @"0";//成绩
        }
        if ([string_xn isEqual:[NSNull null]]) {
            string_xn         = @"NULL";//学期
        }
        if ([string_xq isEqual:[NSNull null]]) {
            string_xq         = @"NULL";//学期
        }
        if ([string_score2 isEqual:[NSNull null]]) {
            string_score2         = @"0";//学期
        }
        if ([string_xf isEqual:[NSNull null]]) {
            string_xf         = @"0.1";//学期
        }
        if ([string_cxbj isEqual:[NSNull null]]) {
            string_cxbj         = @"NULL";//学期
        }
        string_xn         = [string_xn stringByAppendingString:@"第"];
        string_xn         = [string_xn stringByAppendingString:string_xq];
        string_xn         = [string_xn stringByAppendingString:@"学期"];
        
        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        if ([string_xn isEqualToString:name]) {
            if (int_score<60&&int_score<int_score2) {
                int_score=int_score2;
            }
            if(int_score>=60){
                zjd=zjd+(int_score*1.0-50.0)*double_xf/10.0;
            }
            zxf=zxf+double_xf*1.0;
            
            if([string_cxbj isEqualToString:@"1"]){
                zxf=zxf-double_xf*1.0;
            }
        }
    }
    double     z=zjd/zxf;
    if (z>0.0&&z<=5.0) {
        return z;
    }
    else
    return 0.0;
}

/**
 得到未得学分/总学分
 
 @return 未得学分/总学分
 */
-(NSString*)getScale{
    NSArray *array_score             = [self getScore];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *xf_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *score_select2=[NSMutableArray arrayWithCapacity:30];
    
    double wtg=0.0;
    double zxf=0.0;
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
        NSString *string_xf= [dict1 objectForKey:@"XF"];//学分
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
        if ([string_name isEqual:[NSNull null]]) {
            string_name       = @"NULL";//名字
        }
        if ([string_score isEqual:[NSNull null]]) {
            string_score          = @"0";//成绩
        }
        if ([string_xn isEqual:[NSNull null]]) {
            string_xn         = @"NULL";//学期
        }
        if ([string_xq isEqual:[NSNull null]]) {
            string_xq         = @"NULL";//学期
        }
        if ([string_score2 isEqual:[NSNull null]]) {
            string_score2         = @"0";//学期
        }
        if ([string_xf isEqual:[NSNull null]]) {
            string_xf         = @"0.1";//学期
        }
        if ([string_cxbj isEqual:[NSNull null]]) {
            string_cxbj         = @"NULL";//学期
        }
        
        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        
        if (int_score<60&&int_score<int_score2) {
            int_score=int_score2;
        }
        
        if (int_score<60) {
            wtg+=double_xf;
            zxf+=double_xf;
        }
        else
            zxf+=double_xf;
        if([string_cxbj isEqualToString:@"1"]){
            wtg-=double_xf;
            zxf-=double_xf;
        }
        
        
    }
    if (wtg<0.0) {
        wtg=0.0;
    }
    NSString *result=[NSString stringWithFormat:@"%.1lf/%.1lf",wtg,zxf];
    return result;
}


/**
 分学期返回 考试名/成绩

 @param name 学期名
 @return 该学期的数组
 */
-(NSArray*)getScore:(NSString*)name{
    NSMutableArray *result= [[NSMutableArray alloc] init];
    NSArray *array_score             = [self getScore];
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期

        if ([string_xn isEqual:[NSNull null]])
            string_xn         = @"NULL";//学期
        
        if ([string_xq isEqual:[NSNull null]])
            string_xq         = @"NULL";//学期

        string_xn         = [string_xn stringByAppendingString:@"第"];
        string_xn         = [string_xn stringByAppendingString:string_xq];
        string_xn         = [string_xn stringByAppendingString:@"学期"];
        if ([string_xn isEqualToString:name])
                [result addObject:array_score[i]];
    }
        return result;
}
+(NSString*)getGradeName:(NSString*)Name{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int grade=[[defaults objectForKey:@"sourceGrade"] intValue];
    switch (grade) {
        case 1:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2016-2017第1学期";
            
            break;
        case 2:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2016-2017第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2016-2017第2学期";
            break;
        case 3:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2016-2017第1学期";
            break;
        case 4:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2016-2017第1学期";
            else if ([Name isEqualToString:@"大二下学期"])
                return @"2016-2017第2学期";
            break;
        case 5:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2014-2015第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2014-2015第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大二下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大三上学期"])
                return @"2016-2017第1学期";
            break;
        case 6:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2014-2015第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2014-2015第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大二下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大三上学期"])
                return @"2016-2017第1学期";
            else if ([Name isEqualToString:@"大三下学期"])
                return @"2016-2017第2学期";
            break;
        case 7:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2013-2014第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2013-2014第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2014-2015第1学期";
            else if ([Name isEqualToString:@"大二下学期"])
                return @"2014-2015第2学期";
            else if ([Name isEqualToString:@"大三上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大三下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大四上学期"])
                return @"2016-2017第1学期";
            break;
        case 8:
            if ([Name isEqualToString:@"大一上学期"])
                return @"2013-2014第1学期";
            else if ([Name isEqualToString:@"大一下学期"])
                return @"2013-2014第2学期";
            else if ([Name isEqualToString:@"大二上学期"])
                return @"2014-2015第1学期";
            else if ([Name isEqualToString:@"大二下学期"])
                return @"2014-2015第2学期";
            else if ([Name isEqualToString:@"大三上学期"])
                return @"2015-2016第1学期";
            else if ([Name isEqualToString:@"大三下学期"])
                return @"2015-2016第2学期";
            else if ([Name isEqualToString:@"大四上学期"])
                return @"2016-2017第1学期";
            else if ([Name isEqualToString:@"大四下学期"])
                return @"2016-2017第2学期";
            break;
    }
    return @"2016-2017第1学期";
}

@end
