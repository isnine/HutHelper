//
//  HandTableViewCell.m
//  HutHelper
//
//  Created by nine on 2017/1/16.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "Hand.h"
#import "User.h"
#import "AFNetworking.h"
#import "HandShowViewController.h"
@implementation HandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

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
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录后查看" toView:self];
        return;
    }
    Hand *hand=_handArray[(short)(((UITableViewCell*)[[sender superview]superview]).tag+1)*2-1];
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@/%@/%@",Config.getApiGoodsShow,Config.getStudentKH,Config.getRememberCodeApp,hand.good_id];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
        NSLog(@"%@",Msg);
             if ([Msg isEqualToString:@"ok"]) {
                 NSDictionary *array               = [Hand_All objectForKey:@"data"];
                 //进入商品界面
                 HandShowViewController *handShow=[[HandShowViewController alloc]init];
                 handShow.isSelfGoods=self.isSelfGoods;
                 handShow.handDic=array;
                 AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:handShow animated:YES];
             }else {
                 [MBProgressHUD showError:Msg toView:self];
             }
        }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络错误" toView:self];
         }];
    
    
    
}
- (IBAction)Button2:(id)sender {
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录后查看" toView:self];
        return;
    }
    Hand *hand=_handArray[(short)(((UITableViewCell*)[[sender superview]superview]).tag+1)*2];
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@/%@/%@",Config.getApiGoodsShow,Config.getStudentKH,Config.getRememberCodeApp,hand.good_id];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
             NSDictionary *Hand_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSString *Msg=[Hand_All objectForKey:@"msg"];
             if ([Msg isEqualToString:@"ok"]) {
                 NSDictionary *array               = [Hand_All objectForKey:@"data"];
                 //进入商品界面
                 HandShowViewController *handShow=[[HandShowViewController alloc]init];
                 handShow.handDic=array;
                 handShow.isSelfGoods=self.isSelfGoods;
                 AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 [tempAppDelegate.mainNavigationController pushViewController:handShow animated:YES];
             }else{
                 [MBProgressHUD showError:Msg toView:self];
             }
         }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络错误"toView:self];
         }];
}

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}


@end
