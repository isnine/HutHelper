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
                 style:indexPath.section==5?UUChartStyleBar:UUChartStyleLine];
                                      //  style:indexPath.section==5?UUChartStyleBar:UUChartStyleLine];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=1; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
int class=0;
    NSMutableArray *score_2013_1=[self get_select:@"2013-2014第1学期"];
    NSMutableArray *score_2013_2=[self get_select:@"2013-2014第2学期"];
    NSMutableArray *score_2014_1=[self get_select:@"2014-2015第1学期"];
    NSMutableArray *score_2014_2=[self get_select:@"2014-2015第2学期"];
    NSMutableArray *score_2015_1=[self get_select:@"2015-2016第1学期"];
    NSMutableArray *score_2015_2=[self get_select:@"2015-2016第2学期"];
    NSMutableArray *score_2016_1=[self get_select:@"2016-2017第1学期"];
    NSMutableArray *score_2016_2=[self get_select:@"2016-2017第2学期"];
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


        switch (path.section) {
            case 0:
          if (class==2) {
               if (score_2015_1.count<score_2015_2.count)
                  return [self getXTitles:score_2015_2.count+1];
                else
                     return [self getXTitles:score_2015_1 .count+1];
                }
                else if(class==3) {
                    if (score_2014_1.count<score_2014_2.count)
                        return [self getXTitles:score_2014_2.count+1];
                    else
                        return [self getXTitles:score_2014_1 .count+1];
                }
                else if(class==4) {
                    if (score_2013_1.count<score_2013_2.count)
                        return [self getXTitles:score_2013_2.count+1];
                    else
                        return [self getXTitles:score_2013_1 .count+1];
                }
            case 1:
        if(class==3) {
            if (score_2015_1.count<score_2015_2.count)
                return [self getXTitles:score_2015_2.count+1];
            else
                return [self getXTitles:score_2015_1 .count+1];
                }
                else if(class==4) {
                    if (score_2014_1.count<score_2014_2.count)
                        return [self getXTitles:score_2014_2.count+1];
                    else
                        return [self getXTitles:score_2014_1 .count+1];
                }
            case 2:
        if(class==4) {
            if (score_2015_1.count<score_2015_2.count)
                return [self getXTitles:score_2015_2.count+1];
            else
                return [self getXTitles:score_2015_1 .count+1];
                  }
            case 4:
             return [self getXTitles:17];
            case 5:
                return [self getXTitles:5];
            default:
                break;
        }

    return [self getXTitles:11];
}
-(NSArray *)getStudent{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"data_score"];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];
    return array_score;
}

-(double)get_zxf:(NSString*)name{
    NSArray *array_score             = [self getStudent];
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

    double z=zjd/zxf;
    return z;
}

-(NSArray *)get_select:(NSString*)name{
    NSArray *array_score             = [self getStudent];
    NSMutableArray *score_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *xf_select=[NSMutableArray arrayWithCapacity:30];
    NSMutableArray *score_select2=[NSMutableArray arrayWithCapacity:30];
    for(int i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
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
        
        string_xn         = [string_xn stringByAppendingString:@"第"];
        string_xn         = [string_xn stringByAppendingString:string_xq];
        string_xn         = [string_xn stringByAppendingString:@"学期"];
        
     NSInteger *int_score          = [string_score intValue];
    NSInteger *int_score2          = [string_score2 intValue];
        if ([string_xn isEqualToString:name]) {
            if (int_score<60&&int_score<int_score2) {
                [score_select addObject:string_score2];
            }
            else{
            [score_select addObject:string_score];
            }
        }
    }

    for (int i=0; i<score_select.count; i++) {
        for (int k=i; k<score_select.count; k++) {
            NSInteger *a=[score_select[i] intValue];
            NSInteger *b=[score_select[k] intValue];
            if (a<=b) {
                 [score_select exchangeObjectAtIndex:i withObjectAtIndex:k];
            }
           
        }
    }

    return score_select;
}
//数值多重数组

- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
int class=0;
    NSMutableArray *score_2013_1=[self get_select:@"2013-2014第1学期"];
    NSMutableArray *score_2013_2=[self get_select:@"2013-2014第2学期"];
    NSMutableArray *score_2014_1=[self get_select:@"2014-2015第1学期"];
    NSMutableArray *score_2014_2=[self get_select:@"2014-2015第2学期"];
    NSMutableArray *score_2015_1=[self get_select:@"2015-2016第1学期"];
    NSMutableArray *score_2015_2=[self get_select:@"2015-2016第2学期"];
    NSMutableArray *score_2016_1=[self get_select:@"2016-2017第1学期"];
    NSMutableArray *score_2016_2=[self get_select:@"2016-2017第2学期"];
 

    NSString *xf_2013_1=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2013-2014第1学期"]];
    NSString *xf_2013_2=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2013-2014第2学期"]];
    NSString *xf_2014_1=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2014-2015第1学期"]];
    NSString *xf_2014_2=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2014-2015第2学期"]];
    NSString *xf_2015_1=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2015-2016第1学期"]];
    NSString *xf_2015_2=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2015-2016第2学期"]];
    NSString *xf_2016_1=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2016-2017第1学期"]];
    NSString *xf_2016_2=[NSString stringWithFormat:@"%lf\n",[self get_zxf:@"2016-2017第2学期"]];

    NSArray *jd ;
    NSArray *jd2 ;
    NSLog(@"%@",xf_2015_1);
    if(score_2013_1.count != 0){  //大四
       jd = @[xf_2013_1,xf_2014_1,xf_2015_1,xf_2016_1];
      jd2 = @[xf_2013_2,xf_2014_2,xf_2015_2,xf_2016_2];
        class=4;
    }
    else if (score_2014_1.count != 0){ //大三
       jd = @[xf_2014_1,xf_2015_1,xf_2016_1];
       jd2 = @[xf_2014_2,xf_2015_2,xf_2016_2];
        class=3;
    }
    else if (score_2015_1.count != 0){ //大二
     jd = @[xf_2015_1,xf_2016_1];
      jd2 = @[xf_2015_2,xf_2016_2];
        class=2;
    }
    else{  //大一
      jd = @[xf_2016_1];
       jd2 = @[xf_2016_2];
        class=1;
    }



NSArray *ary1 = @[];
NSArray *ary2 = @[@"2.3",@"2.5",@"2.6"];

        switch (path.section) {
           case 0:
                if (class==1) {
                    
                    return @[score_2016_1,score_2016_2];
                }
                else if (class==2) {
                    return @[score_2015_1,score_2015_2];
                }
                else if(class==3) {
                    return @[score_2014_1,score_2014_2];
                }
                else if(class==4) {
                    return @[score_2013_1,score_2013_2];
                }
                else
                    return @[ary1];
                
           case 1:
                
                if (class==2) {
                    return @[score_2016_1,score_2016_2];
                }
                else if(class==3) {
                   
                    return @[score_2015_1,score_2015_2];
                }
                else if(class==4) {
                    return @[score_2014_1,score_2014_2];
                }
                else
                    return @[ary1];
                
           case 2:
                if (class==3) {
                    return @[score_2016_1,score_2016_2];
                }
                else if(class==4) {
                    return @[score_2015_1,score_2015_2];
                }
                else
                    return @[ary1];
                
           case 3:
                if(class==4) {
                    return @[score_2016_1,score_2016_2,score_2014_1,score_2014_2];
                }
                else
                    return @[ary1];
            case 4:
                if (class==1) {
                    return @[score_2016_1,score_2016_2];
                }
                else if (class==2) {
                    return @[score_2015_1,score_2015_2];
                }
                else if(class==3) {
                    return @[score_2014_1,score_2014_2,score_2015_1,score_2015_2];
                }
                else if(class==4) {
                    return @[score_2013_1,score_2013_2,score_2014_1,score_2014_2,score_2015_1,score_2015_2];
                }
           case 5:
                return @[jd,jd2];
        default:
                return @[ary1,];
        }
}



#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor red],[UUColor green],[UUColor randomColor],[UUColor randomColor],[UUColor randomColor],[UUColor randomColor],[UUColor randomColor],[UUColor randomColor]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{

        if (path.section==5 ) {
            return CGRangeMake(5, 0);
        }
    return CGRangeMake(100, 0);
}


#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
//    if (path.row == 2) {
//        return CGRangeMake(25, 75);
//    }

   return CGRangeMake(0,60);
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
