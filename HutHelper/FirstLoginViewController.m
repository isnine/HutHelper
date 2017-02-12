//
//  FirstLoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/17.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FirstLoginViewController.h"
#import "Login2ViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MainPageViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "User.h"
#import "YYModel.h"
#import "Config.h"
@interface FirstLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@end

@implementation FirstLoginViewController

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (IBAction)Login:(id)sender {
    NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
    NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
    /**请求地址*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *Url_String=[NSString stringWithFormat:API_LOGIN,UserName_String,Password_String];
    /**请求*/
    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 9.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *User_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典
             NSString *Msg=[User_All objectForKey:@"msg"];
             if ([Msg isEqualToString: @"ok"])
             {
                 [defaults setObject:User_Data forKey:@"User"];
                 [defaults setObject:[User_All objectForKey:@"remember_code_app"] forKey:@"remember_code_app"];
                 NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                             objectForKey:@"CFBundleShortVersionString"];
                 [defaults setObject:currentVersion forKey:@"last_run_version_key"]; //保存版本信息
                 [defaults synchronize];
                 [self addNotice];//新增通知
                 [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                 HideAllHUD
             }
             else {
                 NSString *Show_Msg=[Msg stringByAppendingString:@",默认密码身份证后六位"];
                 HideAllHUD
                 [MBProgressHUD showError:Show_Msg];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             HideAllHUD
             [MBProgressHUD showError:@"网络错误或超时"];
         }];
}



- (IBAction)End:(id)sender {
    [sender resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _UserName.placeholder=@"学号";
    [_UserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Password.placeholder=@"密码";
    [_Password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Login2ViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
}

-(void)sein{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Login2ViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;

}







- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addNotice{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *noticeDictionary=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *noticeDictionary2=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *noticeDictionary3=[[NSMutableDictionary alloc]init];
    NSMutableArray *notice=[[NSMutableArray alloc]init];
    [noticeDictionary setObject:@"2017-02-09 08:00" forKey:@"time"];
    [noticeDictionary setObject:@"欢迎使用工大助手" forKey:@"title"];
    [noticeDictionary setObject:@"在新的版本中,我们修改了大量的界面\n包括但不限于:\n1.主界面的修改\n2.成绩查询界面的修改\n3.校园说说界面的修改\n4.二手市场界面的修改\n5.电费查询界面的修改\n6.失物招领界面的修改\n7.通知界面的增加\n8.个人中心界面的增加\n我们在此基础上修复了已知的所有Bug，如果您发现了新的Bug或者有任何建议可以在反馈中告诉我们\n如果您觉得此App给您带来了一丝便利，希望您可以在关于中打开AppStore给一个好的评分。" forKey:@"body"];
    [notice insertObject:noticeDictionary atIndex:0];
    [noticeDictionary3 setObject:@"2017-02-09 08:00" forKey:@"time"];
    [noticeDictionary3 setObject:@"开发者的一些话" forKey:@"title"];
    [noticeDictionary3 setObject:@"首先感谢你在新的学期里继续使用工大助手,由于团队每个人的分工不同，整个iOS端仅由我一个人的负责开发。对此，如果之前版本App有给你带来不便的地方，希望您能够理解。\n\n在新的版本中，我修改了大量的界面并对程序进行了优化。如果您还发现有任何Bug，可以通过【左滑菜单-反馈】向我反馈，我向您保证，您反馈的每一个Bug我都会修复，提的每一个建议，我们都会认真考虑。\n\n同时如果App给您有带来了一丝便利，我希望您可以在【左滑菜单-关于-去AppStore评分】给App进行评分，对一个整天码代码的程序猿来说，这真的是最好的鼓励了🙏\n" forKey:@"body"];
    [notice insertObject:noticeDictionary3 atIndex:1];
    [noticeDictionary2 setObject:@"2017-02-09 08:00" forKey:@"time"];
    [noticeDictionary2 setObject:@"个人中心的使用" forKey:@"title"];
    [noticeDictionary2 setObject:@"在新的版本中,我们支持了用户自定义昵称和修改头像。\n【设置昵称】左滑菜单-个人中心-修改昵称\n【设置头像】左滑菜单-个人中心-点击头像\n修改后的昵称将在校园说说中显示" forKey:@"body"];
    [notice insertObject:noticeDictionary2 atIndex:2];
    NSArray *array = [NSArray arrayWithArray:notice];
    [defaults setObject:array forKey:@"Notice"];//通知列表
    [defaults synchronize];
}

@end

