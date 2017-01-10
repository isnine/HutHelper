//
//  LoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/8.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LoginViewController.h"
#import "Login2ViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;



@end

@implementation LoginViewController

- (IBAction)Login:(id)sender {
    APIManager *API_Request=[[APIManager alloc]init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
        NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
        NSString *msg=[API_Request Login:UserName_String With:Password_String];

        if ([msg isEqualToString:@"ok"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
        }
        else if(msg!=NULL){
            UIAlertView *alertView       = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                      message:msg
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        else{
            UIAlertView *alertView       = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                      message:@"网络错误"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

}


- (IBAction)Didend:(id)sender {
    [sender resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *greyColor           = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor    = greyColor;
    self.title                   = @"切换用户";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _UserName.placeholder=@"学号";
    _Password.placeholder=@"密码";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
