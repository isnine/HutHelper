//
//  SayViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "SayViewController.h"
#import "SayViewCell.h"
#import "SayCommitViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "CommitViewCell.h"
#import "PhotoViewCell.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"
#import "UUInputAccessoryView.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "AddSayViewController.h"
#import "XWScanImage.h"
#import "Config.h"

#import "YCXMenu.h"
@interface SayViewController ()
@property (nonatomic,copy) NSArray      *Say_content;
@property (nonatomic , strong) NSMutableArray *items;
@end

@implementation SayViewController
@synthesize items = _items;
int num=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    num=1;
    self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    /**加载数据*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _Say_content=[defaults objectForKey:@"Say"];
    /**下拉刷新*/
    if([Config getIs]==0){
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
        /**按钮*/
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }else{
        if([self getName:0]){
            self.navigationItem.title = [NSString stringWithFormat:@"%@的说说",[self getName:0]];
        }
    }
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - "设置表格代理"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{  //多少块
    
    return _Say_content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//每块几部分
    NSArray *photo=[_Say_content[section] objectForKey:@"pics"];
    if (photo.count==0)
        return [self getcommitcount:(short)section]+2;
    else
        return [self getcommitcount:(short)section]+3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
    NSArray *photo=[_Say_content[indexPath.section] objectForKey:@"pics"];
    if (indexPath.row==0){
        int height=[self GetStringHeight:[self getContent:(short)indexPath.section]];
        if([[self getContent:(short)indexPath.section] rangeOfString:@"\n"].location !=NSNotFound)
            return 120;
        if (height<120)  return 85;
        else if(height>=120&&height<300) return 90;
        else if(height>=300&&height<500) return 100;
        else  return 120;
    }
    else if (indexPath.row==1){
        if (photo.count==0)  return 45;//评论数
        else if (photo.count==1)  return 130;//图片
        else if (photo.count==2)  return 170;//图片
        else                      return 250;//图片
    }
    else if (indexPath.row==2){
        if (photo.count==0)  return 55;//留言
        else                 return 45;//评论数
    }
    else
        return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //当离开某行时，让某行的选中状态消失
    NSArray *photo=[_Say_content[indexPath.section] objectForKey:@"pics"];
    if(indexPath.row==0){
        [self showSay:[_Say_content[indexPath.section] objectForKey:@"user_id"]];
    }
    if ((indexPath.row==1&&photo.count==0)||(indexPath.row==2&&photo.count!=0)) {
        
        /**拼接地址*/
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *User_Data=[defaults objectForKey:@"User"];
        User *user=[User yy_modelWithJSON:User_Data];
        NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_CREATE_COMMENT,user.studentKH,[defaults objectForKey:@"remember_code_app"],[self getsayid:indexPath.section]];
        [UUInputAccessoryView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {
            configer.keyboardType = UIKeyboardTypeDefault;
            configer.content = @"";
            configer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }block:^(NSString * _Nonnull contentStr) {
            // code
            if (contentStr.length == 0) return ;
            // NSLog(@"%@",contentStr);
            // 1.创建AFN管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 4.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            // 2.利用AFN管理者发送请求
            NSDictionary *params = @{
                                     @"comment" : contentStr
                                     };
            NSLog(@"评论请求地址%@",Url_String);
            [MBProgressHUD showMessage:@"发表中" toView:self.view];
            [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
                NSString *Msg=[response objectForKey:@"msg"];
                if ([Msg isEqualToString:@"ok"])   {
                    HideAllHUD
                    [MBProgressHUD showSuccess:@"评论成功"];
                    [self reload];
                }
                else if ([Msg isEqualToString:@"令牌错误"]){
                    HideAllHUD
                    [MBProgressHUD showError:@"登录过期，请重新登录"];}
                else{
                    HideAllHUD
                    [MBProgressHUD showError:Msg];}
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                HideAllHUD
                [MBProgressHUD showError:@"网络错误"];
            }];
            
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SayViewCell *cell = [SayViewCell tableViewCell];
    SayCommitViewCell *cellcommit = [SayCommitViewCell tableViewCell];
    CommitViewCell *cellshowcommit=[CommitViewCell tableViewCell];
    PhotoViewCell *cellphoto=[PhotoViewCell tableViewCell];
    tableView.separatorStyle = NO;
    int exis=2;
    NSArray *photo=[_Say_content[indexPath.section] objectForKey:@"pics"];
    
    /**得到评论数组*/
    if (indexPath.row == 0)
    {
        cell.username.text=[self getName:(short)indexPath.section];
        cell.created_on.text=[self getTime:(short)indexPath.section];
        cell.content.text=[self getContent:(short)indexPath.section];
        
        cell.img.image = [self getImg:(short)indexPath.section];
        return cell;
    }
    else if (indexPath.row==1) {
        if (photo.count==0) {
            cellshowcommit.commitsize.text=[NSString stringWithFormat:@"%d",[self getcommitcount:(short)indexPath.section]];
            cellshowcommit.delectButton.hidden=![self isShowDelect:(short)indexPath.section];
            cellshowcommit.dep_name.text=[NSString stringWithFormat:@"%@",[self getDepName:(short)indexPath.section]];
            return cellshowcommit;
        }
        else if(photo.count==1){
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            //为UIImageView1添加点击事件
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img1 addGestureRecognizer:tapGestureRecognizer1];
            //让UIImageView和它的父类开启用户交互属性
            [cellphoto.Img1 setUserInteractionEnabled:YES];
            
            return cellphoto;
        }
        else if(photo.count==2){
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img1 addGestureRecognizer:tapGestureRecognizer1];
            [cellphoto.Img1 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img2 addGestureRecognizer:tapGestureRecognizer2];
            [cellphoto.Img2 setUserInteractionEnabled:YES];
            return cellphoto;
        }
        else if(photo.count==3){
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img3 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:2]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img1 addGestureRecognizer:tapGestureRecognizer1];
            [cellphoto.Img1 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img2 addGestureRecognizer:tapGestureRecognizer2];
            [cellphoto.Img2 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img3 addGestureRecognizer:tapGestureRecognizer3];
            [cellphoto.Img3 setUserInteractionEnabled:YES];
            return cellphoto;
        }
        else {
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img3 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:2]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img4 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:3]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img1 addGestureRecognizer:tapGestureRecognizer1];
            [cellphoto.Img1 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img2 addGestureRecognizer:tapGestureRecognizer2];
            [cellphoto.Img2 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img3 addGestureRecognizer:tapGestureRecognizer3];
            [cellphoto.Img3 setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
            [cellphoto.Img4 addGestureRecognizer:tapGestureRecognizer4];
            [cellphoto.Img4 setUserInteractionEnabled:YES];
            return cellphoto;
        }
        
        
    }
    else if (indexPath.row == 2) {
        if (photo.count==0) {
            cellcommit.CommitName.text=[self getcommitname:(short)indexPath.section with:(short)indexPath.row-exis];
            cellcommit.CommitContent.text=[self getcommitcontent:(short)indexPath.section with:(short)indexPath.row-exis];
            cellcommit.CommitTime.text=[self getcommittime:(short)indexPath.section with:(short)indexPath.row-exis];
            cellcommit.delectButton.hidden=![self isShowCommitDelect:(short)indexPath.section with:(short)indexPath.row-exis];
            return cellcommit;
        }
        else{
            cellshowcommit.commitsize.text=[NSString stringWithFormat:@"%d",[self getcommitcount:(short)indexPath.section]];
            cellshowcommit.delectButton.hidden=![self isShowDelect:(short)indexPath.section];
            cellshowcommit.dep_name.text=[NSString stringWithFormat:@"%@",[self getDepName:(short)indexPath.section]];
            return cellshowcommit;
        }
        
    }
    else{
        if(photo.count!=0){
            exis=3;}
        cellcommit.CommitName.text=[self getcommitname:(short)indexPath.section with:(short)indexPath.row-exis];
        cellcommit.CommitContent.text=[self getcommitcontent:(short)indexPath.section with:(short)indexPath.row-exis];
        cellcommit.delectButton.hidden=![self isShowCommitDelect:(short)indexPath.section with:(short)indexPath.row-exis];
        cellcommit.CommitTime.text=[self getcommittime:(short)indexPath.section with:(short)indexPath.row-exis];
        return cellcommit;
        
    }
}

-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
#pragma mark - "其他"
-(void)addSay{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddSayViewController *addsayViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddSay"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:addsayViewController animated:NO];
}
-(void)mySay{
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_USER,user.user_id];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content.count!=0) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     [defaults synchronize];
                     HideAllHUD
                     [Config setIs:1];
                     SayViewController *Say      = [[SayViewController alloc] init];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                     
                 }else{
                     HideAllHUD
                     [MBProgressHUD showError:@"您没有发布的说说"];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络超时"];
             HideAllHUD
         }];
}
-(void)showSay:(NSString*)username{
    if ([Config getIs]==0) {
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                                diskCapacity:0
                                                                    diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        /**拼接地址*/
        NSDictionary *User_Data=[defaults objectForKey:@"User"];
        User *user=[User yy_modelWithJSON:User_Data];
        NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_USER,username];
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                     NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                     NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                     if (Say_content.count!=0) {
                         [defaults setObject:Say_content forKey:@"Say"];
                         [defaults synchronize];
                         HideAllHUD
                         [Config setIs:1];
                         SayViewController *Say      = [[SayViewController alloc] init];
                         AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                         
                     }else{
                         HideAllHUD
                         //[MBProgressHUD showError:@"数据错误"];
                     }
                 }
                 else{
                     HideAllHUD
                     // [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
                 }
                 HideAllHUD
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
                 HideAllHUD
             }];
    }
    
}


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
        //        YCXMenuItem *firstTitle = [YCXMenuItem firstTitle:@"添加失物" WithIcon:nil];
        //        firstTitle.foreColor = [UIColor whiteColor];
        //        firstTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        YCXMenuItem *firstTitle = [YCXMenuItem menuItem:@"添加说说" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addSay)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *SecondTitle = [YCXMenuItem menuItem:@"我的说说" image:[UIImage imageNamed:@"mine"] target:self action:@selector(mySay)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        
        //        //set item
        _items = [@[firstTitle,
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
                    SecondTitle
                    ] mutableCopy];
    }
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

-(void)load:(int)num{
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,num];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 9.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSDictionary *Say_info=[Say_Data objectForKey:@"info"];
                 NSNumber *max_page=[Say_info objectForKey:@"page_max"];
                 if (num<[max_page intValue]) //如果该页小于最大页数
                     _Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 else
                     [MBProgressHUD showError:@"页数错误"];
             }
             else
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             
             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HideAllHUD
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(Boolean)isShowDelect:(int)i{
    NSString *sayId=[_Say_content[i] objectForKey:@"user_id"];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    
    User *user=[User yy_modelWithJSON:User_Data];
    
    if ([sayId isEqualToString:user.user_id])
        return  true;
    else
        return false;
}
-(Boolean)isShowCommitDelect:(int)i with:(int)j{
    NSArray *Commit=[_Say_content[i] objectForKey:@"comments"];
    NSString *commitId=[Commit[j] objectForKey:@"user_id"];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    
    User *user=[User yy_modelWithJSON:User_Data];
    if ([commitId isEqualToString:user.user_id])
        return  true;
    else
        return false;
}


-(NSString*)getPhoto:(int)i with:(int)j{
    NSArray *photo=[_Say_content[i] objectForKey:@"pics"];
    NSString *Url=[NSString stringWithFormat:API_IMG,photo[j]];
    NSLog(@"请求地址%@",Url);
    return Url;
}
-(NSString*)getContent:(int)i{
    return [_Say_content[i] objectForKey:@"content"];
}
-(NSString*)getTime:(int)i{
    return [_Say_content[i] objectForKey:@"created_on"];
}
-(NSString*)getName:(int)i{
    return [_Say_content[i] objectForKey:@"username"];
}
-(NSString*)getDepName:(int)i{
    return [_Say_content[i] objectForKey:@"dep_name"];
}
-(UIImage*)getImg:(int)i{
    NSString *Url=[NSString stringWithFormat:API_IMG,[_Say_content[i] objectForKey:@"head_pic_thumb"]];
    if ([Url isEqualToString:INDEX]) {
        return [self circleImage:[UIImage imageNamed:@"img_defalut"]];
    }else{
        NSURL *imageUrl = [NSURL URLWithString:Url];
        return [self circleImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]]];
    }
}
-(NSString*)getcommitcontent:(int)i with:(int)j{
    NSArray *Commit=[_Say_content[i] objectForKey:@"comments"];
    NSString *Commit_String;
    if (j<Commit.count) {
        Commit_String=[Commit[j] objectForKey:@"comment"];
    }
    else
        Commit_String=@"null";
    
    return Commit_String;
}
-(NSString*)getcommitname:(int)i with:(int)j{
    NSArray *Commit=[_Say_content[i] objectForKey:@"comments"];
    NSString *Commit_String;
    if (j<Commit.count) {
        Commit_String=[Commit[j] objectForKey:@"username"];
    }
    else
        Commit_String=@"";
    
    return Commit_String;
}
-(NSString*)getcommittime:(int)i with:(int)j{
    NSArray *Commit=[_Say_content[i] objectForKey:@"comments"];
    NSString *Commit_String;
    if (j<Commit.count) {
        Commit_String=[Commit[j] objectForKey:@"created_on"];
        Commit_String=[Commit_String substringWithRange:NSMakeRange(5,11)];
    }
    else
        Commit_String=@"";
    
    return Commit_String;
}
/**评论部分*/
-(NSString*)getsayid:(int)i{
    return [_Say_content[i] objectForKey:@"id"];
}
-(int)getcommitcount:(int)i{
    NSArray *Commit=[_Say_content[i] objectForKey:@"comments"];
    return (short)Commit.count;
}

-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
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

-(void)refresh
{
    [self.tableView.mj_header beginRefreshing];
}
-(void)loadMore
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)reload{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,num];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     _Say_content=[defaults objectForKey:@"Say"];
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
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.mj_header endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(void)load{
    num++;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS,num];
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     _Say_content=[defaults objectForKey:@"Say"];
                     [MBProgressHUD showSuccess:@"刷新成功"];
                     NSString *num_string=[NSString stringWithFormat:@"第%d页",num];
                     self.navigationItem.title = num_string;
                     HideAllHUD
                     [self.tableView.mj_footer endRefreshing];
                     self.tableView.mj_header.hidden = YES;
                     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.mj_footer endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.tableView.mj_footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             HideAllHUD
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.mj_footer endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}

-(float) GetStringWidth:(NSString *)text{
    
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(MAXFLOAT,36)];
    
    //text是想要计算的字符串，15是字体的大小，36是字符串的高度（根据需求自己改变）
    
    return size.width;
    
}

-(float)GetStringHeight:(NSString*)text{
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:14]constrainedToSize:CGSizeMake(36, MAXFLOAT)];
    
    return size.height;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"校园说说"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"校园说说"];
}

@end
