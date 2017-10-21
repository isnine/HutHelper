//
//  UserShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/9/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "UserShowViewController.h"
#import "UINavigationBar+Awesome.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChatViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MomentsViewController.h"
#import "HandTableViewController.h"
#import "LostViewController.h"
@interface UserShowViewController ()

@end

@implementation UserShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_user_bcg"]];
    //返回箭头
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    [self draw];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)draw{
    //白色背景
    UIView *whitebackground = [[UIView alloc] init];
    whitebackground.frame = CGRectMake(SY_Real(27), SY_Real(196), SY_Real(321), SY_Real(275));
    whitebackground.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self.view addSubview:whitebackground];
    //头像
    UIImageView *headImg = [[UIImageView alloc] init];
    headImg.frame =  CGRectMake(SY_Real(125), SY_Real(133.5), SY_Real(125), SY_Real(125));
    [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Config.getApiImg,_head_pic]]
                   placeholderImage:[self circleImage:[UIImage imageNamed:@"img_defalut"]]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                              if (![[NSString stringWithFormat:@"%@%@",Config.getApiImg,_head_pic] isEqualToString:Config.getApiImg]) {
                                  if ([_head_pic isEqualToString:@"/head/head-boy.png"]||[_head_pic isEqualToString:@"/head/head-girl.png"]) {
                                      headImg.image=image;
                                  }else{
                                  headImg.image=[self circleImage:image];
                                  }
                              }}];
    
    [self.view addSubview:headImg];
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(SY_Real(63),SY_Real(288.5), SY_Real(249), SY_Real(26.5));
    nameLabel.text = _name;
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:SY_Real(19)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1/1.0];
     [self.view addSubview:nameLabel];
    //学院
    UILabel *depnameLabel = [[UILabel alloc] init];
    depnameLabel.frame = CGRectMake(SY_Real(108), SY_Real(335), SY_Real(159), SY_Real(20));
    depnameLabel.text = _dep_name;
    depnameLabel.textAlignment = NSTextAlignmentCenter;
    depnameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    depnameLabel.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1/1.0];
    //判断是打开自己的资料卡还是他人的
    if (![self.user_id isEqualToString:Config.getUserId]) {
        [self.view addSubview:depnameLabel];
        //发起聊天按钮
        UIButton *imBtn = [[UIButton alloc] init];
        imBtn.frame = CGRectMake(SY_Real(84), SY_Real(385), SY_Real(207), SY_Real(35));
        [imBtn addTarget:self action:@selector(im) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imBtn];
        UIImageView *imBtnImg = [[UIImageView alloc] init];
        imBtnImg.frame =  CGRectMake(SY_Real(84), SY_Real(385), SY_Real(207), SY_Real(35));
        imBtnImg.image=[UIImage imageNamed:@"img_user_imbtn"];
        [self.view addSubview:imBtnImg];
    }else{
        UILabel *namelab = [[UILabel alloc] init];
        namelab.frame = CGRectMake(SY_Real(101), SY_Real(344), SY_Real(173), SY_Real(25));
        namelab.text = [NSString stringWithFormat:@"%@ %@ %@",Config.getTrueName,Config.getSex,Config.getStudentKH];
        namelab.textAlignment = NSTextAlignmentCenter;
        namelab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:SY_Real(14)];
        namelab.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1/1.0];
        [self.view addSubview:namelab];
        UILabel *deplab = [[UILabel alloc] init];
        deplab.frame = CGRectMake(SY_Real(101), SY_Real(375), SY_Real(173), SY_Real(25));
        deplab.text = [NSString stringWithFormat:@"%@ %@",Config.getDepName,Config.getClassName];
        deplab.textAlignment = NSTextAlignmentCenter;
        deplab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:SY_Real(14)];
        deplab.textColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1/1.0];
        [self.view addSubview:deplab];
    }
    
    //校园说说
    UIButton *sayBtn = [[UIButton alloc] init];
    [sayBtn addTarget:self action:@selector(say) forControlEvents:UIControlEventTouchUpInside];
    sayBtn.frame = CGRectMake(SY_Real(160), SY_Real(443.5), SY_Real(55), SY_Real(55));
    [self.view addSubview:sayBtn];
    UIImageView *sayBtnImg = [[UIImageView alloc] init];
    sayBtnImg.frame =  CGRectMake(SY_Real(160), SY_Real(443.5), SY_Real(55), SY_Real(55));
    sayBtnImg.image=[UIImage imageNamed:@"img_user_saybtn"];
    [self.view addSubview:sayBtnImg];
    //失物招领
    UIButton *lostBtn = [[UIButton alloc] init];
    [lostBtn addTarget:self action:@selector(lost) forControlEvents:UIControlEventTouchUpInside];
    lostBtn.frame = CGRectMake(SY_Real(70), SY_Real(443.5), SY_Real(55), SY_Real(55));
    [self.view addSubview:lostBtn];
    UIImageView *lostBtnImg = [[UIImageView alloc] init];
    lostBtnImg.frame =  CGRectMake(SY_Real(70), SY_Real(443.5), SY_Real(55), SY_Real(55));
    lostBtnImg.image=[UIImage imageNamed:@"img_user_lostbtn"];
    [self.view addSubview:lostBtnImg];
    //二手市场
    UIButton *handBtn = [[UIButton alloc] init];
    [handBtn addTarget:self action:@selector(hand) forControlEvents:UIControlEventTouchUpInside];
    handBtn.frame = CGRectMake(SY_Real(250), SY_Real(443.5), SY_Real(55), SY_Real(55));
    [self.view addSubview:handBtn];
    UIImageView *handBtnImg = [[UIImageView alloc] init];
    handBtnImg.frame =  CGRectMake(SY_Real(250), SY_Real(443.5), SY_Real(55), SY_Real(55));
    handBtnImg.image=[UIImage imageNamed:@"img_user_handbtn"];
    [self.view addSubview:handBtnImg];
}
#pragma  mark - 方法
-(void)im{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录后再联系Ta" toView:self.view];
        return;
    }
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = _user_id;
    conversationVC.title = _name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
-(void)hand{
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [APIRequest GET:[Config getApiOtherGoods:1 withId:_user_id] parameters:nil success:^(id responseObject) {
        HideAllHUD
        NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
        NSArray *Hand           = [dic1 objectForKey:@""];
        if (Hand.count>0) {
            NSMutableArray *data=[[NSMutableArray alloc]init];
            NSDictionary *a=@{@"page_cur":@"1",
                              @"page_max":@67
                              };
            [data addObject:a];
            [data addObjectsFromArray:Hand];
            HandTableViewController *hand=[[HandTableViewController alloc]init];
            hand.otherHandArray=[data mutableCopy];
            hand.otherName=_name;
            [self.navigationController pushViewController:hand animated:YES];
        }else{
            [MBProgressHUD showError:@"对方没有发布的商品" toView:self.view];
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络超时" toView:self.view];
    }];
}
-(void)say{
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@",Config.getApiMomentsUser,_user_id];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
        HideAllHUD
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
            NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content.count!=0) {
                [defaults setObject:Say_content forKey:@"otherSay"];
                [defaults synchronize];
                [Config setIs:1];
                MomentsViewController *Say      = [[MomentsViewController alloc] init];
                [self.navigationController pushViewController:Say animated:YES];
            }else{
                [MBProgressHUD showError:@"对方没有发布的说说" toView:self.view];
            }
        }
        else{
            [MBProgressHUD showError:@"网络错误" toView:self.view];
        }
        
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络错误" toView:self.view];
        
    }];
}
-(void)lost{
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    //发起请求
    [APIRequest GET:[Config getApiLostUserOther:_user_id] parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        HideAllHUD
        if ([[responseDic objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *responseDataDic=[responseDic objectForKey:@"data"];
            NSArray *responseDataPostArray=[responseDataDic objectForKey:@"posts"];//加载该页数据
            if (responseDataPostArray.count!=0) {
                LostViewController *lostViewController=[[LostViewController alloc]init];
                lostViewController.otherLostArray=responseDataPostArray;
                lostViewController.otherName=_name;
                [self.navigationController pushViewController:lostViewController animated:YES];
            }else{
                [MBProgressHUD showError:@"对方没有发布的失物" toView:self.view];
            }
        }
        else{
            [MBProgressHUD showError:[responseDic objectForKey:@"msg"] toView:self.view];
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络超时" toView:self.view];
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

@end
