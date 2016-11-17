//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"

#import "LoginViewController.h"
#import "HomeWorkViewController.h"

#import "ClassViewController.h"
#import "SetViewController.h"

#import "AboutViewController.h"
#import "ShareViewController.h"
#import "FeedbackViewController.h"

#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *imageview           = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image                  = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];

    UITableView *tableview           = [[UITableView alloc] init];
    self.tableview                   = tableview;
    tableview.frame                  = self.view.bounds;
    tableview.dataSource             = self;
    tableview.delegate               = self;
    tableview.separatorStyle         = UITableViewCellSeparatorStyleNone;



    [self.view addSubview:tableview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier      = @"Identifier";
    UITableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
    cell                             = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }

    cell.textLabel.font              = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor             = [UIColor clearColor];
    cell.textLabel.textColor         = [UIColor whiteColor];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; //得到用户数据
    NSString *name=[defaults objectForKey:@"TrueName"];    NSString *gender=[defaults objectForKey:@"studentKH"];
    if (indexPath.row == 0) {
        if(name==NULL){
    //cell.textLabel.text              = @"登录";
        }
        else
    cell.textLabel.text              = name;
    } else if (indexPath.row == 1) {
    cell.textLabel.text              = @"";
    } else if (indexPath.row == 2) {
    cell.textLabel.text              = @"分享应用";
    cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 3) {
    cell.textLabel.text              = @"切换用户";
    cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 4) {
    cell.textLabel.text              = @"设置";
    cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 5) {
    cell.textLabel.text              = @"关于";
    cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 6) {
    cell.textLabel.text              = @"反馈";
    cell.accessoryType               = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AppDelegate *tempAppDelegate     = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    LoginViewController *vb          = [[LoginViewController alloc] init];
    HomeWorkViewController *vc       = [[HomeWorkViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];  //得到用户数据
    NSString *name=[defaults objectForKey:@"TrueName"];

    static NSString *Identifier      = @"Identifier";
    UITableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
    cell                             = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }


    if (indexPath.row == 0) { //登录
        if(name==NULL){
          [tempAppDelegate.mainNavigationController pushViewController:vb animated:NO];
                      }

           [self.tableview reloadData];

    }

    if (indexPath.row == 2) {  //切换用户
//    ShareViewController *share       = [[ShareViewController alloc] init];
//        [tempAppDelegate.mainNavigationController pushViewController:share animated:NO];

      //  [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
          [self shareTextToPlatformType:UMSocialPlatformType_QQ];
      //  [self getAuthWithUserInfoFromSina];
        
       // [self shareTextToPlatformType:UMSocialPlatformType_Qzone];
    }

    if (indexPath.row == 3) {  //切换用户
        [tempAppDelegate.mainNavigationController pushViewController:vb animated:NO];
    }
    if (indexPath.row == 4) {  //设置
    SetViewController *set           = [[SetViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:set animated:NO];
    }
    if (indexPath.row == 5) {  //关于
    AboutViewController *about       = [[AboutViewController alloc] init];
       [tempAppDelegate.mainNavigationController pushViewController:about animated:NO];
      }
    if (indexPath.row == 6) {  //反馈
    FeedbackViewController *feedback = [[FeedbackViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:feedback animated:NO];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view                     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor             = [UIColor clearColor];
    return view;
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"工大助手";
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)shareWithUI {
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //设置文本
        messageObject.text = @"社会化组件UShare将各大社交平台接入您的应用，快速武装App。";
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://hugongda.com:8888/res/app/";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
    
}
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
        }
    }];
}

- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
        }
    }];
}
@end
