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

@end

@implementation PowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _Building.placeholder=@"宿舍楼栋";
    [_Building setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Room.placeholder=@"寝室号";
    [_Room setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.title=@"电费查询";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self getRoom];
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"电费查询"];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1];
    [self.navigationController.navigationBar lt_reset];
}

@end
