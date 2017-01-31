//
//  SayCommitViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/14.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "SayCommitViewCell.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@implementation SayCommitViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(instancetype)tableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"SayCommitViewCell" owner:NULL options:NULL] lastObject];
}
- (IBAction)delectCommit:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *Say_content=[defaults objectForKey:@"Say"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *Url_String=[NSString stringWithFormat:@"http://218.75.197.121:8888/api/v1/moments/delete/%@/%@/%@",user.studentKH,[defaults objectForKey:@"remember_code_app"],[Say_content[[self getIndexPath].section] objectForKey:@"id"]];
    
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

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}

@end
