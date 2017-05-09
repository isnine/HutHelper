//
//  FeedbackViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackResultViewController.h"
#import "CourseViewController.h"
#import "AppDelegate.h"
#import "User.h"

#import "MBProgressHUD+MJ.h"

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
    _Mail.delegate=self;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text=@"";
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //用户结束输入
    [textField  resignFirstResponder];
    return  YES;
    }

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (IBAction)Submit:(id)sender {
    
    if ([_Mail.text isEqualToString:@""]||[_Content.text isEqualToString:@""]||[_Content.text isEqualToString:@"请输入反馈意见"]) {
        [MBProgressHUD showError:@"联系方式与反馈内容不能为空"];
    }
    else{
        NSURL * url                        = [NSURL URLWithString:Config.getApiFeedback];
        NSString *str1=@"email=";
        NSString *Mail_String              = _Mail.text;
        NSString *str2=@"&content=";
        NSString *Content_String           = _Content.text;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *studentKH=Config.getStudentKH;
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
        
        [Config pushViewController:@"Feedback2"];
        
    }
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const int movementDistance = SYReal(160); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}
@end
