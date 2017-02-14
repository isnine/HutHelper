//
//  HandTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "HandShowViewController.h"
#import "AppDelegate.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "Config.h"
@implementation HandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /**加载数据*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _Hand_content=[defaults objectForKey:@"Hand"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)tableviewcell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
}
- (IBAction)Buuton1:(id)sender {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *Url_String=[NSString stringWithFormat:API_GOODS_SHOW,user.studentKH,[defaults objectForKey:@"remember_code_app"],[self getid:(short)([self getIndexPath].section+1)*2-1]];
    NSLog(@"商品查询地址:%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSDictionary *array               = [Hand_All objectForKey:@"data"];
                 [defaults setObject:array forKey:@"Hand_Show"];
                 [defaults synchronize];
                 //进入商品界面
                 UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 HandShowViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ShowHand"];
                 AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
             }
             else if ([Msg isEqualToString:@"令牌错误"]){
                 [MBProgressHUD showError:@"登录过期,请重新登录"];
             }
             else {
                 [MBProgressHUD showError:@"查询失败"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
         }];
    
    
    
}
- (IBAction)Button2:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *Url_String=[NSString stringWithFormat:API_GOODS_SHOW,user.studentKH,[defaults objectForKey:@"remember_code_app"],[self getid:(short)([self getIndexPath].section+1)*2]];
    NSLog(@"商品查询地址:%@",Url_String);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSArray *array               = [Hand_All objectForKey:@"data"];
                 [defaults setObject:array forKey:@"Hand_Show"];
                 [defaults synchronize];
                 //进入商品界面
                 UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 HandShowViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ShowHand"];
                 AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
             }
             else{
                 [MBProgressHUD showError:@"查询失败"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
         }];
}

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}
-(NSString*)getid:(int)i{
    return [_Hand_content[i] objectForKey:@"id"];
}

@end
