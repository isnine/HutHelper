//
//  ScoreViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/18.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ScoreViewController.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "JSONKit.h"
@interface ScoreViewController ()
@property (nonatomic, strong) NSArray *contents;

@end

@implementation ScoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)contents
{
  



    if (!_contents)
    {
         NSLog(@"加载");
        _contents = @[
                      @[
                          @[@"Section0_Row0", @"Row0_Subrow1",@"Row0_Subrow2"],
                          @[@"Section0_Row1", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"],
                          @[@"Section0_Row2"]],
                      @[
                          @[@"Section1_Row0", @"Row0_Subrow1", @"Row0_Subrow2", @"Row0_Subrow3"],
                          @[@"Section1_Row1"],
                          @[@"Section1_Row2", @"Row2_Subrow1", @"Row2_Subrow2", @"Row2_Subrow3", @"Row2_Subrow4", @"Row2_Subrow5"],
                          @[@"Section1_Row3"],
                          @[@"Section1_Row4"],
                          @[@"Section1_Row5"],
                          @[@"Section1_Row6"],
                          @[@"Section1_Row7"],
                          @[@"Section1_Row8"],
                          @[@"Section1_Row9"],
                          @[@"Section1_Row10"],
                          @[@"Section1_Row11"]]
                      ];
    }
    
    return _contents;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.SKSTableViewDelegate = self;
    self.navigationItem.title = @"成绩查询";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"折叠"
                                                                              style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                             action:@selector(collapseSubrows)];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *String_score=[defaults objectForKey:@"string_score"];
    NSURL *url                 = [NSURL URLWithString: String_score];//接口地址
    NSError *error             = nil;
    NSString *ScoreString       = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* ScoreData           = [ScoreString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];

  
    NSMutableArray *score_name=[NSMutableArray arrayWithCapacity:200];
    NSMutableArray *score_score=[NSMutableArray arrayWithCapacity:200];
    NSMutableArray *score_xf=[NSMutableArray arrayWithCapacity:200];
    NSMutableArray *score_time=[NSMutableArray arrayWithCapacity:200];
    int i=0;

    
    for(i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name       = [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score          = [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_xf         = [dict1 objectForKey:@"XF"];//学分
        NSString *string_xn         = [dict1 objectForKey:@"XN"];//学期
        NSString *string_xq         = [dict1 objectForKey:@"XQ"];//学期
        string_xn         = [string_xn stringByAppendingString:@"第"];
        string_xn         = [string_xn stringByAppendingString:string_xq];
        string_xn         = [string_xn stringByAppendingString:@"学期"];
        
        [score_name addObject:string_name];
        [score_score addObject:string_score];
        [score_xf addObject:string_xf];
        [score_time addObject:string_xn];
    }
    for(i=array_score.count;i<200;i++){
        [score_name addObject:@""];
        [score_score addObject:@""];
        [score_xf addObject:@""];
        [score_time addObject:@""];
    }
    NSLog(@"%@",array_score[0]);
     NSLog(@"%d",array_score.count);
    
    NSString *a=@"分数:";
    NSString *b=@"学分:";
    NSString *c=@"学期:";
    
    NSArray *array;
    switch (array_score.count) {
        case 1:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  ]];
            break;
        case 2:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  ]];
            break;
        case 3:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  ]];
            break;
        case 4:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  ]];
            break;
        case 5:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  ]];
            break;
        case 6:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  ]];
            break;
        case 7:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  ]];
            break;
        case 8:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  ]];
            break;
        case 9:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  ]];
            break;
        case 10:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  ]];
            break;
        case 11:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  ]];
            break;
        case 12:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  ]];
            break;
        case 13:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  ]];
            break;
        case 14:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  ]];
            break;
        case 15:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  ]];
            break;
        case 16:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  ]];
            break;
        case 17:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  ]];
            break;
        case 18:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  ]];
            break;
        case 19:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  ]];
            break;
        case 20:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  ]];
            break;
        case 21:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  ]];
            break;
        case 22:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  ]];
            break;
        case 23:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  ]];
            break;
        case 24:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  ]];
            break;
        case 25:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  ]];
            break;
        case 26:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  @[score_name[25], [a stringByAppendingString:score_score[25]],[b stringByAppendingString:score_xf[25]],[c stringByAppendingString:score_time[25]]],
  ]];
            break;
        case 27:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  @[score_name[25], [a stringByAppendingString:score_score[25]],[b stringByAppendingString:score_xf[25]],[c stringByAppendingString:score_time[25]]],
  @[score_name[26], [a stringByAppendingString:score_score[26]],[b stringByAppendingString:score_xf[26]],[c stringByAppendingString:score_time[26]]],
  ]];
            break;
        case 28:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  @[score_name[25], [a stringByAppendingString:score_score[25]],[b stringByAppendingString:score_xf[25]],[c stringByAppendingString:score_time[25]]],
  @[score_name[26], [a stringByAppendingString:score_score[26]],[b stringByAppendingString:score_xf[26]],[c stringByAppendingString:score_time[26]]],
  @[score_name[27], [a stringByAppendingString:score_score[27]],[b stringByAppendingString:score_xf[27]],[c stringByAppendingString:score_time[27]]],
  ]];
            break;
        case 29:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  @[score_name[25], [a stringByAppendingString:score_score[25]],[b stringByAppendingString:score_xf[25]],[c stringByAppendingString:score_time[25]]],
  @[score_name[26], [a stringByAppendingString:score_score[26]],[b stringByAppendingString:score_xf[26]],[c stringByAppendingString:score_time[26]]],
  @[score_name[27], [a stringByAppendingString:score_score[27]],[b stringByAppendingString:score_xf[27]],[c stringByAppendingString:score_time[27]]],
  @[score_name[28], [a stringByAppendingString:score_score[28]],[b stringByAppendingString:score_xf[28]],[c stringByAppendingString:score_time[28]]],
  ]];
            break;
        case 30:
            array = @[@[
  @[score_name[0], [a stringByAppendingString:score_score[0]],[b stringByAppendingString:score_xf[0]],[c stringByAppendingString:score_time[0]]],
  @[score_name[1], [a stringByAppendingString:score_score[1]],[b stringByAppendingString:score_xf[1]],[c stringByAppendingString:score_time[1]]],
  @[score_name[2], [a stringByAppendingString:score_score[2]],[b stringByAppendingString:score_xf[2]],[c stringByAppendingString:score_time[2]]],
  @[score_name[3], [a stringByAppendingString:score_score[3]],[b stringByAppendingString:score_xf[3]],[c stringByAppendingString:score_time[3]]],
  @[score_name[4], [a stringByAppendingString:score_score[4]],[b stringByAppendingString:score_xf[4]],[c stringByAppendingString:score_time[4]]],
  @[score_name[5], [a stringByAppendingString:score_score[5]],[b stringByAppendingString:score_xf[5]],[c stringByAppendingString:score_time[5]]],
  @[score_name[6], [a stringByAppendingString:score_score[6]],[b stringByAppendingString:score_xf[6]],[c stringByAppendingString:score_time[6]]],
  @[score_name[7], [a stringByAppendingString:score_score[7]],[b stringByAppendingString:score_xf[7]],[c stringByAppendingString:score_time[7]]],
  @[score_name[8], [a stringByAppendingString:score_score[8]],[b stringByAppendingString:score_xf[8]],[c stringByAppendingString:score_time[8]]],
  @[score_name[9], [a stringByAppendingString:score_score[9]],[b stringByAppendingString:score_xf[9]],[c stringByAppendingString:score_time[9]]],
  @[score_name[10], [a stringByAppendingString:score_score[10]],[b stringByAppendingString:score_xf[10]],[c stringByAppendingString:score_time[10]]],
  @[score_name[11], [a stringByAppendingString:score_score[11]],[b stringByAppendingString:score_xf[11]],[c stringByAppendingString:score_time[11]]],
  @[score_name[12], [a stringByAppendingString:score_score[12]],[b stringByAppendingString:score_xf[12]],[c stringByAppendingString:score_time[12]]],
  @[score_name[13], [a stringByAppendingString:score_score[13]],[b stringByAppendingString:score_xf[13]],[c stringByAppendingString:score_time[13]]],
  @[score_name[14], [a stringByAppendingString:score_score[14]],[b stringByAppendingString:score_xf[14]],[c stringByAppendingString:score_time[14]]],
  @[score_name[15], [a stringByAppendingString:score_score[15]],[b stringByAppendingString:score_xf[15]],[c stringByAppendingString:score_time[15]]],
  @[score_name[16], [a stringByAppendingString:score_score[16]],[b stringByAppendingString:score_xf[16]],[c stringByAppendingString:score_time[16]]],
  @[score_name[17], [a stringByAppendingString:score_score[17]],[b stringByAppendingString:score_xf[17]],[c stringByAppendingString:score_time[17]]],
  @[score_name[18], [a stringByAppendingString:score_score[18]],[b stringByAppendingString:score_xf[18]],[c stringByAppendingString:score_time[18]]],
  @[score_name[19], [a stringByAppendingString:score_score[19]],[b stringByAppendingString:score_xf[19]],[c stringByAppendingString:score_time[19]]],
  @[score_name[20], [a stringByAppendingString:score_score[20]],[b stringByAppendingString:score_xf[20]],[c stringByAppendingString:score_time[20]]],
  @[score_name[21], [a stringByAppendingString:score_score[21]],[b stringByAppendingString:score_xf[21]],[c stringByAppendingString:score_time[21]]],
  @[score_name[22], [a stringByAppendingString:score_score[22]],[b stringByAppendingString:score_xf[22]],[c stringByAppendingString:score_time[22]]],
  @[score_name[23], [a stringByAppendingString:score_score[23]],[b stringByAppendingString:score_xf[23]],[c stringByAppendingString:score_time[23]]],
  @[score_name[24], [a stringByAppendingString:score_score[24]],[b stringByAppendingString:score_xf[24]],[c stringByAppendingString:score_time[24]]],
  @[score_name[25], [a stringByAppendingString:score_score[25]],[b stringByAppendingString:score_xf[25]],[c stringByAppendingString:score_time[25]]],
  @[score_name[26], [a stringByAppendingString:score_score[26]],[b stringByAppendingString:score_xf[26]],[c stringByAppendingString:score_time[26]]],
  @[score_name[27], [a stringByAppendingString:score_score[27]],[b stringByAppendingString:score_xf[27]],[c stringByAppendingString:score_time[27]]],
  @[score_name[28], [a stringByAppendingString:score_score[28]],[b stringByAppendingString:score_xf[28]],[c stringByAppendingString:score_time[28]]],
  @[score_name[29], [a stringByAppendingString:score_score[29]],[b stringByAppendingString:score_xf[29]],[c stringByAppendingString:score_time[29]]],
  ]];
            break;
        default:
            break;
    }
        [self reloadTableViewWithData:array];
    
    [self setDataManipulationButton:UIBarButtonSystemItemUndo];
    
    NSLog(@"ViewDidLoadA");
    [self setDataManipulationButton:UIBarButtonSystemItemRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath //选择是否自动打开
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
        cell.expandable = YES;
    else
        cell.expandable = YES;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

#pragma mark - Actions

- (void)collapseSubrows
{
    [self.tableView collapseCurrentlyExpandedIndexPaths];
}

- (void)refreshData
{
    NSArray *array = @[
                       @[
                           @[@"Section0_Row0", @"Row0_Subrow1",@"Row0_Subrow2"],
                           @[@"Section0_Row1", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"],
                           @[@"Section0_Row2"]
                           ]
                       ];
    [self reloadTableViewWithData:array];
    
    [self setDataManipulationButton:UIBarButtonSystemItemUndo];
}

- (void)undoData
{
    [self reloadTableViewWithData:nil];
    
    [self setDataManipulationButton:UIBarButtonSystemItemRefresh];
}

- (void)reloadTableViewWithData:(NSArray *)array
{
    self.contents = array;
    
    // Refresh data not scrolling
    //    [self.tableView refreshData];
    
    [self.tableView refreshDataWithScrollingToIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

#pragma mark - Helpers

- (void)setDataManipulationButton:(UIBarButtonSystemItem)item
{
//    switch (item) {
//        case UIBarButtonSystemItemUndo:
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
//                                                                                                  target:self
//                                                                                                  action:@selector(undoData)];
//            break;
//            
//        default:
//            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
//                                                                                                  target:self
//                                                                                                  action:@selector(refreshData)];
//            break;
//    }
}

@end
