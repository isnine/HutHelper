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
#import "MJRefresh.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ScoreRank.h"
#import "NSString+Common.h"

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
    
   // [self setTitleButton];
    self.tableView.dataSource = (id)self;
    self.tableView.delegate=(id)self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    [self.tableView.mj_header beginRefreshing];

    
    /**让黑线消失的方法*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
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
    return SYReal(100);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Score *score=[[Score alloc]init];
    ScoreTableViewCell *cell=[ScoreTableViewCell tableViewCell];
    cell.Class.text=[self getClassScore:(short)indexPath.section];
    cell.classNameLabel.text=[self getClassName:(short)indexPath.section];
    cell.Time.text=[self getTime:(short)indexPath.section];
    cell.Xf.text=[self getJd:(short)indexPath.section];
    cell.userInteractionEnabled=NO;
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
-(NSString*)getClassScore:(int)num{
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
    
    NSString *result=[NSString stringWithFormat:@"%d分",int_score];
    return result;
}
-(NSString*)getClassName:(int)num{
    NSDictionary *dict1        = _scoreData[num];
    NSString *string_name= [dict1 objectForKey:@"KCMC"];//名字
    NSString *string_cxbj= [dict1 objectForKey:@"CXBJ"];//重修标记
    if ([string_cxbj isEqual:[NSNull null]])
        string_cxbj         = @"NULL";//学期

    
    if([string_cxbj isEqualToString:@"1"]){
        string_name=[string_name stringByAppendingString:@"*"];
    }
    
    NSString *result=[NSString stringWithFormat:@"%@",string_name];
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
    if (int_score<60&&int_score<int_score2)
        int_score=int_score2;
    
    double jd=0;
    if(int_score>=60){
        jd=(int_score*1.0-50.0)/10.0;
    }
    else{
        jd=0.0;
    }
    NSString *result=[NSString stringWithFormat:@"学分&绩点:  %.1lf/%.1lf",[string_xf floatValue],jd];
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
    
    ScoreRank *scoreRank=[[ScoreRank alloc]initWithArray:[Config getScoreRank][@"data"]];
    switch (scoreRank.termMutableArray.count) {
        case 1:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11]];
            break;
        case 2:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12] ];
            break;
        case 3:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21] ];
            break;
        case 4:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22] ];
            break;
        case 5:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31] ];
            break;
        case 6:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31,item32] ];
            break;
        case 7:
            menuView = [DTKDropdownMenuView dropdownMenuViewForNavbarTitleViewWithFrame:CGRectMake(123.0, 0, 200.f, 44.f) dropdownItems:@[item0,item11,item12,item21,item22,item31,item32,item41] ];
            break;
        case 8:
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
    [menuView setArrow];
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
    [Config setNoSharedCache];
    NSString *urlString=Config.getApiScores;
    [APIRequest GET:urlString parameters:nil timeout:8.0 success:^(id responseObject){
        NSData *scoreData =    [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *msg=responseObject[@"msg"];
        if([msg isEqualToString:@"ok"]){
            [Config saveScore:scoreData];
            NSString *urlRankString=Config.getApiRank;
            [APIRequest GET:urlRankString parameters:nil timeout:8.0 success:^(id responseObject) {
                HideAllHUD
                if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
                    [Config saveScoreRank:responseObject];
                    if(_GradeString)
                        [self getScoreData:_GradeString];
                    else
                        [self getScoreData];
                    [self.tableView reloadData];
                  //  [MBProgressHUD showSuccess:@"刷新成功" toView:self.view];
                    [self.tableView.mj_header endRefreshing];
                }else{
                    [MBProgressHUD showError:@"排名查询错误" toView:self.view];
                    [self.tableView.mj_header endRefreshing];
                }
            } failure:^(NSError *error) {
                HideAllHUD
                [MBProgressHUD showError:@"网络超时" toView:self.view];
                [self.tableView.mj_header endRefreshing];
            }];
            
        }else if([msg isEqualToString:@"令牌错误"]){
            HideAllHUD
            [MBProgressHUD showError:@"登录过期,请重新登录" toView:self.view];
            [self.tableView.mj_header endRefreshing];
            
        }else{
            HideAllHUD
            [MBProgressHUD showError:msg toView:self.view];
            [self.tableView.mj_header endRefreshing];
            
        }
        
    }failure:^(NSError *error){
        HideAllHUD
        [MBProgressHUD showError:@"网络超时" toView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];
}

@end
