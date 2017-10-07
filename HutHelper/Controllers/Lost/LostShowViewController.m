//
//  LostShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/8/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostShowViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Lost.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XWScanImage.h"
#import "UserShowViewController.h"
#import "XWInteractiveTransition.h"
#import "XWNaviTransition.h"
#import "MBProgressHUD+MJ.h"
@interface LostShowViewController ()
@property (nonatomic, strong) XWInteractiveTransition *interactiveTransition;
@end

@implementation LostShowViewController
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    NSLog(@"%@", NSStringFromCGRect(self.imageView.frame));
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [XWNaviTransition transitionWithType:operation == UINavigationControllerOperationPush ? XWNaviOneTransitionTypePush : XWNaviOneTransitionTypePop];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"失物详情";
    self.view.backgroundColor=RGB(239, 239, 239, 1);
    //初始化手势过渡的代理
    self.interactiveTransition = [XWInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePop GestureDirection:XWInteractiveTransitionGestureDirectionRight];
    //给当前控制器的视图添加手势
    [_interactiveTransition addPanGestureForViewController:self];
    //返回箭头
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //按钮
    if (!self.isSelf) {
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_user_user"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(user) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    }else{
        //删除按钮
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_hand_delete"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(delectLost) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self setHeadImg];
    [self setText];
    [self setFoot];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //返回箭头还原
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1];
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
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(400))];
    //中心切割
    backImgView.backgroundColor=[self randomColor:_lostModel.blackColor];
    [self.view addSubview:backImgView];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(10), SYReal(80), SYReal(390), SYReal(230))];
    //商品图
    NSInteger img_x=140;
    //根据商品数量设置图片起始x位置
    switch (_lostModel.pics.count) {
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
    for (int i=0; i<_lostModel.pics.count&&i<3; i++) {
        UIImageView *goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(img_x), SYReal(85), SYReal(120), SYReal(120))];
        //中心切割
        goodsImgView.contentMode =UIViewContentModeScaleAspectFill;
        goodsImgView.clipsToBounds = YES;
        [goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Config.getApiImg,_lostModel.pics[i]]]
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
    //内容
    UITextView *goodsContentText=[[UITextView alloc]init];
    if (_lostModel.pics.count!=0) {
        goodsContentText.frame=CGRectMake(SYReal(22), SYReal(213), SYReal(375), SYReal(90));
    }else{
        goodsContentText.frame=CGRectMake(SYReal(22), SYReal(110), SYReal(375), SYReal(200));
    }
    goodsContentText.editable=NO;
    goodsContentText.backgroundColor=[UIColor clearColor];
    goodsContentText.textColor=[UIColor whiteColor];
    goodsContentText.text=_lostModel.content;
    goodsContentText.font=[UIFont systemFontOfSize:SYReal(16)];
    [self.view addSubview:goodsContentText];
    //白色卡片背景
    UIImageView *blackImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(330), SYReal(374), SYReal(355))];
    blackImgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:blackImgView];
    
    NSArray *labTitle=@[@"拾到物品",@"拾到时间",@"拾到地点",@"联系电话"];
    NSArray *icoViewArray=@[@"ico_lost_lost",@"ico_lost_time",@"ico_lost_address",@"ico_lost_tel"];
    NSArray *labContent=@[_lostModel.tit,[_lostModel.time substringWithRange:NSMakeRange(0,10)],_lostModel.locate,_lostModel.phone];
   // int LabX[5]={26,233,26,233};
    int LabY=370;
    for (int i=0; i<4; i++) {
        //固定标签
        UILabel *Lab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(90), SYReal(LabY), SYReal(50), SYReal(30))];
        Lab.textColor=[UIColor lightGrayColor];
         Lab.font=[UIFont systemFontOfSize:SYReal(12)];
        Lab.text=labTitle[i];
        [self.view addSubview:Lab];
        //ico图标
        UIImageView *icoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(45), SYReal(LabY+20), SYReal(25), SYReal(25))];
        icoImgView.image=[UIImage imageNamed:icoViewArray[i]];
        [self.view addSubview:icoImgView];
        //显示内容
        UILabel *contentLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(90), SYReal(LabY+20), SYReal(300), SYReal(40))];
        contentLab.textColor=[UIColor darkGrayColor];
        contentLab.font=[UIFont systemFontOfSize:SYReal(17)];
        contentLab.text=labContent[i];
        [self.view addSubview:contentLab];
        LabY+=75;
    }
}
-(void)setFoot{
    //绘制底部文字
    int LabX[5]={26,320};
    NSMutableArray *footTitle=[[NSMutableArray alloc]init];
    [footTitle addObject:_lostModel.username];
    [footTitle addObject:_lostModel.created_on];
    for (int i=0; i<2; i++) {
        UILabel *foodLab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(685), SYReal(130), SYReal(20))];
        foodLab.textColor=[UIColor lightGrayColor];
        foodLab.text=footTitle[i];
        foodLab.font=[UIFont systemFontOfSize:SYReal(12)];
        [self.view addSubview:foodLab];
    }
}

-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}
-(UIColor*)randomColor:(NSInteger)colors{
    switch (colors) {
        case 0:
            return RGB(176, 194, 225, 1);
            break;
        case 1:
            return RGB(156, 202, 171, 1);
            break;
        case 2:
            return RGB(193, 185, 226, 1);
            break;
        default:
            return RGB(152, 205, 222, 1);
            break;
    }
    return RGB(152, 205, 222, 1);
}
#pragma  mark - 方法
-(void)user{
    UserShowViewController *userShowViewController=[[UserShowViewController alloc]init];
    userShowViewController.name=_lostModel.username;
    userShowViewController.user_id=_lostModel.user_id;
    userShowViewController.dep_name=_lostModel.dep_name;
    userShowViewController.head_pic=_lostModel.head_pic;
    self.navigationController.delegate =nil;
    [self.navigationController pushViewController:userShowViewController animated:YES];
}
-(void)delectLost{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除失物" message:@"是否要删除当前发布的失物？" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APIRequest GET:[Config getApiLostDelect:self.lostModel.id] parameters:nil success:^(id responseObject) {
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

@end
