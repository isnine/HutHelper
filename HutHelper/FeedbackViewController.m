//
//  FeedbackViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Feedback2ViewController.h"
#import "ClassViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "YYModel.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"
@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Mail;
@property (weak, nonatomic) IBOutlet UITextView *Content;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title          = @"反馈";
    UIColor *greyColor                 = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor          = greyColor;

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _Content.text = @"请输入反馈意见";
    _Content.textColor = [UIColor lightGrayColor];
    _Content.delegate=self;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Submit:(id)sender {
    
    if ([_Mail.text isEqualToString:@""]||[_Content.text isEqualToString:@""]||[_Content.text isEqualToString:@"请输入反馈意见"]) {
        [MBProgressHUD showError:@"联系方式与反馈内容不能为空"];
    }
    else{
    NSURL * url                        = [NSURL URLWithString:API_FEEDBACK];
    NSString *str1=@"email=";
    NSString *Mail_String              = _Mail.text;
    NSString *str2=@"&content=";
    NSString *Content_String           = _Content.text;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *studentKH=user.studentKH;
    if(studentKH==NULL){
        str2=@"&content= ";
    }
    else
    {
        str2=[str2 stringByAppendingString:studentKH];
        str2=[str2 stringByAppendingString:@" iOS "];
    }
    NSString *str1_Mail_String=[str1 stringByAppendingString:Mail_String];
    NSString *str1_Mail_String_str2=[str1_Mail_String stringByAppendingString:str2];
    NSString *str=[str1_Mail_String_str2 stringByAppendingString:Content_String];

    NSMutableURLRequest * request      = [NSMutableURLRequest requestWithURL:url];
        //设置请求方式(默认的是get方式)
    request.HTTPMethod                 = @"POST";//使用大写规范
        //设置请求参数
    request.HTTPBody                   = [str dataUsingEncoding:NSUTF8StringEncoding];
        //创建NSURLConnection 对象用来连接服务器并且发送请求
    NSURLConnection * conn   = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Feedback2"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }


}

@end
