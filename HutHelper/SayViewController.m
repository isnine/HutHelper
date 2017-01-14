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
@interface SayViewController ()
@property (nonatomic,copy) NSArray      *Say_content;
@end

@implementation SayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
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
    return [self getcommitcount:(short)section]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{///每块的高度
    if (indexPath.row==0)
        return 130;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SayViewCell *cell = [SayViewCell tableViewCell];
    SayCommitViewCell *cellcommit = [SayCommitViewCell tableViewCell];
    tableView.separatorStyle = NO;
    /**得到评论数组*/
    if (indexPath.row == 0)
    {
        cell.username.text=[self getName:(short)indexPath.section];
        cell.created_on.text=[self getTime:(short)indexPath.section];
        cell.content.text=[self getContent:(short)indexPath.section]; 
        cell.img.image = [self getImg:(short)indexPath.section];
        return cell;
    }
    else{
        cellcommit.CommitName.text=[self getcommitname:(short)indexPath.section with:(short)indexPath.row-1];
        cellcommit.CommitContent.text=[self getcommitcontent:(short)indexPath.section with:(short)indexPath.row-1];
        cellcommit.CommitTime.text=[self getcommittime:(short)indexPath.section with:(short)indexPath.row-1];
        return cellcommit;
    }
}
#pragma mark - "其他"
-(void)menu{
    
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
        Url=@"http://218.75.197.121:8888//public/pics/m_001.png";
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
       Commit_String=@"";
    
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
