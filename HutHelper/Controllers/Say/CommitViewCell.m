//
//  CommitViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "CommitViewCell.h"
#import "SayViewController.h"
#import "UUInputAccessoryView.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"
@implementation CommitViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)tableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CommitViewCell" owner:nil options:nil] lastObject];
}

- (IBAction)delectCommit:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Say_content=[defaults objectForKey:@"Say"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
     NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_DELETE,user.studentKH,[defaults objectForKey:@"remember_code_app"],[Say_content[[self getIndexPath].section] objectForKey:@"id"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 [MBProgressHUD showSuccess:@"删除成功,请重新刷新"];
             }
             else{
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
             [MBProgressHUD showError:@"网络错误"];
         }];
}


- (IBAction)addCommit:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Say_content=[defaults objectForKey:@"Say"];
    /**拼接地址*/
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *Url_String=[NSString stringWithFormat:API_MOMENTS_CREATE_COMMENT,user.studentKH,[defaults objectForKey:@"remember_code_app"],[Say_content[[self getIndexPath].section] objectForKey:@"id"]];
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
        [MBProgressHUD showMessage:@"发表中" toView:self];
        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *Msg=[response objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"])   {
                [MBProgressHUD hideHUDForView:self animated:YES];
                [MBProgressHUD showSuccess:@"评论成功"];
                SayViewController *say=[[SayViewController alloc]init];
                [say reload];
            }
            else if ([Msg isEqualToString:@"令牌错误"]){
                [MBProgressHUD hideHUDForView:self animated:YES];
                [MBProgressHUD showError:@"登录过期，请重新登录"];}
            else{
                [MBProgressHUD hideHUDForView:self animated:YES];
                [MBProgressHUD showError:Msg];}
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self animated:YES];
            [MBProgressHUD showError:@"网络错误"];
        }];
        
    }];
}



- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}
@end
