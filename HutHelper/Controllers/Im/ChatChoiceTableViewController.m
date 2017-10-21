//
//  ChatChoiceTableViewController.m
//  HutHelper
//
//  Created by nine on 2017/8/9.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ChatChoiceTableViewController.h"
#import "ChatChoiceTableViewCell.h"
#import "ChatUser.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UINavigationBar+Awesome.h"
#import "MBProgressHUD+MJ.h"
#import "ChatViewController.h"
#import "UserShowViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ChatChoiceTableViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,copy) NSMutableArray *chatChoiceArray;
@end

@implementation ChatChoiceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //搜索栏
    //MJRefresh适配iOS11
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth,SYReal(70))];
        self.searchBar.showsCancelButton=YES;
    }else{
      self.searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SYReal(370),SYReal(70))];
    }
#else
    self.searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SYReal(370),SYReal(70))];
#endif
    
    [self.searchBar setContentMode:UIViewContentModeLeft];
    self.searchBar.delegate = self;
    self.searchBar.placeholder=@"搜索对方的姓名";
    self.searchBar.tintColor=[UIColor blackColor];

    self.searchBar.barTintColor=[UIColor grayColor];
    UIBarButtonItem * searchButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = searchButton;
    //去掉背景
  //  self.searchBar.backgroundImage = [[UIImage alloc] init];
    // 设置SearchBar的颜色主题为白色
   // self.searchBar.barTintColor = [UIColor whiteColor];
    
//    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0,SYReal(5),DeviceMaxWidth,SYReal(39))];
//    self.tableView.tableHeaderView=self.headerView;
//    [self.headerView addSubview:self.searchBar];
    //空白状态
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    //标题设置
//    self.navigationItem.title=@"搜索";
    //返回箭头样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [_searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [MBProgressHUD showMessage:@"搜索中" toView:self.view];
    //收起键盘
      [_searchBar resignFirstResponder];
    NSDictionary *dic=@{
                        @"name":[searchBar text]
                        };
    [APIRequest POST:[Config getApiImStudent] parameters:dic
             success:^(id responseObject) {
                  HideAllHUD
                 NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSArray *resultArray   = [resultDictionary objectForKey:@"data"];
                 if (resultArray.count==0) {
                     [MBProgressHUD showError:@"查无此人" toView:self.view];
                 }else{
                     [self loadData:resultArray];
                     [self.tableView reloadData];
                 }
                
             }
             failure:^(NSError *error) {
                 HideAllHUD
                 [MBProgressHUD showError:@"网络错误" toView:self.view];
             }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
}
-(void)loadData:(NSArray*)JSONArray{
    _chatChoiceArray = [[NSMutableArray alloc]init];
    for (int i=0; i<JSONArray.count; i++) {
        NSDictionary *eachDic=JSONArray[i];
        ChatUser *chatUser=[[ChatUser alloc]initWithDic:eachDic];
        [self.chatChoiceArray addObject:chatUser];
    }

}
#pragma mark - tableView代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chatChoiceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SYReal(75) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    ChatUser *chatUser=_chatChoiceArray[indexPath.section];
    if ([chatUser.last_use isEqualToString:@""]) {
        [MBProgressHUD showError:@"用户未使用工大助手" toView:self.view];
//        return;
    }
    UserShowViewController *userShowViewController=[[UserShowViewController alloc]init];
    userShowViewController.name= chatUser.TrueName;
    userShowViewController.user_id=chatUser.user_id;
    userShowViewController.dep_name=chatUser.dep_name;
    userShowViewController.head_pic=chatUser.head_pic_thumb;
    [self.navigationController pushViewController:userShowViewController animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatChoiceTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatChoiceTableViewCell" owner:nil options:nil]lastObject];
    ChatUser *chatUser=_chatChoiceArray[indexPath.section];
    cell.namelabel.text=chatUser.TrueName;
    cell.classLabel.text=chatUser.class_name;
    cell.depLabel.text=chatUser.dep_name;
    if ([chatUser.head_pic_thumb isEqualToString:@""]) {
        if ([chatUser.sex isEqualToString:@"男"]) {
            cell.headImg.image=[UIImage imageNamed:@"img_user_boy"];
        }else{
            cell.headImg.image=[UIImage imageNamed:@"img_user_girl"];
        }
    }else{
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Config.getApiImg,chatUser.head_pic_thumb]]
                        placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                   if (![[NSString stringWithFormat:@"%@%@",Config.getApiImg,chatUser.head_pic_thumb] isEqualToString:Config.getApiImg]) {
                                       cell.headImg.image=[self circleImage:image];
                                   }}];
        
    }
    return cell;
}
-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width , image.size.height );
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    /**让黑线消失的方法*/
//    self.navigationController.navigationBar.shadowImage=[UIImage new];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//}
#pragma mark - 空白状态代理
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"ui_tableview_empty"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(238, 239, 240, 1);
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    // [self.tableView.mj_header beginRefreshing];
}
@end
