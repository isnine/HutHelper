//
//  AboutViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/11.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "AboutViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "LeftSortsViewController.h"
#import "WebViewController.h"
#import <StoreKit/StoreKit.h>
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UITextView *aboutText;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // Do any additional setup after loading the view from its nib.
    NSString *app_Version =[NSString stringWithFormat:@"%@(%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] ;
   _version.text=app_Version;
    //返回箭头样式
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //大小
    self.aboutText.font=[UIFont systemFontOfSize:SYReal(15)];
}

- (IBAction)Appscore:(id)sender {
    [Config showAppStore];
}
- (IBAction)helpBtn:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
    webViewController.urlString=[NSString stringWithFormat:@"%@/home/post/39",Config.apiIndex];
    webViewController.viewTitle=@"帮助";
    [self.navigationController pushViewController:webViewController animated:YES];
}
- (IBAction)contactMe:(id)sender {
  //  if ([Config isTourist]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你可以通过QQ245328522与我联系，因大三实习紧张，仅接受iOS端上卡顿/崩溃等app的问题。账号/课表/考试计划/等其他问题请在反馈中留言" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:true completion:nil];
//    }
//    ChatViewController *conversationVC = [[ChatViewController alloc]init];
//    conversationVC.conversationType = ConversationType_PRIVATE;
//    conversationVC.targetId = @"15198";
//    conversationVC.title = @"开发者";
//    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (IBAction)userPermitBtn:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
    webViewController.urlString=[NSString stringWithFormat:@"%@/home/post/40",Config.apiIndex];
    webViewController.viewTitle=@"用户许可协议及免责声明";
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
