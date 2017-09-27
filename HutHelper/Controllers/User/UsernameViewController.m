//
//  UsernameViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/20.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UsernameViewController.h"
#import "JSONKit.h"

#import "User.h"
#import "MBProgressHUD+MJ.h"
#import "APIRequest.h"

@interface UsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Username;

@end

@implementation UsernameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改昵称";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // Do any additional setup after loading the view.
}
- (IBAction)Add:(id)sender {
    [MBProgressHUD showMessage:@"修改中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *username_text=_Username.text;
    NSDictionary *dict = @{@"username":username_text};
    [APIRequest POST:Config.getApiProfileUser parameters:dict success:^(id responseObject) {
        HideAllHUD
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *Msg=[responseDic objectForKey:@"msg"];
        if ([Msg isEqualToString:@"ok"]) {
            [defaults setObject:username_text forKey:@"username"];
            [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
        }
        else if ([Msg isEqualToString:@"令牌错误"]){
            [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
        }
        else{
            [MBProgressHUD showError:@"网络错误" toView:self.view];
        }
    } failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络错误" toView:self.view];
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
