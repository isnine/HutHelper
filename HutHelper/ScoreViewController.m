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
#import "MBProgressHUD.h"
#import<CommonCrypto/CommonDigest.h>
@interface ScoreViewController ()
@property (nonatomic, strong) NSArray *contents;

@end

@implementation ScoreViewController

- (NSString *) SHA:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

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
                          @[@"Section0_Row2"]]
                      ];
    }
    
    return _contents;
}

- (void)reload{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"查询中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 等待框中
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
        NSString *Url_String_score=@"http://218.75.197.121:8888/api/v1/get/scores/";
        NSString *studentKH                       = [defaults objectForKey:@"studentKH"];
        Url_String_score=[Url_String_score stringByAppendingString:studentKH];
        Url_String_score=[Url_String_score stringByAppendingString:@"/"];
        Url_String_score=[Url_String_score stringByAppendingString:remember_code_app];
        Url_String_score=[Url_String_score stringByAppendingString:@"/"];
        NSString *sha_string=[studentKH stringByAppendingString:remember_code_app];
        sha_string=[sha_string stringByAppendingString:@"f$Z@%"];
        NSString *shaok=[self SHA:sha_string];
        Url_String_score=[Url_String_score stringByAppendingString:shaok];
        NSURL *url                 = [NSURL URLWithString: Url_String_score];//接口地址
        NSError *error             = nil;
        NSString *ScoreString       = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
        NSData* ScoreData           = [ScoreString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
        NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
        //存入完毕
        NSLog(@"成绩查询地址:%@",url);
        NSString *Msg=[Score_All objectForKey:@"msg"];
        if ([Msg isEqualToString:@"ok"]) {
            NSArray *array_score             = [Score_All objectForKey:@"data"];
            [defaults setObject:ScoreData forKey:@"data_score"];
            [defaults synchronize];
        }
        else{
            UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"登陆过期或网络异常"
                                                                                   message:@"请点击切换用户,重新登录"
                                                                                  delegate:self
                                                                         cancelButtonTitle:@"取消"
                                                                         otherButtonTitles:@"确定", nil];
            [alertView show];
            NSLog(@"%@",Url_String_score);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.SKSTableViewDelegate = self;
    self.navigationItem.title = @"成绩查询";
    //右侧按钮
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //历史浏览按钮
    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 50, 50)];
    [rightButtonView addSubview:historyBtn];
    [historyBtn setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
   #pragma mark >>>>>主页搜索按钮
    //主页搜索按钮
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"Fold"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(collapseSubrows) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    //----添加按钮
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"data_score"];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];
    
    NSMutableArray *score_name=[NSMutableArray arrayWithCapacity:230];
    NSMutableArray *score_score=[NSMutableArray arrayWithCapacity:230];
    NSMutableArray *score_xf=[NSMutableArray arrayWithCapacity:230];
    NSMutableArray *score_time=[NSMutableArray arrayWithCapacity:230];
    int i=0;
    NSLog(@"%d",array_score.count);
    NSLog(@"总共课程数目:%d",array_score.count);

    for(i=0;i<array_score.count;i++){
        NSDictionary *dict1        = array_score[i];
        NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
        NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
        NSString *string_xf = [dict1 objectForKey:@"XF"];//学分
        NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
        NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
        
        
        
        
 if ([string_name isEqual:[NSNull null]]) {
       string_name       = @"NULL";//名字
        }
  if ([string_score isEqual:[NSNull null]]) {
        string_score          = @"NULL";//成绩
        }       
  if ([string_xf isEqual:[NSNull null]]) {
        string_xf         = @"NULL";//学分
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
        
        [score_name addObject:string_name];
        [score_score addObject:string_score];
        [score_xf addObject:string_xf];
        [score_time addObject:string_xn];
     
    }
    
    for(i=array_score.count;i<120;i++){
                  [score_name addObject:@""];
        [score_score addObject:@""];
        [score_xf addObject:@""];
        [score_time addObject:@""];
    }


    NSString *a=@"分数:";
    NSString *b=@"学分:";
    NSString *c=@"学期:";
    
    NSArray *array;
    
    switch (array_score.count) {
        case 0:
            array = @[@[
                          @[@"暂时没有你的考试成绩", @"成绩:",@"学分:",@"学期:"],
                          ]];
            break;
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
        case 31:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  ]];
            break;
        case 32:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  ]];
            break;
        case 33:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  ]];
            break;
        case 34:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  ]];
            break;
        case 35:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  ]];
            break;
        case 36:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  @[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
  ]];
            break;
        case 37:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  @[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
  @[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
  ]];
            break;
        case 38:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  @[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
  @[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
  @[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
  ]];
            break;
        case 39:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  @[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
  @[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
  @[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
  @[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
  ]];
            break;
        case 40:
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
  @[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
  @[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
  @[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
  @[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
  @[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
  @[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
  @[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
  @[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
  @[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
  @[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
  ]];
            break;
case 41:

case 42:
 
case 43:

case 44:

case 45:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
]];
break;
case 46:
 
case 47:
 
case 48:
 
case 49:

case 50:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
]];
break;
case 51:
 
case 52:
 
case 53:
 
case 54:
 
case 55:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
]];
break;
case 56:
 
case 57:

case 58:
 
case 59:
 
case 60:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
]];
break;
case 61:
 
case 62:
 
case 63:

case 64:
 
case 65:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
@[score_name[60], [a stringByAppendingString:score_score[60]],[b stringByAppendingString:score_xf[60]],[c stringByAppendingString:score_time[60]]],
@[score_name[61], [a stringByAppendingString:score_score[61]],[b stringByAppendingString:score_xf[61]],[c stringByAppendingString:score_time[61]]],
@[score_name[62], [a stringByAppendingString:score_score[62]],[b stringByAppendingString:score_xf[62]],[c stringByAppendingString:score_time[62]]],
@[score_name[63], [a stringByAppendingString:score_score[63]],[b stringByAppendingString:score_xf[63]],[c stringByAppendingString:score_time[63]]],
@[score_name[64], [a stringByAppendingString:score_score[64]],[b stringByAppendingString:score_xf[64]],[c stringByAppendingString:score_time[64]]],
]];
break;
case 66:

case 67:
 
case 68:

case 69:
 
case 70:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
@[score_name[60], [a stringByAppendingString:score_score[60]],[b stringByAppendingString:score_xf[60]],[c stringByAppendingString:score_time[60]]],
@[score_name[61], [a stringByAppendingString:score_score[61]],[b stringByAppendingString:score_xf[61]],[c stringByAppendingString:score_time[61]]],
@[score_name[62], [a stringByAppendingString:score_score[62]],[b stringByAppendingString:score_xf[62]],[c stringByAppendingString:score_time[62]]],
@[score_name[63], [a stringByAppendingString:score_score[63]],[b stringByAppendingString:score_xf[63]],[c stringByAppendingString:score_time[63]]],
@[score_name[64], [a stringByAppendingString:score_score[64]],[b stringByAppendingString:score_xf[64]],[c stringByAppendingString:score_time[64]]],
@[score_name[65], [a stringByAppendingString:score_score[65]],[b stringByAppendingString:score_xf[65]],[c stringByAppendingString:score_time[65]]],
@[score_name[66], [a stringByAppendingString:score_score[66]],[b stringByAppendingString:score_xf[66]],[c stringByAppendingString:score_time[66]]],
@[score_name[67], [a stringByAppendingString:score_score[67]],[b stringByAppendingString:score_xf[67]],[c stringByAppendingString:score_time[67]]],
@[score_name[68], [a stringByAppendingString:score_score[68]],[b stringByAppendingString:score_xf[68]],[c stringByAppendingString:score_time[68]]],
@[score_name[69], [a stringByAppendingString:score_score[69]],[b stringByAppendingString:score_xf[69]],[c stringByAppendingString:score_time[69]]],
]];
break;
case 71:
 
case 72:
 
case 73:
 
case 74:
 
case 75:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
@[score_name[60], [a stringByAppendingString:score_score[60]],[b stringByAppendingString:score_xf[60]],[c stringByAppendingString:score_time[60]]],
@[score_name[61], [a stringByAppendingString:score_score[61]],[b stringByAppendingString:score_xf[61]],[c stringByAppendingString:score_time[61]]],
@[score_name[62], [a stringByAppendingString:score_score[62]],[b stringByAppendingString:score_xf[62]],[c stringByAppendingString:score_time[62]]],
@[score_name[63], [a stringByAppendingString:score_score[63]],[b stringByAppendingString:score_xf[63]],[c stringByAppendingString:score_time[63]]],
@[score_name[64], [a stringByAppendingString:score_score[64]],[b stringByAppendingString:score_xf[64]],[c stringByAppendingString:score_time[64]]],
@[score_name[65], [a stringByAppendingString:score_score[65]],[b stringByAppendingString:score_xf[65]],[c stringByAppendingString:score_time[65]]],
@[score_name[66], [a stringByAppendingString:score_score[66]],[b stringByAppendingString:score_xf[66]],[c stringByAppendingString:score_time[66]]],
@[score_name[67], [a stringByAppendingString:score_score[67]],[b stringByAppendingString:score_xf[67]],[c stringByAppendingString:score_time[67]]],
@[score_name[68], [a stringByAppendingString:score_score[68]],[b stringByAppendingString:score_xf[68]],[c stringByAppendingString:score_time[68]]],
@[score_name[69], [a stringByAppendingString:score_score[69]],[b stringByAppendingString:score_xf[69]],[c stringByAppendingString:score_time[69]]],
@[score_name[70], [a stringByAppendingString:score_score[70]],[b stringByAppendingString:score_xf[70]],[c stringByAppendingString:score_time[70]]],
@[score_name[71], [a stringByAppendingString:score_score[71]],[b stringByAppendingString:score_xf[71]],[c stringByAppendingString:score_time[71]]],
@[score_name[72], [a stringByAppendingString:score_score[72]],[b stringByAppendingString:score_xf[72]],[c stringByAppendingString:score_time[72]]],
@[score_name[73], [a stringByAppendingString:score_score[73]],[b stringByAppendingString:score_xf[73]],[c stringByAppendingString:score_time[73]]],
@[score_name[74], [a stringByAppendingString:score_score[74]],[b stringByAppendingString:score_xf[74]],[c stringByAppendingString:score_time[74]]],
]];
break; 
case 76:
 
case 77:
 
case 78:

case 79:

case 80:

case 81:
 
case 82:

case 83:

case 84:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
@[score_name[60], [a stringByAppendingString:score_score[60]],[b stringByAppendingString:score_xf[60]],[c stringByAppendingString:score_time[60]]],
@[score_name[61], [a stringByAppendingString:score_score[61]],[b stringByAppendingString:score_xf[61]],[c stringByAppendingString:score_time[61]]],
@[score_name[62], [a stringByAppendingString:score_score[62]],[b stringByAppendingString:score_xf[62]],[c stringByAppendingString:score_time[62]]],
@[score_name[63], [a stringByAppendingString:score_score[63]],[b stringByAppendingString:score_xf[63]],[c stringByAppendingString:score_time[63]]],
@[score_name[64], [a stringByAppendingString:score_score[64]],[b stringByAppendingString:score_xf[64]],[c stringByAppendingString:score_time[64]]],
@[score_name[65], [a stringByAppendingString:score_score[65]],[b stringByAppendingString:score_xf[65]],[c stringByAppendingString:score_time[65]]],
@[score_name[66], [a stringByAppendingString:score_score[66]],[b stringByAppendingString:score_xf[66]],[c stringByAppendingString:score_time[66]]],
@[score_name[67], [a stringByAppendingString:score_score[67]],[b stringByAppendingString:score_xf[67]],[c stringByAppendingString:score_time[67]]],
@[score_name[68], [a stringByAppendingString:score_score[68]],[b stringByAppendingString:score_xf[68]],[c stringByAppendingString:score_time[68]]],
@[score_name[69], [a stringByAppendingString:score_score[69]],[b stringByAppendingString:score_xf[69]],[c stringByAppendingString:score_time[69]]],
@[score_name[70], [a stringByAppendingString:score_score[70]],[b stringByAppendingString:score_xf[70]],[c stringByAppendingString:score_time[70]]],
@[score_name[71], [a stringByAppendingString:score_score[71]],[b stringByAppendingString:score_xf[71]],[c stringByAppendingString:score_time[71]]],
@[score_name[72], [a stringByAppendingString:score_score[72]],[b stringByAppendingString:score_xf[72]],[c stringByAppendingString:score_time[72]]],
@[score_name[73], [a stringByAppendingString:score_score[73]],[b stringByAppendingString:score_xf[73]],[c stringByAppendingString:score_time[73]]],
@[score_name[74], [a stringByAppendingString:score_score[74]],[b stringByAppendingString:score_xf[74]],[c stringByAppendingString:score_time[74]]],
@[score_name[75], [a stringByAppendingString:score_score[75]],[b stringByAppendingString:score_xf[75]],[c stringByAppendingString:score_time[75]]],
@[score_name[76], [a stringByAppendingString:score_score[76]],[b stringByAppendingString:score_xf[76]],[c stringByAppendingString:score_time[76]]],
@[score_name[77], [a stringByAppendingString:score_score[77]],[b stringByAppendingString:score_xf[77]],[c stringByAppendingString:score_time[77]]],
@[score_name[78], [a stringByAppendingString:score_score[78]],[b stringByAppendingString:score_xf[78]],[c stringByAppendingString:score_time[78]]],
@[score_name[79], [a stringByAppendingString:score_score[79]],[b stringByAppendingString:score_xf[79]],[c stringByAppendingString:score_time[79]]],
@[score_name[80], [a stringByAppendingString:score_score[80]],[b stringByAppendingString:score_xf[80]],[c stringByAppendingString:score_time[80]]],
@[score_name[81], [a stringByAppendingString:score_score[81]],[b stringByAppendingString:score_xf[81]],[c stringByAppendingString:score_time[81]]],
@[score_name[82], [a stringByAppendingString:score_score[82]],[b stringByAppendingString:score_xf[82]],[c stringByAppendingString:score_time[82]]],
@[score_name[83], [a stringByAppendingString:score_score[83]],[b stringByAppendingString:score_xf[83]],[c stringByAppendingString:score_time[83]]],
]];
break; 
case 85:
 
case 86:
 
case 87:
 
case 88:
 
case 89:

default:
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
@[score_name[30], [a stringByAppendingString:score_score[30]],[b stringByAppendingString:score_xf[30]],[c stringByAppendingString:score_time[30]]],
@[score_name[31], [a stringByAppendingString:score_score[31]],[b stringByAppendingString:score_xf[31]],[c stringByAppendingString:score_time[31]]],
@[score_name[32], [a stringByAppendingString:score_score[32]],[b stringByAppendingString:score_xf[32]],[c stringByAppendingString:score_time[32]]],
@[score_name[33], [a stringByAppendingString:score_score[33]],[b stringByAppendingString:score_xf[33]],[c stringByAppendingString:score_time[33]]],
@[score_name[34], [a stringByAppendingString:score_score[34]],[b stringByAppendingString:score_xf[34]],[c stringByAppendingString:score_time[34]]],
@[score_name[35], [a stringByAppendingString:score_score[35]],[b stringByAppendingString:score_xf[35]],[c stringByAppendingString:score_time[35]]],
@[score_name[36], [a stringByAppendingString:score_score[36]],[b stringByAppendingString:score_xf[36]],[c stringByAppendingString:score_time[36]]],
@[score_name[37], [a stringByAppendingString:score_score[37]],[b stringByAppendingString:score_xf[37]],[c stringByAppendingString:score_time[37]]],
@[score_name[38], [a stringByAppendingString:score_score[38]],[b stringByAppendingString:score_xf[38]],[c stringByAppendingString:score_time[38]]],
@[score_name[39], [a stringByAppendingString:score_score[39]],[b stringByAppendingString:score_xf[39]],[c stringByAppendingString:score_time[39]]],
@[score_name[40], [a stringByAppendingString:score_score[40]],[b stringByAppendingString:score_xf[40]],[c stringByAppendingString:score_time[40]]],
@[score_name[41], [a stringByAppendingString:score_score[41]],[b stringByAppendingString:score_xf[41]],[c stringByAppendingString:score_time[41]]],
@[score_name[42], [a stringByAppendingString:score_score[42]],[b stringByAppendingString:score_xf[42]],[c stringByAppendingString:score_time[42]]],
@[score_name[43], [a stringByAppendingString:score_score[43]],[b stringByAppendingString:score_xf[43]],[c stringByAppendingString:score_time[43]]],
@[score_name[44], [a stringByAppendingString:score_score[44]],[b stringByAppendingString:score_xf[44]],[c stringByAppendingString:score_time[44]]],
@[score_name[45], [a stringByAppendingString:score_score[45]],[b stringByAppendingString:score_xf[45]],[c stringByAppendingString:score_time[45]]],
@[score_name[46], [a stringByAppendingString:score_score[46]],[b stringByAppendingString:score_xf[46]],[c stringByAppendingString:score_time[46]]],
@[score_name[47], [a stringByAppendingString:score_score[47]],[b stringByAppendingString:score_xf[47]],[c stringByAppendingString:score_time[47]]],
@[score_name[48], [a stringByAppendingString:score_score[48]],[b stringByAppendingString:score_xf[48]],[c stringByAppendingString:score_time[48]]],
@[score_name[49], [a stringByAppendingString:score_score[49]],[b stringByAppendingString:score_xf[49]],[c stringByAppendingString:score_time[49]]],
@[score_name[50], [a stringByAppendingString:score_score[50]],[b stringByAppendingString:score_xf[50]],[c stringByAppendingString:score_time[50]]],
@[score_name[51], [a stringByAppendingString:score_score[51]],[b stringByAppendingString:score_xf[51]],[c stringByAppendingString:score_time[51]]],
@[score_name[52], [a stringByAppendingString:score_score[52]],[b stringByAppendingString:score_xf[52]],[c stringByAppendingString:score_time[52]]],
@[score_name[53], [a stringByAppendingString:score_score[53]],[b stringByAppendingString:score_xf[53]],[c stringByAppendingString:score_time[53]]],
@[score_name[54], [a stringByAppendingString:score_score[54]],[b stringByAppendingString:score_xf[54]],[c stringByAppendingString:score_time[54]]],
@[score_name[55], [a stringByAppendingString:score_score[55]],[b stringByAppendingString:score_xf[55]],[c stringByAppendingString:score_time[55]]],
@[score_name[56], [a stringByAppendingString:score_score[56]],[b stringByAppendingString:score_xf[56]],[c stringByAppendingString:score_time[56]]],
@[score_name[57], [a stringByAppendingString:score_score[57]],[b stringByAppendingString:score_xf[57]],[c stringByAppendingString:score_time[57]]],
@[score_name[58], [a stringByAppendingString:score_score[58]],[b stringByAppendingString:score_xf[58]],[c stringByAppendingString:score_time[58]]],
@[score_name[59], [a stringByAppendingString:score_score[59]],[b stringByAppendingString:score_xf[59]],[c stringByAppendingString:score_time[59]]],
@[score_name[60], [a stringByAppendingString:score_score[60]],[b stringByAppendingString:score_xf[60]],[c stringByAppendingString:score_time[60]]],
@[score_name[61], [a stringByAppendingString:score_score[61]],[b stringByAppendingString:score_xf[61]],[c stringByAppendingString:score_time[61]]],
@[score_name[62], [a stringByAppendingString:score_score[62]],[b stringByAppendingString:score_xf[62]],[c stringByAppendingString:score_time[62]]],
@[score_name[63], [a stringByAppendingString:score_score[63]],[b stringByAppendingString:score_xf[63]],[c stringByAppendingString:score_time[63]]],
@[score_name[64], [a stringByAppendingString:score_score[64]],[b stringByAppendingString:score_xf[64]],[c stringByAppendingString:score_time[64]]],
@[score_name[65], [a stringByAppendingString:score_score[65]],[b stringByAppendingString:score_xf[65]],[c stringByAppendingString:score_time[65]]],
@[score_name[66], [a stringByAppendingString:score_score[66]],[b stringByAppendingString:score_xf[66]],[c stringByAppendingString:score_time[66]]],
@[score_name[67], [a stringByAppendingString:score_score[67]],[b stringByAppendingString:score_xf[67]],[c stringByAppendingString:score_time[67]]],
@[score_name[68], [a stringByAppendingString:score_score[68]],[b stringByAppendingString:score_xf[68]],[c stringByAppendingString:score_time[68]]],
@[score_name[69], [a stringByAppendingString:score_score[69]],[b stringByAppendingString:score_xf[69]],[c stringByAppendingString:score_time[69]]],
@[score_name[70], [a stringByAppendingString:score_score[70]],[b stringByAppendingString:score_xf[70]],[c stringByAppendingString:score_time[70]]],
@[score_name[71], [a stringByAppendingString:score_score[71]],[b stringByAppendingString:score_xf[71]],[c stringByAppendingString:score_time[71]]],
@[score_name[72], [a stringByAppendingString:score_score[72]],[b stringByAppendingString:score_xf[72]],[c stringByAppendingString:score_time[72]]],
@[score_name[73], [a stringByAppendingString:score_score[73]],[b stringByAppendingString:score_xf[73]],[c stringByAppendingString:score_time[73]]],
@[score_name[74], [a stringByAppendingString:score_score[74]],[b stringByAppendingString:score_xf[74]],[c stringByAppendingString:score_time[74]]],
@[score_name[75], [a stringByAppendingString:score_score[75]],[b stringByAppendingString:score_xf[75]],[c stringByAppendingString:score_time[75]]],
@[score_name[76], [a stringByAppendingString:score_score[76]],[b stringByAppendingString:score_xf[76]],[c stringByAppendingString:score_time[76]]],
@[score_name[77], [a stringByAppendingString:score_score[77]],[b stringByAppendingString:score_xf[77]],[c stringByAppendingString:score_time[77]]],
@[score_name[78], [a stringByAppendingString:score_score[78]],[b stringByAppendingString:score_xf[78]],[c stringByAppendingString:score_time[78]]],
@[score_name[79], [a stringByAppendingString:score_score[79]],[b stringByAppendingString:score_xf[79]],[c stringByAppendingString:score_time[79]]],
@[score_name[80], [a stringByAppendingString:score_score[80]],[b stringByAppendingString:score_xf[80]],[c stringByAppendingString:score_time[80]]],
@[score_name[81], [a stringByAppendingString:score_score[81]],[b stringByAppendingString:score_xf[81]],[c stringByAppendingString:score_time[81]]],
@[score_name[82], [a stringByAppendingString:score_score[82]],[b stringByAppendingString:score_xf[82]],[c stringByAppendingString:score_time[82]]],
@[score_name[83], [a stringByAppendingString:score_score[83]],[b stringByAppendingString:score_xf[83]],[c stringByAppendingString:score_time[83]]],
@[score_name[84], [a stringByAppendingString:score_score[84]],[b stringByAppendingString:score_xf[84]],[c stringByAppendingString:score_time[84]]],
@[score_name[85], [a stringByAppendingString:score_score[85]],[b stringByAppendingString:score_xf[85]],[c stringByAppendingString:score_time[85]]],
@[score_name[86], [a stringByAppendingString:score_score[86]],[b stringByAppendingString:score_xf[86]],[c stringByAppendingString:score_time[86]]],
@[score_name[87], [a stringByAppendingString:score_score[87]],[b stringByAppendingString:score_xf[87]],[c stringByAppendingString:score_time[87]]],
@[score_name[88], [a stringByAppendingString:score_score[88]],[b stringByAppendingString:score_xf[88]],[c stringByAppendingString:score_time[88]]],
@[score_name[89], [a stringByAppendingString:score_score[89]],[b stringByAppendingString:score_xf[89]],[c stringByAppendingString:score_time[89]]],
@[score_name[90], [a stringByAppendingString:score_score[90]],[b stringByAppendingString:score_xf[90]],[c stringByAppendingString:score_time[90]]],
@[score_name[91], [a stringByAppendingString:score_score[91]],[b stringByAppendingString:score_xf[91]],[c stringByAppendingString:score_time[91]]],
@[score_name[92], [a stringByAppendingString:score_score[92]],[b stringByAppendingString:score_xf[92]],[c stringByAppendingString:score_time[92]]],
@[score_name[93], [a stringByAppendingString:score_score[93]],[b stringByAppendingString:score_xf[93]],[c stringByAppendingString:score_time[93]]],
@[score_name[94], [a stringByAppendingString:score_score[94]],[b stringByAppendingString:score_xf[94]],[c stringByAppendingString:score_time[94]]],
@[score_name[95], [a stringByAppendingString:score_score[95]],[b stringByAppendingString:score_xf[95]],[c stringByAppendingString:score_time[95]]],
@[score_name[96], [a stringByAppendingString:score_score[96]],[b stringByAppendingString:score_xf[96]],[c stringByAppendingString:score_time[96]]],
@[score_name[97], [a stringByAppendingString:score_score[97]],[b stringByAppendingString:score_xf[97]],[c stringByAppendingString:score_time[97]]],
@[score_name[98], [a stringByAppendingString:score_score[98]],[b stringByAppendingString:score_xf[98]],[c stringByAppendingString:score_time[98]]],
@[score_name[99], [a stringByAppendingString:score_score[99]],[b stringByAppendingString:score_xf[99]],[c stringByAppendingString:score_time[99]]],
]];
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
