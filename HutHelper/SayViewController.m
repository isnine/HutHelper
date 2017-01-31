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
#import "UUInputAccessoryView.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "AddSayViewController.h"
@interface SayViewController ()
@property (nonatomic,copy) NSArray      *Say_content;
@end

@implementation SayViewController
int num=1;
- (void)viewDidLoad {
    [super viewDidLoad];
    num=1;
    self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"new_menu"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    /**加载数据*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _Say_content=[defaults objectForKey:@"Say"];
    /**下拉刷新*/
    //默认【下拉刷新】
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reload)];
    //默认【上拉加载】
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(load)];
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
    
    return 20;
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
//        NSLog(@"宽度%lf，这是当前第%d条",[self GetStringHeight:[self getContent:(short)indexPath.section]],(short)indexPath.section);
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
    if ((indexPath.row==1&&photo.count==0)||(indexPath.row==2&&photo.count!=0)) {
       
        /**拼接地址*/
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *User_Data=[defaults objectForKey:@"User"];
        User *user=[User yy_modelWithJSON:User_Data];
        NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/moments/comment/%@/%@/%@",user.studentKH,[defaults objectForKey:@"remember_code_app"],[self getsayid:indexPath.section]];
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
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showSuccess:@"评论成功"];
                    [self reload];
                }
                else if ([Msg isEqualToString:@"令牌错误"]){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showError:@"登录过期，请重新登录"];}
                else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [MBProgressHUD showError:Msg];}
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
            return cellshowcommit;
        }
        else if(photo.count==1){
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            return cellphoto;
        }
        else if(photo.count==2){
            exis++;
            [cellphoto.Img1 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:0]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            [cellphoto.Img2 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:1]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
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
            [cellphoto.Img3 sd_setImageWithURL:[NSURL URLWithString:[self getPhoto:(short)indexPath.section with:3]]
                              placeholderImage:[UIImage imageNamed:@"load_img"]];
            return cellphoto;
        }
        
        
    }
    else if (indexPath.row == 2) {
        if (photo.count==0) {
            cellcommit.CommitName.text=[self getcommitname:(short)indexPath.section with:(short)indexPath.row-exis];
            cellcommit.CommitContent.text=[self getcommitcontent:(short)indexPath.section with:(short)indexPath.row-exis];
            cellcommit.CommitTime.text=[self getcommittime:(short)indexPath.section with:(short)indexPath.row-exis];
        //    cellcommit.delectButton.hidden=![self isShowCommitDelect:(short)indexPath.section with:(short)indexPath.row-exis];
            return cellcommit;
        }
        else{
            cellshowcommit.commitsize.text=[NSString stringWithFormat:@"%d",[self getcommitcount:(short)indexPath.section]];
            cellshowcommit.delectButton.hidden=![self isShowDelect:(short)indexPath.section];
            return cellshowcommit;
        }
        
    }
    else{
        if(photo.count!=0){
            exis=3;}
        cellcommit.CommitName.text=[self getcommitname:(short)indexPath.section with:(short)indexPath.row-exis];
        cellcommit.CommitContent.text=[self getcommitcontent:(short)indexPath.section with:(short)indexPath.row-exis];
     //   cellcommit.delectButton.hidden=![self isShowCommitDelect:(short)indexPath.section with:(short)indexPath.row-exis];
        cellcommit.CommitTime.text=[self getcommittime:(short)indexPath.section with:(short)indexPath.row-exis];
        return cellcommit;
            
    }
}
#pragma mark - "其他"
-(void)menu{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddSayViewController *addsayViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddSay"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:addsayViewController animated:NO];
}

-(void)load:(int)num{
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/moments/posts/%d",num];
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
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    NSLog(@"说说:%@个人:%@",commitId,user.user_id);
    if ([commitId isEqualToString:user.user_id])
        return  true;
    else
        return false;
}

-(NSString*)getPhoto:(int)i with:(int)j{
    NSArray *photo=[_Say_content[i] objectForKey:@"pics"];
    NSString *Url=[NSString stringWithFormat:@"http://218.75.197.121:8888/%@",photo[j]];
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
-(UIImage*)getImg:(int)i{
    NSString *Url=[NSString stringWithFormat:@"http://218.75.197.121:8888/%@",[_Say_content[i] objectForKey:@"head_pic_thumb"]];
    if ([Url isEqualToString:@"http://218.75.197.121:8888/"]) {
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
    [self.tableView.header beginRefreshing];
}
-(void)loadMore
{
    [self.tableView.header beginRefreshing];
}

-(void)reload{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/moments/posts/%d",num];
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
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [self.tableView.header endRefreshing];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.header endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.tableView.header endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.header endRefreshing];
             [MBProgressHUD showError:@"网络错误"];
         }];
}
-(void)load{
    num++;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/moments/posts/%d",num];
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
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [self.tableView.footer endRefreshing];
                     self.tableView.mj_header.hidden = YES;
                     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     [self.tableView reloadData];
                 }
                 else{
                     [self.tableView.footer endRefreshing];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [self.tableView.footer endRefreshing];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.tableView.footer endRefreshing];
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



@end
