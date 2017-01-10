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
#import "APIManager.h"
@interface FirstLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@end

@implementation FirstLoginViewController
- (IBAction)Login:(id)sender {
    APIManager *API_Request=[[APIManager alloc]init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
        NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
        NSString *msg=[API_Request Login:UserName_String With:Password_String];
        if ([msg isEqualToString: @"ok"])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
            
        }
        else if(msg!=NULL){
            NSString *Message=[msg stringByAppendingString:@"，默认密码为身份证后六位"];
            UIAlertView *alertView       = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                                      message:Message
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



- (IBAction)End:(id)sender {
    [sender resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _UserName.placeholder=@"学号";
    [_UserName setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Password.placeholder=@"密码";
    [_Password setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

-(void)sein{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Login2"];
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

@end
