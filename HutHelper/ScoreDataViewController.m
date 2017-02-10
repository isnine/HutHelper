//
//  ScoreDataViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/7.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ScoreDataViewController.h"
#import "ScoreTableViewCell.h"
#import "DTKDropdownMenuView.h"
#import "Score.h"
#import "ScoreShowViewController.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Math.h"
#import "Config.h"
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]
@interface ScoreDataViewController ()
@property (nonatomic,copy) NSArray      *scoreData;
@property (nonatomic,copy)NSString *GradeString;
@end

@implementation ScoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleMenu];
    [self getScoreData];
    [self setTitleButton];
    self.tableView.dataSource = (id)self;
    self.tableView.delegate=(id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - "设置表格代理"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _scoreData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Score *score=[[Score alloc]init];
    ScoreTableViewCell *cell=[ScoreTableViewCell tableViewCell];
    cell.Class.text=[self getClass:(short)indexPath.section];
    cell.Time.text=[self getTime:(short)indexPath.section];
    cell.Xf.text=[self getJd:(short)indexPath.section];
    return cell;
}
-(void)getScoreData{
    Score *score=[[Score alloc]init];
    _scoreData=[score getScore];
}
-(void)getScoreData:(NSString*)grade{
    Score *score=[[Score alloc]init];
    _scoreData=[score getScore:grade];
}
-(NSString*)getClass:(int)num{
    NSDictionary *dict1        = _scoreData[num];
    NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
    NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
    NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
    NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记

    if ([string_name isEqual:[NSNull null]])
        string_name       = @"NULL";//名字
    
    if ([string_score isEqual:[NSNull null]])
        string_score          = @"0";//成绩
    
    if ([string_score2 isEqual:[NSNull null]])
        string_score2         = @"0";//学期
    
    if ([string_cxbj isEqual:[NSNull null]])
        string_cxbj         = @"NULL";//学期
    
    
    int int_score          = [string_score intValue];
    int int_score2          = [string_score2 intValue];
    
    if (int_score<60&&int_score<int_score2)
        int_score=int_score2;
    
    if([string_cxbj isEqualToString:@"1"]){
        string_name=[string_name stringByAppendingString:@"*"];
    }
    
    NSString *result=[NSString stringWithFormat:@"%@/%d",string_name,int_score];
    return result;
}
-(NSString*)getTime:(int)num{
    NSDictionary *dict1        = _scoreData[num];
    NSString *string_xn= [dict1 objectForKey:@"XN"];//学期
    NSString *string_xq= [dict1 objectForKey:@"XQ"];//学期
    if ([string_xn isEqual:[NSNull null]])
        string_xn         = @"NULL";//学期
    
    if ([string_xq isEqual:[NSNull null]])
        string_xq         = @"NULL";//学期
    
    string_xn         = [string_xn stringByAppendingString:@"第"];
    string_xn         = [string_xn stringByAppendingString:string_xq];
    string_xn         = [string_xn stringByAppendingString:@"学期"];
    return string_xn;
}
-(NSString*)getJd:(int)num{
    NSDictionary *dict1        = _scoreData[num];
    NSString *string_score= [dict1 objectForKey:@"ZSCJ"];//成绩
    NSString *string_score2= [dict1 objectForKey:@"BKCJ"];//成绩
    NSString *string_xf= [dict1 objectForKey:@"XF"];//学分

    if ([string_score isEqual:[NSNull null]])
        string_score          = @"0";//成绩
    

    if ([string_score2 isEqual:[NSNull null]])
        string_score2         = @"0";//学期
    
    if ([string_xf isEqual:[NSNull null]])
        string_xf         = @"0.1";//学期
    

    
    int int_score          = [string_score intValue];
    int int_score2          = [string_score2 intValue];
    double double_xf          = string_xf.doubleValue;
    if (int_score<60&&int_score<int_score2)
        int_score=int_score2;
    
    double jd=0;
    if(int_score>=60){
        jd=(int_score*1.0-50.0)/10.0;
    }
    else{
        jd=0.0;
    }
    NSString *result=[NSString stringWithFormat:@"%@/%.1lf",string_xf,jd];
    return result;
}
#pragma  mark - 标题设置
- (void)addTitleMenu
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int grade=[[defaults objectForKey:@"sourceGrade"] intValue];
    
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"所有成绩" callBack:^(NSUInteger index, id info) {
        [self getScoreData];
        [self.tableView reloadData];
    }];
    DTKDropdownItem *item11,*item12,*item21,*item22,*item31,*item32,*item41,*item42;
    DTKDropdownMenuView *menuView;
    item11 = [DTKDropdownItem itemWithTitle:@"大一上学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大一上学期"]];
        _GradeString=[Score getGradeName:@"大一上学期"];
        [self.tableView reloadData];
        
    }];
    item12 = [DTKDropdownItem itemWithTitle:@"大一下学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大一下学期"]];
        _GradeString=[Score getGradeName:@"大一下学期"];
        [self.tableView reloadData];
    }];
    item21 = [DTKDropdownItem itemWithTitle:@"大二上学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大二上学期"]];
        _GradeString=[Score getGradeName:@"大二上学期"];
        [self.tableView reloadData];
    }];
    item22 = [DTKDropdownItem itemWithTitle:@"大二下学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大二下学期"]];
        _GradeString=[Score getGradeName:@"大二下学期"];
        [self.tableView reloadData];
    }];
    item31 = [DTKDropdownItem itemWithTitle:@"大三上学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大三上学期"]];
        _GradeString=[Score getGradeName:@"大三上学期"];
        [self.tableView reloadData];
    }];
    item32 = [DTKDropdownItem itemWithTitle:@"大三下学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大三下学期"]];
        _GradeString=[Score getGradeName:@"大三下学期"];
        [self.tableView reloadData];
    }];
    item41 = [DTKDropdownItem itemWithTitle:@"大四上学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大四上学期"]];
        _GradeString=[Score getGradeName:@"大四上学期"];
        [self.tableView reloadData];
    }];
    item42 = [DTKDropdownItem itemWithTitle:@"大四下学期" callBack:^(NSUInteger index, id info) {
        [self getScoreData:[Score getGradeName:@"大四下学期"]];
        _GradeString=[Score getGradeName:@"大四下学期"];
        [self.tableView reloadData];
    }];

    
    switch (grade) {
        case 11:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11]];
            break;
        case 12:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12]];
            break;
        case 21:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21]];
            break;
        case 22:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22]];
            break;
        case 31:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31]];
            break;
        case 32:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31,item32]];
            break;
        case 41:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31,item32,item41]];
            break;
        case 42:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31,item32,item41,item42]];
            break;
    }
    menuView.currentNav = self.navigationController;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = ColorWithRGB(0.f, 0.f, 0.f);//每栏颜色
    menuView.textFont = [UIFont systemFontOfSize:13.f];
    menuView.textFont = [UIFont systemFontOfSize:14.f];
    menuView.animationDuration = 0.2f;
    menuView.selectedIndex = 0;
    menuView.cellSeparatorColor = [UIColor whiteColor];
    menuView.titleColor=ColorWithRGB(0.f, 0.f, 0.f);//标题颜色
    self.navigationItem.titleView = menuView;
    
}
-(void)setTitleButton{
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
- (void)reload{
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"Score"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *SHA_String=[user.studentKH stringByAppendingString:[defaults objectForKey:@"remember_code_app"]];
    SHA_String=[SHA_String stringByAppendingString:@"f$Z@%"];
    SHA_String=[Math sha1:SHA_String];
    NSString *Url_String=[NSString stringWithFormat:API_SCORES,user.studentKH,[defaults objectForKey:@"remember_code_app"],SHA_String];
    NSLog(@"成绩查询地址:%@",Url_String);
    /**设置5秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Score_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSData *Score_Data =    [NSJSONSerialization dataWithJSONObject:Score_All options:NSJSONWritingPrettyPrinted error:nil];
             
             NSString *Msg=[Score_All objectForKey:@"msg"];
             if([Msg isEqualToString:@"ok"]){
                 [defaults setObject:Score_Data forKey:@"Score"];
                 [defaults synchronize];
                 if(_GradeString)
                     [self getScoreData:_GradeString];
                 else
                    [self getScoreData];
                 [self.tableView reloadData];
                 HideAllHUD
                 [MBProgressHUD showSuccess:@"刷新成功"];
                 
             }
             else if([Msg isEqualToString:@"令牌错误"]){
                 HideAllHUD
                 [MBProgressHUD showError:@"登录过期,请重新登录"];
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:@"请检查网络或者重新登录"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HideAllHUD
             [MBProgressHUD showError:@"网络错误"];
         }];
}

@end
