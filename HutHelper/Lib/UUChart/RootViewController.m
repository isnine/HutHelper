//
//  RootViewController.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewCell.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ScoreViewController.h"
#import<CommonCrypto/CommonDigest.h>
@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chartTableView;

@end

@implementation RootViewController
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"成绩查询";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleBordered target:self action:@selector(clickEvent)];
    self.navigationItem.rightBarButtonItem = myButton;
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //历史浏览按钮
    UIButton *historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 50, 50)];
    [rightButtonView addSubview:historyBtn];
    [historyBtn setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
#pragma mark >>>>>主页搜索按钮
    //主页搜索按钮
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"Fold"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(showall) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    //----添加按钮
    NSString *cellName = NSStringFromClass([TableViewCell class]);
    [self.chartTableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)help{
    UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"帮助"
                                                                           message:@"【红线】为上学期成绩，【绿线】为下学期成绩，【整体】为各学期成绩曲线\n【绩点】等功能下版本添加"
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                                 otherButtonTitles:@"确定", nil];
    [alertView show];
}


-(void)showall{
    ScoreViewController *Score      = [[ScoreViewController alloc] init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Score animated:NO];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class])];
    [cell configUI:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSArray *)getStudent{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"data_score"];//地址 -> 数据
    NSDictionary *Score_All     = [ScoreData objectFromJSONData];//数据 -> 字典
    NSArray *array_score             = [Score_All objectForKey:@"data"];
    return array_score;
}

-(int)get_wtg{
    NSArray *array_score             = [self getStudent];
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
        
        
        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        
        if (int_score<60&&int_score<int_score2) {
            int_score=int_score2;
        }
        
        if (int_score<60) {
            wtg++;
        }
    }
    
 
    return wtg;
}

-(double)get_zxf{
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

        int int_score          = [string_score intValue];
        int int_score2          = [string_score2 intValue];
        double double_xf          = string_xf.doubleValue;
        
            if (int_score<60&&int_score<int_score2) {
                int_score=int_score2;
            }
            zjd=zjd+(int_score*1.0-50.0)*double_xf/10.0;
            zxf=zxf+double_xf*1.0;
        
    }
    
    double z=zjd/zxf;
    return z;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:30];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
//    label.text = section ? @"总体成绩":@"学期成绩分布图";
    NSString *text= [NSString stringWithFormat:@"总绩点:%.2lf", [self get_zxf]];
    NSString *wtgtext= @"整体";;
    if ([self get_wtg]!=0) {
        wtgtext= [NSString stringWithFormat:@"未通过:%d门", [self get_wtg]];
    }

    
    if (section==0) {
        label.text = @"大一";
    }
    else if(section==1){
        label.text = @"大二";
    }
    else if(section==2){
        label.text = @"大三";
    }
    else if(section==3){
        label.text = @"大四";
    }
    else if(section==4){
        label.text = wtgtext;
    }
    else if(section==5){
        label.text = text;
    }
    
    
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
