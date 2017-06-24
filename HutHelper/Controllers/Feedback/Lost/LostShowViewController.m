//
//  LostShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostShowViewController.h"
#import "LostShowTableViewCell.h"
#import "LostShowPhotoTableViewCell.h"
#import "LostShowTimeTableViewCell.h"
#import "AppDelegate.h"
#import "LostAddViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "XWScanImage.h"
#import "YCXMenuItem.h"
#import "YCXMenu.h"
@interface LostShowViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray      *lostData;
@property (nonatomic , strong) NSMutableArray *items;
@property  int num;
@end

@implementation LostShowViewController
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLostData];
    [self setTitle];
    if([Config getIs]==0){
       [self setRefresh];
    }else{
       self.navigationItem.title = @"我的发布";
    }
    
    _num=1;
    self.tableView.dataSource = (id)self;
   self.tableView.delegate=(id)self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - "设置表格代理"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _lostData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *photo=[_lostData[section] objectForKey:@"pics"];
    if (photo.count==0)
        return 2;
    else
        return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *photo=[_lostData[indexPath.section] objectForKey:@"pics"];
    if (indexPath.row==0) {
        return 150;
    }
    else{
        if (photo.count==0)
            return 25;
        else{
            if (indexPath.row==1){
                if (photo.count==1)
                    return 120;
                else if (photo.count==2)
                    return 120;
                else
                    return 140;}
            else
                return 25;
            
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LostShowTableViewCell *cell=[LostShowTableViewCell tableViewCell];
    LostShowPhotoTableViewCell *cellPhoto=[LostShowPhotoTableViewCell tableViewCell];
    LostShowTimeTableViewCell *cellTime=[LostShowTimeTableViewCell tableViewCell];
    NSArray *photo=[_lostData[indexPath.section] objectForKey:@"pics"];
    tableView.separatorStyle = NO;
    cellPhoto.Img11.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img11.clipsToBounds = YES;
    cellPhoto.Img21.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img21.clipsToBounds = YES;
    cellPhoto.Img22.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img22.clipsToBounds = YES;
    cellPhoto.Img41.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img41.clipsToBounds = YES;
    cellPhoto.Img42.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img42.clipsToBounds = YES;
    cellPhoto.Img43.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img43.clipsToBounds = YES;
    cellPhoto.Img44.contentMode =UIViewContentModeScaleAspectFill;
    cellPhoto.Img44.clipsToBounds = YES;
    if (indexPath.row==0){//信息
        cell.tit.text=[self getTit:(short)indexPath.section];
        cell.locate.text=[self getLocate:(short)indexPath.section];
        cell.time.text=[self getTime:(short)indexPath.section];
        cell.content.text=[self getContent:(short)indexPath.section];
        cell.phone.text=[self getPhone:(short)indexPath.section];
        return cell;
    }
    else if(indexPath.row==1){//照片
        if (photo.count==0) {
            cellTime.username.text=[self getUsername:(short)indexPath.section];
            cellTime.created_on.text=[self getCreated_on:(short)indexPath.section];
            return cellTime;
        }
        else if (photo.count==1) {
            [cellPhoto.Img11 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img11 addGestureRecognizer:tapGestureRecognizer1];
            [cellPhoto.Img11 setUserInteractionEnabled:YES];
            
        }
        else if(photo.count==2){
            [cellPhoto.Img21 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img22 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img21 addGestureRecognizer:tapGestureRecognizer1];
            [cellPhoto.Img21 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img22 addGestureRecognizer:tapGestureRecognizer2];
            [cellPhoto.Img22 setUserInteractionEnabled:YES];
        }
        else if(photo.count==3){
            [cellPhoto.Img41 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img42 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img43 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:2]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img41 addGestureRecognizer:tapGestureRecognizer1];
            [cellPhoto.Img41 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img42 addGestureRecognizer:tapGestureRecognizer2];
            [cellPhoto.Img42 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img43 addGestureRecognizer:tapGestureRecognizer3];
            [cellPhoto.Img43 setUserInteractionEnabled:YES];
        }
        else {
            [cellPhoto.Img41 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img42 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img43 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:2]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellPhoto.Img44 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:3]]
                               placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img41 addGestureRecognizer:tapGestureRecognizer1];
            [cellPhoto.Img41 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img42 addGestureRecognizer:tapGestureRecognizer2];
            [cellPhoto.Img42 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img43 addGestureRecognizer:tapGestureRecognizer3];
            [cellPhoto.Img43 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellPhoto.Img44 addGestureRecognizer:tapGestureRecognizer4];
            [cellPhoto.Img44 setUserInteractionEnabled:YES];
        }
        return cellPhoto;
    }
    else{
        cellTime.username.text=[self getUsername:(short)indexPath.section];
        cellTime.created_on.text=[self getCreated_on:(short)indexPath.section];
        return cellTime;
    }
}
-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
-(void)setTitle{
    self.navigationItem.title = @"失物招领";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
-(void)setRefresh{
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
}




-(void)reload{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

    [APIRequest GET:[Config getApiLost:_num] parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Lost"];
                     _lostData=[defaults objectForKey:@"Lost"];
                     [MBProgressHUD showSuccess:@"刷新成功"];
                     HideAllHUD
                     [self.tableView.mj_header endRefreshing];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.mj_header endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.tableView.mj_header endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             HideAllHUD
         }failure:^(NSError *error) {
             [self.tableView.mj_header endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(void)load{
    _num++;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    [APIRequest GET:[Config getApiLost:_num] parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 NSDictionary *Say_info=[Say_Data objectForKey:@"info"];
                 if (Say_content!=NULL) {
                     NSNumber *max_page=[Say_info objectForKey:@"page_max"];
                     if (_num<=[max_page intValue]) {//如果该页小于最大页数
                         [defaults setObject:Say_content forKey:@"Lost"];
                         _lostData=[defaults objectForKey:@"Lost"];
                         [MBProgressHUD showSuccess:@"刷新成功"];
                         NSString *num_string=[NSString stringWithFormat:@"第%d页",_num];
                         self.navigationItem.title = num_string;
                         HideAllHUD
                         [self.tableView.mj_footer endRefreshing];
                         self.tableView.mj_header.hidden = YES;
                         [self.tableView reloadData];}
                     else{
                         _num--;
                         [MBProgressHUD showError:@"当前已是最大页数"];
                         [self.tableView.mj_footer endRefreshing];
                         
                     }
                 }
                 else{
                     _num--;
                     [self.tableView.mj_footer endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 _num--;
                 [self.tableView.mj_footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             HideAllHUD
         }failure:^(NSError *error) {
             _num--;
             [self.tableView.mj_footer endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
#pragma mark - "数据源"
-(void)getLostData{
    /**加载数据*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _lostData=[defaults objectForKey:@"Lost"];
}
-(NSString*)getTit:(int)i{
    return [NSString stringWithFormat:@"拾到物品:%@",[_lostData[i] objectForKey:@"tit" ]];
}
-(NSString*)getLocate:(int)i{
    return [NSString stringWithFormat:@"拾到地点:%@",[_lostData[i] objectForKey:@"locate" ]];
}
-(NSString*)getContent:(int)i{
    return [_lostData[i] objectForKey:@"content" ];
}
-(NSString*)getTime:(int)i{
    return [NSString stringWithFormat:@"拾到时间:%@",[_lostData[i] objectForKey:@"time" ]];
}
-(NSString*)getCreated_on:(int)i{
    return [_lostData[i] objectForKey:@"created_on" ];
}
-(NSString*)getUsername:(int)i{
    return [_lostData[i] objectForKey:@"username" ];
}
-(NSString*)getPhone:(int)i{
    NSString *photo=[_lostData[i] objectForKey:@"phone"];
    NSString *qq=[_lostData[i] objectForKey:@"qq"];
    NSString *wechat=[_lostData[i] objectForKey:@"wechat"];
    NSString *res=@"联系方式: ";
    if (![photo isEqualToString:@""]) {
        res=[[res stringByAppendingString:@"手机:"] stringByAppendingString:photo];
    }
    if (![qq isEqualToString:@""]) {
        res=[[res stringByAppendingString:@" QQ:"] stringByAppendingString:qq];
    }
    if (![wechat isEqualToString:@""]) {
        res=[[res stringByAppendingString:@" 微信:"] stringByAppendingString:wechat];
    }
    return res;
}
-(NSString*)getPhoto:(int)i with:(int)j{
    NSArray *photo=[_lostData[i] objectForKey:@"pics"];
    NSString *Url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,photo[j]];
    NSLog(@"请求地址%@",Url);
    return Url;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"失物招领"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"失物招领"];
}


#pragma mark - 菜单
-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
//    [YCXMenu setTitleFont:[UIFont systemFontOfSize:19.0]];
    //    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
        }];
    }
    
}

- (NSMutableArray *)items {
    if (!_items) {
        
        //        // set title
        //        YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"添加失物" WithIcon:nil];
        //        menuTitle.foreColor = [UIColor whiteColor];
        //        menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"添加失物" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addLost)];
        menuTitle.foreColor = [UIColor blackColor];
        menuTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"我的发布" image:[UIImage imageNamed:@"mine"] target:self action:@selector(myLost)];
        logoutItem.foreColor = [UIColor blackColor];
        logoutItem.alignment = NSTextAlignmentCenter;
        
        //        //set item
        _items = [@[menuTitle,
                    //                    [YCXMenuItem menuItem:@"个人中心"
                    //                                    image:nil
                    //                                      tag:100
                    //                                 userInfo:@{@"title":@"Menu"}],
                    //                    [YCXMenuItem menuItem:@"ACTION 133"
                    //                                    image:nil
                    //                                      tag:101
                    //                                 userInfo:@{@"title":@"Menu"}],
                    //                    [YCXMenuItem menuItem:@"检查更新"
                    //                                    image:nil
                    //                                      tag:102
                    //                                 userInfo:@{@"title":@"Menu"}],
                   logoutItem
                    ] mutableCopy];
    }
    return _items;
}
-(void)addLost{
     [Config pushViewController:@"AddLosta"];
}
-(void)myLost{
    /**设置不缓存*/
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=Config.getApiLostUser;
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content.count!=0) {
                     [defaults setObject:Say_content forKey:@"Lost"];
                     [defaults synchronize];
                     HideAllHUD
                     [Config setIs:1];
                     [Config pushViewController:@"LostShow"];
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"您没有发布的失物"];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:[Say_All objectForKey:@"msg"]]];
             }             HideAllHUD
         }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络超时"];
             HideAllHUD
         }];
}
- (void)setItems:(NSMutableArray *)items {
    _items = items;
}
@end
