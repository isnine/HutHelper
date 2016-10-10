//
//  LoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/8.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LoginViewController.h"
#import "JSONKit.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;



@end

@implementation LoginViewController

- (IBAction)Login:(id)sender {
    //       拼接地址 RUN
    NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
    NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
    NSString *Url_String_1=@"http://hugongda.com:8888/api/v1/get/login/";
    NSString *Url_String_2=@"/";
    NSString *Url_String_3=@"/1";
    
    NSString *Url_String_1_U=[Url_String_1 stringByAppendingString:UserName_String];
    NSString *Url_String_1_U_2=[Url_String_1_U stringByAppendingString:Url_String_2];
    NSString *Url_String_1_U_2_P=[Url_String_1_U_2 stringByAppendingString:Password_String];
    NSString *Url_String=[Url_String_1_U_2_P stringByAppendingString:Url_String_3];
    //       拼接地址 END
    
    NSURL *url = [NSURL URLWithString: Url_String]; //接口地址
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *User_All = [jsonData objectFromJSONData];//数据 -> 字典
    NSDictionary *User_Data=[User_All objectForKey:@"data"];//All字典 -> Data字典

    NSString *Msg=[User_All objectForKey:@"msg"];
    if (Msg=@"ok") {
        NSLog(@"正确:%@",Msg);// 调出Data字典中TrueName
        NSString *Remember_code_app=[User_All objectForKey:@"remember_code_app"]; //令牌
        NSString *TrueName=[User_Data objectForKey:@"TrueName"]; //真实姓名
        NSString *studentKH=[User_Data objectForKey:@"studentKH"]; //学号
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        //保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
        [defaults setObject:Remember_code_app forKey:@"remember_code_app"];
        [defaults setObject:TrueName forKey:@"TrueName"];
        [defaults setObject:studentKH forKey:@"studentKH"];
        //强制让数据立刻保存
        [defaults synchronize];
        NSLog(@"用户：%@，学号：%@,令牌:%@",TrueName,studentKH,Remember_code_app);
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                            message:Msg
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//             //读取保存的数据
//             NSString *name=[defaults objectForKey:@"name"];
//             NSString *gender=[defaults objectForKey:@"gender"];
//             NSInteger age=[defaults integerForKey:@"age"];
//            double height=[defaults doubleForKey:@"height"];
//           //打印数据
//          NSLog(@"name=%@,gender=%@,age=%d,height=%.1f",name,gender,age,height);
        
    }
//
//    NSString *Remember_code_app=[User_All objectForKey:@"remember_code_app"];
//    NSLog(@"Msg:%@",Msg);// 调出Data字典中TrueName
//    NSLog(@"TrueName:%@",[User_Data objectForKey:@"TrueName"]);// 调出Data字典中TrueName
}

- (IBAction)DidEnd:(id)sender {
  [sender resignFirstResponder];
}




- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
    

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
