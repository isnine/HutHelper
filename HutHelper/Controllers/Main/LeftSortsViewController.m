//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "HomeWorkViewController.h"
#import "CourseViewController.h"
#import "CourseSetViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "UMessage.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "LoginViewController.h"
#import "LeftUserTableViewCell.h"
#import "LeftItemTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RongIMKit/RongIMKit.h>
#import "ChatListViewController.h"
#import "UserShowViewController.h"
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
    tableview.tag = 2001;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return  SYReal(150);
    }else{
        return SYReal(45);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftUserTableViewCell *userCell;
    LeftItemTableViewCell *itemCell;
    if (!userCell) {
        userCell=[LeftUserTableViewCell tableViewCell];
    }
    if (!itemCell) {
        itemCell=[LeftItemTableViewCell tableViewCell];
    }
    userCell.backgroundColor             = [UIColor clearColor];
    itemCell.backgroundColor             = [UIColor clearColor];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; //得到用户数据
    if (indexPath.row == 0) {
        if(!Config.getTrueName){
            userCell.Username.text              = @"个人中心";
        }else{
            userCell.Username.text                = Config.getTrueName;
        }
       // userCell.Head.image=[self getImg];
        [userCell.Head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Config.getApiImg,Config.getHeadPicThumb]]
                       placeholderImage:[UIImage imageNamed:@"img_user_boy"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                      if ([Config.getHeadPicThumb isEqualToString:@"/head/head-boy.png"]||[Config.getHeadPicThumb isEqualToString:@"/head/head-girl.png"]) {
                                          userCell.Head.image=image;
                                      }else{
                                          userCell.Head.image=[self circleImage:image];
                                      }
                              }];
        return userCell;
    }else if (indexPath.row == 2) {
        itemCell.Text.text                = @"私信";
        itemCell.Img.image=[UIImage imageNamed:@"ico_left_im"];
        return itemCell;
    }else if (indexPath.row == 3) {
        itemCell.Text.text              = @"分享应用";
        itemCell.Img.image=[UIImage imageNamed:@"ico_left_shares"];
        return itemCell;
    } else if (indexPath.row == 4) {
        itemCell.Text.text                = @"切换用户";
        itemCell.Img.image=[UIImage imageNamed:@"ico_left_sign-out"];
        return itemCell;
    } else if (indexPath.row == 5) {
        itemCell.Text.text                = @"关于";
        itemCell.Img.image=[UIImage imageNamed:@"ico_left_about"];
        return itemCell;
    } else if (indexPath.row == 6) {
        itemCell.Text.text                = @"反馈";
        itemCell.Img.image=[UIImage imageNamed:@"ico_left_feedback"];
        return itemCell;
    } else{
        return itemCell;
    }
}

//-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return row;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *tempAppDelegate     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];  //得到用户数据
    NSString *name=[defaults objectForKey:@"TrueName"];
    
    static NSString *Identifier      = @"Identifier";
    UITableViewCell *cell            = [tableView dequeueReusableCellWithIdentifier:Identifier];
    LeftUserTableViewCell *userCell=[LeftUserTableViewCell tableViewCell];
    if (! cell) {
        cell                = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    if (indexPath.row == 0) { //个人界面
        [self.tableview reloadData];
        [Config pushViewController:@"User"];
    }
    if (indexPath.row == 2) {  //私信
        if ([Config isTourist]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"游客请登录" message:@"需要学校账号才可使用私信" preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ChatListViewController *chatList = [[ChatListViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:chatList animated:YES];
    }
    if (indexPath.row == 3) {  //分享
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
        }];
    }
    
    if (indexPath.row == 4) {  //切换用户
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换用户" message:@"是否要退出当前账号" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Config removeUmeng];
            [Config removeUserDefaults];
            [[RCIM sharedRCIM] clearUserInfoCache];
             [[RCIM sharedRCIM]logout];
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            LoginViewController *firstlogin                = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
        }]];
        [self presentViewController:alert animated:true completion:nil];
       
    }
    if (indexPath.row == 5) {  //关于
        [Config pushViewController:@"About"];
    }
    if (indexPath.row == 6) {  //反馈
        [Config pushViewController:@"Feedback"];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SYReal(130);
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"工大助手" descr:@"工大助手APP是由湖南工业大学计算机学院实验室移动组和网络组，为工大学生开发的产品，志于帮助同学们更加便捷的体验校园生活。" thumImage:[UIImage imageNamed:@"ico"]];
    //设置网页地址
    shareObject.webpageUrl =[NSString stringWithFormat:@"%@/res/index",Config.apiIndex];
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

-(NSString*)getHeadUrl{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@/%@",Config.getApiImg,Config.getHeadPicThumb];
}
-(void)downHead{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *image_url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,Config.getHeadPicThumb];
    NSURL *url                   = [NSURL URLWithString: image_url];//接口地址
    [manager downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        NSData *data = UIImagePNGRepresentation(image);
        if (data!=NULL&&![image_url isEqualToString:Config.getApiImg]) {
            [defaults setObject:data forKey:@"head_img"];
            [defaults synchronize];
        }
    }];
}

-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
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
-(UIImage*)getImg{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; //得到用户数据
    NSString *Url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,Config.getHeadPicThumb];
    if ([Config.getHeadPicThumb isEqualToString:@"/head/head-boy.png"]||
        [Config.getHeadPicThumb isEqualToString:@"/head/head-girl.png"]||
        (!Config.getHeadPicThumb)||
        [Config.getHeadPicThumb isEqualToString:@""]) {
            if ([Config.getSex isEqualToString:@"男"]) {
                return [UIImage imageNamed:@"img_user_boy"];
            }else{
                return [UIImage imageNamed:@"img_user_girl"];
            }
    }else if ([defaults objectForKey:@"kUserHead"]!=NULL){
        return [self circleImage:[UIImage imageWithData:[defaults objectForKey:@"kUserHead"]]];
    }else{
        NSURL *imageUrl = [NSURL URLWithString:Url];
        UIImage *Img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        NSData *data = UIImagePNGRepresentation(Img);
        [defaults setObject:data forKey:@"kUserHead"];
        [defaults synchronize];
        return [self circleImage:Img];
    }
}
@end
