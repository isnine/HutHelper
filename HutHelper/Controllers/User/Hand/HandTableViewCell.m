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

#import "User.h"
#import "AFNetworking.h"
 
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

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
        
    }
    return self;
}
+(instancetype)tableviewcell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HandTableViewCell" owner:nil options:nil]lastObject];
}
- (IBAction)Buuton1:(id)sender {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@/%@/%@",Config.getApiGoodsShow,Config.getStudentKH,Config.getRememberCodeApp,[self getid:(short)([self getIndexPath].section+1)*2-1]];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSDictionary *array               = [Hand_All objectForKey:@"data"];
                 [defaults setObject:array forKey:@"Hand_Show"];
                 [defaults synchronize];
                 //进入商品界面
                 [Config pushViewController:@"ShowHand"];
             }
             else if ([Msg isEqualToString:@"令牌错误"]){
                 [MBProgressHUD showError:@"登录过期,请重新登录"];
             }
             else {
                 [MBProgressHUD showError:@"查询失败"];
             }
        }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络错误"];
         }];
    
    
    
}
- (IBAction)Button2:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@/%@/%@",Config.getApiGoodsShow,Config.getStudentKH,Config.getRememberCodeApp,[self getid:(short)([self getIndexPath].section+1)*2]];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSArray *array               = [Hand_All objectForKey:@"data"];
                 [defaults setObject:array forKey:@"Hand_Show"];
                 [defaults synchronize];
                 //进入商品界面
                  [Config pushViewController:@"ShowHand"];
             }
             else{
                 [MBProgressHUD showError:@"查询失败"];
             }
         }failure:^(NSError *error) {
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
