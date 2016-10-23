//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChart.h"
#import "JSONKit.h"
@interface TableViewCell ()<UUChartDataSource>
{
    NSIndexPath *path;
    UUChart *chartView;
}
@end

@implementation TableViewCell


- (void)configUI:(NSIndexPath *)indexPath
{
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    
    path = indexPath;
    
    chartView = [[UUChart alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, 150)
                                   dataSource:self
                                        style:indexPath.section==1?UUChartStyleBar:UUChartStyleLine];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{

    NSMutableArray *score_2013_1=[self get_select:@"2013-2014第1学期"];
    NSMutableArray *score_2013_2=[self get_select:@"2013-2014第2学期"];
    NSMutableArray *score_2014_1=[self get_select:@"2014-2015第1学期"];
    NSMutableArray *score_2014_2=[self get_select:@"2014-2015第2学期"];
    NSMutableArray *score_2015_1=[self get_select:@"2015-2016第1学期"];
    NSMutableArray *score_2015_2=[self get_select:@"2015-2016第2学期"];
    
    NSMutableArray *score_11;
    NSMutableArray *score_12;
    NSMutableArray *score_21;
    NSMutableArray *score_22;
    NSMutableArray *score_31;
    NSMutableArray *score_32;
    
    if(score_2013_1.count != 0){  //大四

        class=4;
    }
    else if (score_2014_1.count != 0){ //大三

        class=3;
    }
    else if (score_2015_1.count != 0){ //大二

        class=2;
    }
    else{  //大一
        class=1;
    }

    if (path.section==0) {
        switch (path.row) {
            case 0:
                if (class==2) {
                    return [self getXTitles:score_2015_1.count];
                }
                else if(class==3) {
                    return [self getXTitles:score_2014_1.count];
                }
                else if(class==4) {
                    return [self getXTitles:score_2013_1.count];
                }
            case 1:
                if (class==2) {
                    return [self getXTitles:score_2015_2.count];
                }
                else if(class==3) {
                    return [self getXTitles:score_2014_2.count];
                }
                else if(class==4) {
                    return [self getXTitles:score_2013_2.count];
                }
            case 2:
                  if(class==3) {
                    return [self getXTitles:score_2015_1.count];
                }
                  else if(class==4) {
                      return [self getXTitles:score_2014_1.count];
                  }
            case 3:
                if(class==3) {
                    return [self getXTitles:score_2015_2.count];
                }
                else if(class==4) {
                    return [self getXTitles:score_2014_2.count];
                }
            default:
                break;
        }
    }else{
        switch (path.row) {
            case 0:
                return [self getXTitles:11];
            case 1:
                return [self getXTitles:7];
            default:
                break;
        }
    }
    return [self getXTitles:10];
}
-(NSArray *)getStudent{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"data_score"];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];
    return array_score;
}

-(NSArray *)get_select:(NSString*)name{
    NSArray *array_score             = [self getStudent];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:230];
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
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
        
        string_xn         = [string_xn stringByAppendingString:@"第"];
        string_xn         = [string_xn stringByAppendingString:string_xq];
        string_xn         = [string_xn stringByAppendingString:@"学期"];
        
        if ([string_xn isEqualToString:name]) {
            [score_select addObject:string_score];
        }
    }
    return score_select;
}
//数值多重数组
int class=0;
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{

    NSMutableArray *score_2013_1=[self get_select:@"2013-2014第1学期"];
    NSMutableArray *score_2013_2=[self get_select:@"2013-2014第2学期"];
    NSMutableArray *score_2014_1=[self get_select:@"2014-2015第1学期"];
    NSMutableArray *score_2014_2=[self get_select:@"2014-2015第2学期"];
    NSMutableArray *score_2015_1=[self get_select:@"2015-2016第1学期"];
    NSMutableArray *score_2015_2=[self get_select:@"2015-2016第2学期"];

    
    if(score_2013_1.count != 0){  //大四
        class=4;
    }
    else if (score_2014_1.count != 0){ //大三
        class=3;
    }
    else if (score_2015_1.count != 0){ //大二
        class=2;
    }
    else{  //大一
        class=1;
    }

    
    NSLog(@"%@",score_2013_1[2]);
    NSLog(@"总共课程数目:%d",score_2013_1.count);

    NSArray *ary1 = @[@"0"];

    
    if (path.section==0) {
        switch (path.row) {
            case 0:
                if (class==2) {
                    return @[score_2015_1];
                }
                else if(class==3) {
                    return @[score_2014_1];
                }
                else if(class==4) {
                    return @[score_2013_1];
                }
            case 1:
                if (class==2) {
                    return @[score_2015_2];
                }
                else if(class==3) {
                    return @[score_2014_2];
                }
                else if(class==4) {
                    return @[score_2013_2];
                }
            case 2:
                if(class==3) {
                    return @[score_2015_1];
                }
                else if(class==4) {
                    return @[score_2014_1];
                }
            case 3:
                if(class==3) {
                    return @[score_2015_2];
                }
                else if(class==4) {
                    return @[score_2014_2];
                }
            default:
                return @[ary1];
        }
    }else{
        if (path.row) {
            return @[ary1,ary1];
        }else{
            return @[ary1];
        }
    }
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor red],[UUColor brown]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    if (path.section==0 ) {
        return CGRangeMake(100, 00);
    }
    if (path.section==1 && path.row==0) {
        return CGRangeMake(60, 10);
    }
    if (path.row == 2) {
        return CGRangeMake(100, 0);
    }
    return CGRangeZero;
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
//    if (path.row == 2) {
//        return CGRangeMake(25, 75);
//    }
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return YES;
}
@end
