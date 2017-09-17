//
//  PowerViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "PowerViewController.h"
#import "JSONKit.h"
#import "UMMobClick/MobClick.h"
#import "UINavigationBar+Awesome.h"
#import "MBProgressHUD+MJ.h"
@interface PowerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Building;
@property (weak, nonatomic) IBOutlet UITextField *Room;

typedef NS_ENUM(NSUInteger, PowerSelectBtn) {
    UnSelected =0,
    OpenSelected=1 ,
    NoOpenSelected=2,
};
@property(assign,nonatomic)PowerSelectBtn powerSelectBtn;
@end

@implementation PowerViewController
- (IBAction)openBtn:(id)sender {
    switch (self.powerSelectBtn) {
        case 0:
            [self.openBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
            self.powerSelectBtn=OpenSelected;
            break;
        case 1:
            [self.openBtn setImage:[UIImage imageNamed:@"ico_power_unselected"] forState:UIControlStateNormal];
             self.powerSelectBtn=UnSelected;
            break;
        case 2:
            [self.openBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
            [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_unselected"] forState:UIControlStateNormal];
            self.powerSelectBtn=OpenSelected;
            break;
        default:
            break;
    }
    
}
- (IBAction)noOpenBtn:(id)sender {
    [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
    switch (self.powerSelectBtn) {
        case 0:
            [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
            self.powerSelectBtn=NoOpenSelected;
            break;
        case 1:
            [self.openBtn setImage:[UIImage imageNamed:@"ico_power_unselected"] forState:UIControlStateNormal];
            [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
            self.powerSelectBtn=NoOpenSelected;
            break;
        case 2:
            [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_unselected"] forState:UIControlStateNormal];
            self.powerSelectBtn=UnSelected;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _Building.placeholder=@"宿舍楼栋";
    [_Building setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Room.placeholder=@"寝室号";
    [_Room setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.title=@"电费查询";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self getRoom];
    //默认关闭选择
    self.openBtn.enabled=NO;
    self.noOpenBtn.enabled=NO;
    //点击空白收起键盘
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    //如果当天没有投过票再打开
    [APIRequest GET:Config.getApiPowerAirCondition parameters:nil success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        int yesInt=[responseObject[@"data"][@"yes"] intValue];
        int noInt=[responseObject[@"data"][@"no"] intValue];
        //yes进度条
        if (noInt+yesInt!=0) {
            UIImageView *yesImageView=[[UIImageView alloc]init];
            yesImageView.frame=CGRectMake(SYReal(87), SYReal(609), SYReal(180*yesInt*1.0/(noInt+yesInt)), SYReal(20));
            yesImageView.image=[self scaleImage:[UIImage imageNamed:@"img_power_isopen"] toScale:yesInt*1.0/(noInt+yesInt)];
            yesImageView.contentMode =UIViewContentModeLeft;
            yesImageView.clipsToBounds = YES;
            yesImageView.alpha=0.7;
            //进度条的圆角
            yesImageView.layer.masksToBounds = YES; //没这句话它圆不起来
            yesImageView.layer.cornerRadius = 11.0; //设置图片圆角的尺度
            yesImageView.userInteractionEnabled=NO;
            [self.view addSubview:yesImageView];
            //no进度条
            UIImageView *noImageView=[[UIImageView alloc]init];
            noImageView.frame=CGRectMake(SYReal(87), SYReal(644), SYReal(180*noInt*1.0/(noInt+yesInt)), SYReal(20));
            noImageView.image=[self scaleImage:[UIImage imageNamed:@"img_power_isopen"] toScale:noInt*1.0/(noInt+yesInt)];
            noImageView.contentMode =UIViewContentModeLeft;
            noImageView.clipsToBounds = YES;
            noImageView.alpha=0.7;
            //进度条的圆角
            noImageView.layer.masksToBounds = YES; //没这句话它圆不起来
            noImageView.layer.cornerRadius = 11.0; //设置图片圆角的尺度
            noImageView.userInteractionEnabled=NO;
            [self.view addSubview:noImageView];
            
            self.openLab.text=responseObject[@"data"][@"yes"];
            self.unOpenLab.text=responseObject[@"data"][@"no"];
            if (responseObject[@"opt"]) {
                self.powerSelectBtn=[responseObject[@"opt"] intValue];
                switch (self.powerSelectBtn) {
                    case 1:
                        [self.openBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
                        self.openBtn.enabled=NO;
                        self.noOpenBtn.enabled=NO;
                        break;
                    case 2:
                        [self.noOpenBtn setImage:[UIImage imageNamed:@"ico_power_selected"] forState:UIControlStateNormal];
                        self.openBtn.enabled=NO;
                        self.noOpenBtn.enabled=NO;
                        break;
                    default:
                        self.openBtn.enabled=YES;
                        self.noOpenBtn.enabled=YES;
                        break;
                }
            }
        }
       
    } failure:^(NSError *error) {
        NSLog(@"网络错误");
    }];
}
-(void)getRoom{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"PowerBuild"]) {
        _Building.text=[defaults objectForKey:@"PowerBuild"];
    }
    if ([defaults objectForKey:@"PowerRoom"]) {
        _Room.text=[defaults objectForKey:@"PowerRoom"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Mark:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Build_String    = _Building.text;
    NSString *Room_String     = _Room.text;
    NSURL *url                = [NSURL URLWithString: [Config getApiPower:Build_String room:Room_String]];//接口地址
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    [APIRequest GET:[Config getApiPower:Build_String room:Room_String] parameters:nil success:^(id responseObject) {
        NSString *power_du=[responseObject objectForKey:@"oddl"];
        NSString *power_money=[responseObject objectForKey:@"prize"];
        [defaults setObject:Build_String forKey:@"PowerBuild"];
        [defaults setObject:Room_String forKey:@"PowerRoom"];
        UIAlertView *alertView    = [[UIAlertView alloc] initWithTitle:@"查询成功"
                                                               message:[NSString stringWithFormat:@"\n余电:%@度\n余额:%@元",power_du,power_money]
                                                              delegate:self
                                                     cancelButtonTitle:@"确认"
                                                     otherButtonTitles:nil, nil];
        [alertView show];
        HideAllHUD
    } failure:^(NSError *error) {
        UIAlertView *alertView    = [[UIAlertView alloc] initWithTitle:@"查询失败"
                                                               message:@"输入的信息错误"
                                                              delegate:self
                                                     cancelButtonTitle:@"确认"
                                                     otherButtonTitles:nil, nil];
        [alertView show];
        HideAllHUD
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"电费查询"];//("PageOne"为页面名称，可自定义)
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"电费查询"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (self.powerSelectBtn!=UnSelected) {
        [APIRequest GET:[Config getApiPowerAirConditionCreate:self.powerSelectBtn] parameters:nil success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSError *error) {
            NSLog(@"保存空调数据时网络错误");
        }];
    }
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height ));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
