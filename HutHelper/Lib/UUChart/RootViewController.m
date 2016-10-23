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
    [historyBtn setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
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


-(void)showall{
    ScoreViewController *Score      = [[ScoreViewController alloc] init];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Score animated:NO];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section?2:4;
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
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:30];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    label.text = section ? @"总体成绩":@"学期成绩分布图";
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
