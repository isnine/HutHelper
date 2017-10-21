//
//  HandShow2ViewController.m
//  HutHelper
//
//  Created by nine on 2017/8/1.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandShowViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MBProgressHUD+MJ.h"
#import "UserShowViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XWScanImage.h"
@interface HandShowViewController ()

@end

@implementation HandShowViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题以及返回箭头颜色
    //返回箭头
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.title=@"商品详情";
    self.view.backgroundColor=[UIColor whiteColor];
    [self setHeadImg];
    [self setText];
    [self setFoot];
    if(self.isSelfGoods){
        //按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_hand_delete"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(delectGoods) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }else{
        //按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_user_user"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(user) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //标题透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //黑线消失
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //标题白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //返回箭头白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //返回箭头还原
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    //标题透明还原
    [self.navigationController.navigationBar lt_reset];
    //状态栏还原
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //标题还原
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}
#pragma mark - 界面绘制
-(void)setHeadImg{
    //背景放大并高斯模糊
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(390))];
    //中心切割
    backImgView.contentMode =UIViewContentModeScaleAspectFill;
    backImgView.clipsToBounds = YES;
    [backImgView sd_setImageWithURL:[NSURL URLWithString:[self getimg:0]]
                   placeholderImage:[UIImage imageNamed:@"load_img"]];
    [self.view addSubview:backImgView];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, backImgView.frame.size.width, backImgView.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [backImgView addSubview:toolbar];
    //商品图
    NSArray *goodsImgArray=_handDic[@"pics"];
    NSInteger img_x=140;
    //根据商品数量设置图片起始x位置
    switch (goodsImgArray.count) {
        case 1:
            img_x=147;
            break;
        case 2:
            img_x=86;
            break;
        case 3:
            img_x=26;
            break;
        default:
            img_x=26;
            break;
    }
    //显示商品图
    for (int i=0; i<goodsImgArray.count&&i<3; i++) {
        UIImageView *goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(img_x), SYReal(110), SYReal(120), SYReal(120))];
        //中心切割
        goodsImgView.contentMode =UIViewContentModeScaleAspectFill;
        goodsImgView.clipsToBounds = YES;
        [goodsImgView sd_setImageWithURL:[NSURL URLWithString:[self getimg:i]]
                        placeholderImage:[UIImage imageNamed:@"load_img"]];
        [self.view addSubview:goodsImgView];
        //点击图片事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [goodsImgView addGestureRecognizer:tapGestureRecognizer];
        [goodsImgView setUserInteractionEnabled:YES];
        img_x+=SYReal(125);
    }
}

-(void)setText{
    //标题
    UILabel *goodsTitleLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(26), SYReal(245), SYReal(363), SYReal(40))];
    goodsTitleLab.textColor=[UIColor whiteColor];
    goodsTitleLab.text=_handDic[@"tit"];
    goodsTitleLab.font=[UIFont systemFontOfSize:SYReal(15)];
    [self.view addSubview:goodsTitleLab];
    //内容
    UITextView *goodsContentText=[[UITextView alloc]initWithFrame:CGRectMake(SYReal(22), SYReal(280), SYReal(368), SYReal(92))];
    goodsContentText.editable=NO;
    goodsContentText.backgroundColor=[UIColor clearColor];
    goodsContentText.textColor=[UIColor whiteColor];
    goodsContentText.text=_handDic[@"content"];
    goodsContentText.font=[UIFont systemFontOfSize:SYReal(16)];
    [self.view addSubview:goodsContentText];
    //四个块的标题
    NSArray *LabTitle=@[@"价格",@"成色",@"联系电话",@"发布区域"];
    int LabX[5]={26,233,26,233};
    int LabY[5]={425,425,560,560};
    for (int i=0; i<4; i++) {
        UILabel *Lab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(LabY[i]), SYReal(50), SYReal(30))];
        Lab.textColor=[UIColor lightGrayColor];
        Lab.text=LabTitle[i];
        Lab.font=[UIFont systemFontOfSize:SYReal(12)];
        [self.view addSubview:Lab];
    }
    //四个块的数据
    NSMutableArray *goodsTitle=[[NSMutableArray alloc]init];
    [goodsTitle addObject:_handDic[@"prize"]];
    [goodsTitle addObject:_handDic[@"attr"]];
    [goodsTitle addObject:[self getcontact]];
    [goodsTitle addObject:_handDic[@"address"]];
    for (int i=0; i<4; i++) {
        UITextView *goodsLab=[[UITextView alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(LabY[i]+40), SYReal(170), SYReal(80))];
        goodsLab.textColor=[UIColor blackColor];
        goodsLab.editable=NO;
        goodsLab.text=goodsTitle[i];
        goodsLab.font=[UIFont systemFontOfSize:SYReal(17)];
        [self.view addSubview:goodsLab];
    }
}
-(void)setFoot{
    //绘制底部背景
    UIImageView *foodImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SYReal(680), DeviceMaxWidth, SYReal(56))];
    foodImgView.backgroundColor=RGB(239, 239, 239, 1);
    [self.view addSubview:foodImgView];
    //绘制底部文字
    int LabX[5]={26,280};
    NSMutableArray *footTitle=[[NSMutableArray alloc]init];
    [footTitle addObject:_handDic[@"user"][@"username"]];
    [footTitle addObject:[_handDic objectForKey:@"created_on"]];
    int i=0;
    //如果是我的商品，则跳过学号
    if(self.isSelfGoods){
        i=1;
    }
    for (; i<2; i++) {
        UILabel *foodLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(685), SYReal(130), SYReal(20))];
        foodLab.textColor=[UIColor lightGrayColor];
        foodLab.text=footTitle[i];
        foodLab.font=[UIFont systemFontOfSize:SYReal(12)];
        [self.view addSubview:foodLab];
    }
}
-(void)delectGoods{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除商品" message:@"是否要删除当前商品" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APIRequest GET:[Config getApiGoodsDelect:self.handDic[@"id"]] parameters:nil success:^(id responseObject) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"msg"]isEqualToString:@"ok"]) {
               [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-3)] animated:NO];  //返回Home
            }else{
                [MBProgressHUD showError:responseObject[@"msg"] toView:self.view];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"网络错误" toView:self.view];
        }];
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}
-(void)user{
    UserShowViewController *userShowViewController=[[UserShowViewController alloc]init];
    userShowViewController.name=_handDic[@"user"][@"username"];
    userShowViewController.user_id=_handDic[@"user_id"];
    userShowViewController.dep_name=_handDic[@"dep_name"];
    userShowViewController.head_pic=_handDic[@"head_pic_thumb"];
    [self.navigationController pushViewController:userShowViewController animated:YES];
}
#pragma mark - 数据
-(NSString*)getimg:(int)i{
    NSArray *img=[_handDic objectForKey:@"pics"];
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@",[Config getApiImg],img[i]];
    return Url_String;
}
-(NSString*)getcontact{
    if (![[_handDic objectForKey:@"phone"] isEqualToString:@""]) {
        return [_handDic objectForKey:@"phone"];
    }
    if (![[_handDic objectForKey:@"qq"]isEqualToString:@""]) {
        return [NSString stringWithFormat:@"QQ：%@",[_handDic objectForKey:@"qq"]];
    }
    if (![[_handDic objectForKey:@"wechat"]isEqualToString:@""]) {
        return [NSString stringWithFormat:@"微信：%@",[_handDic objectForKey:@"wechat"]];
    }
    return @"";
}
#pragma mark - 代理方法
//放大图片
-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
@end
