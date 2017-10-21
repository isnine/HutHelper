//
//  LoginViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/17.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LoginViewController.h"
#import "WebViewController.h"
#import "LeftSortsViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "UMessage.h"
#import "MainPageViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "MBProgressHUD+MJ.h"
#import "User.h"
#import <RongIMKit/RongIMKit.h>

#import "zySheetPickerView.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *choiceBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *UtfSecCode;
@property (weak, nonatomic) IBOutlet UIImageView *UivSecCode;
@property (strong, nonatomic) AFHTTPSessionManager *AFHROM;

@property(nonatomic,assign)BOOL isEducation;
@end

@implementation LoginViewController

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (IBAction)Login:(id)sender {
    if (_isEducation) {
//        [Config saveEducationUserName:_UserName.text];
//        [Config saveEducationPassWord:_Password.text];
        _userNameStr=_UserName.text;
        _passWorldStr=_Password.text;
//        _userNameStr=@"2015143232";
//        _passWorldStr=@"ys0132";
        _secCode=_UtfSecCode.text;
         [self acquireViewStare];
        return;
    }
     [self.view endEditing:YES];
    NSString *UserName_String =[NSString stringWithFormat:@"%@",_UserName.text];
    NSString *Password_String =[NSString stringWithFormat:@"%@",_Password.text];
    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    if ([UserName_String isEqualToString:@""]||[Password_String isEqualToString:@""]) {
        HideAllHUD
        [MBProgressHUD showError:@"请输入账号密码" toView:self.view];
        return;
    }
    [APIRequest GET:[Config getApiLogin:UserName_String passWord:Password_String] parameters:nil
            success:^(id responseObject) {
                 HideAllHUD
        NSDictionary *userAll = [NSDictionary dictionaryWithDictionary:responseObject];
        NSString *msg=userAll[@"msg"];
        if ([msg isEqualToString: @"ok"])
        {
            [Config saveUser:userAll[@"data"]];
            [Config saveRememberCodeApp:userAll[@"remember_code_app"]];
            [Config saveCurrentVersion:[[[NSBundle mainBundle] infoDictionary]
                                        objectForKey:@"CFBundleShortVersionString"]];
            [Config addNotice];
            /**设置友盟标签&别名*/
            [Config saveUmeng];
            //如果是特殊用户
            if (Config.getTrueName ==nil) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                return;
            }
            //请求即时聊天服务的Token
                NSDictionary *dic=@{@"userid":Config.getUserId,
                                    @"name":Config.getTrueName
                                    };
                [APIRequest POST:[Config getApiImToken] parameters:dic
                         success:^(id responseObject) {
                             NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                             NSLog(@"%@",resultDictionary);
                             [Config saveImToken:resultDictionary[@"token"]];
                             [[RCIM sharedRCIM] connectWithToken:[Config getImToken]
                                                         success:^(NSString *userId) {
                                                             NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
                                                         } error:^(RCConnectErrorCode status) {
                                                             NSLog(@"私信模块登录错误，错误码:%ld");
                                                         } tokenIncorrect:^{
                                                             NSLog(@"Token错误,您无法使用私信功能,可尝试重新登录");
                                                         }];
                         }
                         failure:^(NSError *error) {
                             NSLog(@"Token获取失败,您无法使用私信功能,可尝试重新登录");
                         }];
            //返回主界面
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
        }
        else {
            NSString *Show_Msg=[msg stringByAppendingString:@",默认密码身份证后六位"];
            if ([msg isEqualToString:@"多次失败，请稍后再试，或修改密码"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码多次错误" message:msg preferredStyle:  UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"稍后再试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //点击按钮的响应事件；
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
                    webViewController.urlString=Config.getApiLoginReset;
                    webViewController.viewTitle=@"重置密码";
                    [self.navigationController pushViewController:webViewController animated:YES];
                }]];
                //弹出提示框；
                [self presentViewController:alert animated:true completion:nil];
            } else{
                [MBProgressHUD showError:Show_Msg toView:self.view];
            }
            
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络错误或超时" toView:self.view];
    }];
}
- (IBAction)touristBtn:(id)sender {
    NSArray * str  = @[@"游客",@"湖南工业大学",@"江苏理工学院"];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:str andHeadTitle:@"学校选择" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        if ([choiceString isEqualToString:@"游客"]) {
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"touristData" ofType:@"plist"];
            NSDictionary *userAll = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
            NSLog(@"%@",userAll);
            [Config saveUser:userAll[@"data"]];
            [Config saveRememberCodeApp:userAll[@"remember_code_app"]];
            [Config saveCurrentVersion:[[[NSBundle mainBundle] infoDictionary]
                                        objectForKey:@"CFBundleShortVersionString"]];
            [Config addNotice];
            [Config saveUmeng];
            [Config saveTourist:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
        }else if ([choiceString isEqualToString:@"江苏理工学院"]){
            [Config saveUrl:@"http://jwgl.jsut.edu.cn/(kerprnqgqy20pwmimmbrn3ax)"];
            _isEducation=true;
            _Password.placeholder=@"教务系统密码";
            _UtfSecCode.placeholder=@"验证码";
            _UtfSecCode.hidden=false;
            _UivSecCode.hidden=false;
            [_choiceBtn setTitle:@"江苏理工学院" forState: UIControlStateNormal];
             [self refreshSecCode];
        }else if ([choiceString isEqualToString:@"湖南工业大学"]){
//            [Config saveUrl:@"http://218.75.197.123:83"];
            [_choiceBtn setTitle:@"湖南工业大学" forState: UIControlStateNormal];
            _isEducation=false;
            _Password.placeholder=@"密 码";
            _UtfSecCode.placeholder=@"验证码";
            _UtfSecCode.hidden=true;
            _UivSecCode.hidden=true;
//            [self refreshSecCode];
        }else{
            
        }

        [pickerView dismissPicker];
    }];
    [pickerView show];
    
    
}



- (IBAction)End:(id)sender {
    [sender resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _UserName.placeholder=@"学 号";
    [_UserName setValue:RGB(202,202,202,1) forKeyPath:@"_placeholderLabel.textColor"];
    _Password.placeholder=@"密 码";
    [_Password setValue:RGB(202,202,202,1) forKeyPath:@"_placeholderLabel.textColor"];
    self.UserName.delegate=self;
    self.Password.delegate=self;
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //空白收起键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.UtfSecCode.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态
-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
- (IBAction)resetpassword:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
    webViewController.urlString=Config.getApiLoginReset;
    webViewController.viewTitle=@"重置密码";
    [self.navigationController pushViewController:webViewController animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

# pragma  mark - 代理方法
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
# pragma  mark - 教务系统
-(AFHTTPSessionManager*)AFHROM{
    if (!_AFHROM) {
        _AFHROM=[AFHTTPSessionManager manager];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        _AFHROM.responseSerializer.stringEncoding=enc;
        _AFHROM.requestSerializer.stringEncoding = enc;
        _AFHROM.responseSerializer=[AFHTTPResponseSerializer serializer];
        _AFHROM.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _AFHROM;
}
-(NSDictionary*)cookieDictionary{
    if (!_cookieDictionary) {
        //       NSDictionary *cookieDe=[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"cookie"];
        //       if(cookieDe) return cookieDe;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"kUrl"],@"/default2.aspx"]]];
        //  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
        //timeoutInterval:3];
        
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:nil
                                          error:nil];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies =[cookieJar cookies];
        _cookieDictionary= [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        //       _cookieDictionary=nil;
    }
    
    
    return _cookieDictionary;
    //获取cookie
}

/**刷新验证码*/
-(void)refreshSecCode{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *UrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",[Config getUrl],@"/CheckCode.aspx?"]]];
        //提交Cookie，上一行的NSURLRequest被改为NSMutableURLRequest
        if(self.cookieDictionary) {
            [UrlRequest setHTTPShouldHandleCookies:NO];
            [UrlRequest setAllHTTPHeaderFields:self.cookieDictionary];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/gif"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [[manager dataTaskWithRequest:UrlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                self.UivSecCode.image = [UIImage imageWithData:responseObject];
            } else {
               // [MBProgressHUD showMessage:@"验证码刷新失败" toView:self.view];
            }
        }] resume];

    });
    
    
}
-(void)acquireViewStare{
    [MBProgressHUD showMessage:@"登录中" toView:self.view];
    [self.AFHROM GET:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"] parameters:nil
             success:^(NSURLSessionTask *operation, id responseObject) {
                 NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                 NSData *data=responseObject;
                 NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                 NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                 NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                 TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                 NSArray *elements  = [xpathParser searchWithXPathQuery:@"//input[@name='__VIEWSTATE']"];
                 
                 NSUInteger count=[elements count];
                 for (int i=0; i<count; i++) {
                     TFHppleElement *element = [elements objectAtIndex:i];
                     self.viewState=[element objectForKey:@"value"];
                     NSLog(@"1提取到得viewstate为%@",self.viewState);
                     [self logins];
                 }
                 HideAllHUD
             } failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", [error debugDescription]);
             }];
}
-(void)logins{
    //[self.view showHUDWithText:@"登录中" hudType:kXHHUDLoading animationType:kXHHUDFade delay:0];
    NSDictionary *parameters = @{@"__VIEWSTATE":self.viewState,@"txtUserName": _userNameStr,@"TextBox2":_passWorldStr,@"txtSecretCode":_secCode,@"RadioButtonList1":@"学生",@"Button1":@""};
    [self.AFHROM POST:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"] parameters:parameters
              success:^(NSURLSessionTask *operation, id responseObject) {
                  NSURL *denglu=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/default2.aspx"]];
                  if ([operation.response.URL isEqual:denglu]) {
                      //  [self miMaCuoWu];
                      [self refreshSecCode];
                      [MBProgressHUD showError:@"登录错误，账号/密码/验证码错误" toView:self.view];
                  }else{
                      NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                      NSData *data=responseObject;
                      NSString *tansData=[[NSString alloc]initWithData:data encoding:enc];
//                      NSLog(@"biaodantijiaochenggong:%ld，%@",(long)operation.response.statusCode,operation.responseString);//提交表单
                      NSString *utf8HtmlStr = [tansData stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                      NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                      [self anayseLoginData:htmlDataUTF8];
                    //  [self.stepsController showNextStep];
                  }
              } failure:^(NSURLSessionTask *operation, NSError *error) {
                  [self refreshSecCode];
                  [MBProgressHUD showError:@"登录错误，网络无法连接"];
              }];
}
-(void)anayseLoginData:(NSData*)data{
    TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//span[@id='xhxm']"];
    // Access the first cell
    NSUInteger count=[elements count];
    for (int i=0; i<count; i++) {
        TFHppleElement *element = [elements objectAtIndex:i];
        // Get the text within the cell tag
        NSString *content = [element text];
        NSString *ta=[element tagName];
        NSLog(@"学号姓名为%@%@%@",content,ta,[content substringToIndex:[content length]-2]);
        NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"touristData" ofType:@"plist"];
        NSMutableDictionary *userAllDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        userAllDic[@"data"][@"TrueName"]=content;
        userAllDic[@"data"][@"username"]=content;
        userAllDic[@"data"][@"school"]=@"江苏理工学院";
        userAllDic[@"data"][@"dep_name"]=@"江苏理工学院";
        NSDictionary *userAll=[NSDictionary dictionaryWithDictionary:userAllDic];
        NSLog(@"%@",userAll);
        [Config saveUser:userAll[@"data"]];
        [Config saveRememberCodeApp:userAll[@"remember_code_app"]];
        [Config saveCurrentVersion:[[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleShortVersionString"]];
        [Config addNotice];
        [Config saveUmeng];
        [Config saveTourist:YES];
        
    }
    [self acquireData];
}

-(void)acquireData{
    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
    //  MainInterfaceAppDelegate *mainDele=[[UIApplication sharedApplication]delegate];
    if(_userNameStr!=nil&&_passWorldStr!=nil){
        NSDictionary *parameters2 = @{@"xh":_userNameStr,@"xm":_passWorldStr,@"gnmkdm":@"N121603"};
        manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
        [self.AFHROM GET:[NSString stringWithFormat:@"%@%@",[Config getUrl],@"/xskbcx.aspx?"] parameters:parameters2
                 success:^(NSURLSessionTask *operation, id responseObject) {
                     NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                     
                     NSData *data=responseObject;
                     NSString *transStr=[[NSString alloc]initWithData:data encoding:enc];
                     
                     NSLog(@"课表数据：%@",transStr);
                     NSString *utf8HtmlStr = [transStr stringByReplacingOccurrencesOfString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
                     NSData *htmlDataUTF8 = [utf8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                     TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:htmlDataUTF8];
                     NSArray *elements  = [xpathParser searchWithXPathQuery:@"//table[@id='Table1']/tr/td/child::text()"];
                     
                     // Access the first cell
                     NSUInteger count=[elements count];
                     NSMutableArray *allContents=[NSMutableArray array];
                     for (int i=0; i<count; i++) {
                         
                         TFHppleElement *element = [elements objectAtIndex:i];
                         
                         // Get the text within the cell tag
                         NSString *nodeContent=[element content];
                         //NSLog(@"课程为%@%@",nodeContent,ta);
                         NSLog(@"%@",nodeContent);
                         [allContents addObject:nodeContent];
                     }
                     
                     [self sortData:allContents];
                     NSLog(@"---------整理后---------------");
                     
                     NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                     NSMutableArray *arry=[[NSMutableArray alloc]init];
                     int j=0;
                     for(int i=0;j<allContents.count;i++){
                         NSString *str =allContents[j];
                         if(i%4==0) {
                             dic[@"name"]=str;
                         }
                         if(i%4==1) {
                             {
                                 if ([str rangeOfString:@"周一"].location!=NSNotFound){
                                     dic[@"xqj"] = @"1";
                                 }else if ([str rangeOfString:@"周二"].location!=NSNotFound){
                                     dic[@"xqj"] = @"2";
                                 }else if ([str rangeOfString:@"周三"].location!=NSNotFound){
                                     dic[@"xqj"] = @"3";
                                 }else if ([str rangeOfString:@"周四"].location!=NSNotFound){
                                     dic[@"xqj"] = @"4";
                                 }else if ([str rangeOfString:@"周五"].location!=NSNotFound){
                                     dic[@"xqj"] = @"5";
                                 }else if ([str rangeOfString:@"周六"].location!=NSNotFound){
                                     dic[@"xqj"] = @"6";
                                 }else if ([str rangeOfString:@"周日"].location!=NSNotFound){
                                     dic[@"xqj"] = @"7";
                                 }
                             }
                             
                             //取开始周
                             NSRange testRange = [str rangeOfString:@"{"];
                             NSRange test2 = testRange;
                             test2.location = test2.location + 3;;
                             if ([[str substringWithRange:test2]isEqualToString:@"-" ]) {
                                 testRange.location = testRange.location + 2;
                                 dic[@"qsz"] = [str substringWithRange:testRange];
                             }
                             else{
                                 testRange.location = testRange.location +2;
                                 testRange.length = testRange.length +1;
                                 dic[@"qsz"] = [str substringWithRange:testRange];
                             }
                             
                             //取结束周
                             testRange = [str rangeOfString:@"-"];
                             test2 = testRange;
                             test2.location = test2.location + 2;;
                             if ([[str substringWithRange:test2]isEqualToString:@"周" ]) {
                                 testRange.location = testRange.location + 1;
                                 dic[@"jsz"] = [str substringWithRange:testRange];
                             }
                             else{
                                 testRange.location = testRange.location +1;
                                 testRange.length = testRange.length +1;
                                 dic[@"jsz"] = [str substringWithRange:testRange];
                             }
                             
                             //是否单双周
                             if ([str rangeOfString:@"单周"].location!=NSNotFound) {
                                 dic[@"dsz"]  = @"单";
                             }else if ([str rangeOfString:@"双周"].location!=NSNotFound){
                                 dic[@"dsz"]  = @"双";
                             }else{
                                 dic[@"dsz"] = @"";
                             }
                             
                             //第几节
                             if ([str rangeOfString:@"第1,2节"].location!=NSNotFound){
                                 dic[@"djj"] = @"1";
                             }else if ([str rangeOfString:@"第3,4节"].location!=NSNotFound){
                                 dic[@"djj"] = @"3";
                             }else if ([str rangeOfString:@"第5,6节"].location!=NSNotFound){
                                 dic[@"djj"] = @"5";
                             }else if ([str rangeOfString:@"第7,8节"].location!=NSNotFound){
                                 dic[@"djj"] = @"7";
                             }else if ([str rangeOfString:@"第9,10节"].location!=NSNotFound){
                                 dic[@"djj"] = @"9";
                             }else if ([str rangeOfString:@"第11,12节"].location!=NSNotFound){
                                 dic[@"djj"] = @"11";
                             }
                         }
                         if (i%4==2) {
                             dic[@"teacher"]=str;
                         }
                         if (i%4==3) {
                             // NSLog(@"%ld",results.count);
                             NSString *pattern = @"[0-9]";
                             // 1.1将正则表达式设置为OC规则
                             NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
                             // 2.利用规则测试字符串获取匹配结果
                             NSArray *results = [regular matchesInString:str options:0 range:NSMakeRange(0,str.length)];
                             if (results.count==1||(results.count<3&&!([str rangeOfString:@"体育"].location!=NSNotFound))) {
                                 //NSLog(@"非正常情况%d",i);
                                 dic[@"room"]=@"";
                                 str=@"";
                                 j--;
                             }
                             dic[@"room"] = str;
                             NSDictionary *dics = [NSDictionary dictionaryWithDictionary:dic];
                             [arry addObject:dics];
                             [dic removeAllObjects];
                         }
                         
                         NSLog(@"%@",str);
                         if (i%4==3) {
                             NSLog(@"---------");
                         }
                         j++;
                     }
                     NSArray *myArray = [arry copy];
                     [Config saveCourse:myArray];
                     
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回上一个View
                     
                 } failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", [error debugDescription]);
                 }];//获取登陆后的网页
    }
}
-(void)sortData:(NSMutableArray*)arrayData{
    __block NSMutableIndexSet* indexSet=[NSMutableIndexSet indexSet];
    [arrayData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *string=obj;
        if([string isEqualToString:@" "]||[string hasPrefix:@"星期"]||[string isEqualToString:@"上午"]||[string isEqualToString:@"下午"]||[string isEqualToString:@"早晨"]||[string isEqualToString:@"晚上"]){
            [indexSet addIndex:idx];
        }
        if([string hasPrefix:@"第"]&&[string hasSuffix:@"节"]){
            [indexSet addIndex:idx];
        }
        if([string isEqualToString:@"时间"]){
            [indexSet addIndex:idx];
        }
        if ([string hasPrefix:@"2014年"]) {
            [indexSet addIndex:idx];
            [indexSet addIndex:idx+1];
        }
        
    }];
    [arrayData removeObjectsAtIndexes:indexSet];
}
@end

