//
//  CourseXpTableViewController.m
//  HutHelper
//
//  Created by Nine on 2017/4/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CourseXpTableViewController.h"
#import "CourseXpTableViewCell.h"
#import "CourseXp.h"
#import "MJRefresh.h"
#import "APIRequest.h"
#import "MBProgressHUD+MJ.h"
@interface CourseXpTableViewController ()

@end

@implementation CourseXpTableViewController{
    NSMutableArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实验课表";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self loadData:[Config getCourseXp]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    [self.tableView.mj_header beginRefreshing];
    //左滑手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        [Config setIs:1];
        [Config pushViewController:@"Class"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData:(NSArray*)JSONDic{
    datas=[[NSMutableArray alloc]init];
    NSMutableArray *JSONDicMutableArray=[[NSMutableArray alloc]initWithArray:JSONDic];
    NSMutableArray *JSONDicMutableArrayFinish=[[NSMutableArray alloc]initWithArray:JSONDic];
    //排序
    for (int i=0; i<JSONDicMutableArray.count; i++) {
        for (int j=i; j<JSONDicMutableArray.count; j++) {
            if ([JSONDicMutableArray[i][@"weeks_no"] intValue]*100+[JSONDicMutableArray[i][@"week"] intValue]*10>
                [JSONDicMutableArray[j][@"weeks_no"] intValue]*100+[JSONDicMutableArray[j][@"week"] intValue]*10) {
                [JSONDicMutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            
        }
    }
    //添加未完成课表
    for (NSDictionary *eachDic in JSONDicMutableArray) {
        if (!(([Math getWeek]>[eachDic[@"weeks_no"] intValue])
            ||(([Math getWeek]==[eachDic[@"weeks_no"] intValue])
               &&([Math getWeekDay]>[eachDic[@"week"] intValue])))) {
                CourseXp *courseXp=[[CourseXp alloc]initWithDic:eachDic];
                [datas addObject:courseXp];
            }
    }
    //添加已完成课表
    for (NSDictionary *eachDic in JSONDicMutableArray) {
        if (([Math getWeek]>[eachDic[@"weeks_no"] intValue])
            ||(([Math getWeek]==[eachDic[@"weeks_no"] intValue])
             &&([Math getWeekDay]>[eachDic[@"week"] intValue]))) {
                CourseXp *courseXp=[[CourseXp alloc]initWithDic:eachDic];
                [datas addObject:courseXp];
            }
    }
}
-(void)drawCell:(CourseXpTableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    cell.data=datas[indexPath.section];
    [cell draw];
}
-(void)reload{
    NSString *urlXpString=[NSString stringWithFormat:API_CLASSXP,Config.getStudentKH,Config.getRememberCodeApp];
    [APIRequest GET:urlXpString parameters:nil success:^(id responseObject) {
        NSString *msg=responseObject[@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            NSArray *arrayCourseXp= responseObject[@"data"];
            [Config saveCourseXp:arrayCourseXp];
            [Config saveWidgetCourseXp:arrayCourseXp];
            [self loadData:[Config getCourseXp]];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_header endRefreshing];
            [MBProgressHUD showError:msg];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络超时，实验课表查询失败"];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SYReal(190);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SYReal(15);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"CourseXpCell";
    CourseXpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell=[[CourseXpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    cell.userInteractionEnabled = NO;
    
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}




@end
