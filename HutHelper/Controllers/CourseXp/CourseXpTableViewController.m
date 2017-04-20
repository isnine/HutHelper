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
@interface CourseXpTableViewController ()

@end

@implementation CourseXpTableViewController{
    NSMutableArray *datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实验课表";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self loadData:[Config getCourseXp]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadData:(NSArray*)JSONDic{
    datas=[[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONDic) {
        CourseXp *courseXp=[[CourseXp alloc]initWithDic:eachDic];
        [datas addObject:courseXp];
    }
    
}
-(void)drawCell:(CourseXpTableViewCell*)cell withIndexPath:(NSIndexPath*)indexPath{
    cell.data=datas[indexPath.section];
    [cell draw];
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
