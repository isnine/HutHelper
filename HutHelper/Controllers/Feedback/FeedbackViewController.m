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
#import "AFNetworking.h"

#import "HutHelper-Swift.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Mail;
@property (weak, nonatomic) IBOutlet UITextView *Content;
@property (weak, nonatomic) IBOutlet UILabel *wordLab;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title          = @"反馈";
    self.view.backgroundColor          = RGB(239, 239, 239, 1);
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _Content.text = @"请输入15个字以上的问题描述以便我们提供更好的帮助";
    _Content.textColor = [UIColor lightGrayColor];
   // [_Mail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _Content.delegate=self;
    _Mail.delegate=self;
        [self setTitle1];
            
    }

    - (void) setTitle1{
            //self.navigation_bar.isShadowHidden = true;
            //self.navigation_bar.alpha = 0;
            /**按钮*/
            UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(5), 0, SYReal(25), SYReal(25))];
            UIView *rightButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
            
            mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
            [rightButtonView1 addSubview:mainAndSearchBtn];
            [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
            [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightCunstomButtonView1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView1];
            self.navigation_item.leftBarButtonItem  = rightCunstomButtonView1;
        self.navigation_item.title = @"反馈";
        }
    // 返回按钮按下
    - (void)backBtnClicked:(UIButton *)sender{
            [self.navigationController popViewControllerAnimated:YES];
    }

- (IBAction)contactMe:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=\(1525163730)&version=1&src_type=web"]];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入15个字以上的问题描述以便我们提供更好的帮助"]) {
        textView.text=@"";
    }
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //用户结束输入
    [textField  resignFirstResponder];
    return  YES;
    }
//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    self.wordLab.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    //字数限制操作
    if (textView.text.length >=200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.wordLab.text = @"200/200";
    }
 
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
        [MBProgressHUD showError:@"联系方式与反馈内容不能为空" toView:self.view];
    }
    else{
        NSDictionary *dic=@{@"email":_Mail.text,
                            @"content":[NSString stringWithFormat:@"%@ iOS(%@) %@",Config.getStudentKH,Config.getCurrentVersion,_Content.text]
                            };
        
        [MBProgressHUD showMessage:@"发送中" toView:self.view];
        [APIRequest POST:Config.getApiFeedback parameters:dic success:^(id responseObject) {
    
            [Config saveUmeng];
            [Config pushViewController:@"Feedback2"];
            HideAllHUD
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"发送超时，请重试" toView:self.view];
            HideAllHUD
        }];
        
    }
    
    
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self animateTextField: textField up: YES];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//
//{
//    [self animateTextField: textField up: NO];
//}

//- (void) animateTextField: (UITextField*) textField up: (BOOL) up
//
//{
//    const int movementDistance = SYReal(120); // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    int movement = (up ? -movementDistance : movementDistance);
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//
//}
@end
