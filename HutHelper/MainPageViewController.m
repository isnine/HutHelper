//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "HomeWorkViewController.h"
#import "ClassViewController.h"
#import "PowerViewController.h"
#import "LibraryViewController.h"
#import "NoticeViewController.h"
#import "SchoolsayViewController.h"
#import "SchoolHandViewController.h"
#import "DayViewController.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Scontent;


@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"主界面";
    UIColor *greyColor= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];   //标题字体颜色

    

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    //-----是否打开课程表----//
   NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   NSArray *array = [defaults objectForKey:@"array"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    //-----是否打开课程表----//
  
    
}

- (void) openOrCloseLeftList 
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
        
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
    //    LoginViewController *vb = [[LoginViewController alloc] init];
    //    [tempAppDelegate.mainNavigationController pushViewController:vb animated:NO];
    
}

- (IBAction)Test:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *name=[defaults objectForKey:@"TrueName"];
    NSString *gender=[defaults objectForKey:@"studentKH"];

    if(gender==@"(null)"){
          NSLog(@"no");
    }
    //打印数据
    NSLog(@"name=%@,gender=%@,",name,gender);

}

- (IBAction)ClassFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults objectForKey:@"array"];
    if(array!=NULL){
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}

- (IBAction)HomeWork:(id)sender { //作业界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *remember_code_app=[defaults objectForKey:@"remember_code_app"];
    
  
    HomeWorkViewController *vc = [[HomeWorkViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(remember_code_app!=NULL){    //判断是否已登录
         [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请先登录"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    
    
}
- (IBAction)Power:(id)sender {
    PowerViewController *Power = [[PowerViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.mainNavigationController pushViewController:Power animated:NO];
}
- (IBAction)SchoolSay:(id)sender {
    SchoolsayViewController *Schoolsay = [[SchoolsayViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:Schoolsay animated:NO];
}

- (IBAction)SchoolHand:(id)sender {
    SchoolHandViewController *SchoolHand = [[SchoolHandViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:SchoolHand animated:NO];
}
- (IBAction)Score:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法查询"
                                                        message:@"请等待新版本"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}


- (IBAction)Day:(id)sender {
    DayViewController *day = [[DayViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:day animated:NO];
    
}
- (IBAction)Notice:(id)sender {
    NoticeViewController *notice = [[NoticeViewController alloc] init];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:notice animated:NO];
}
- (IBAction)Library:(id)sender {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"图书馆需要内网环境，连接工大的Wifi后才能使用"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        LibraryViewController *library = [[LibraryViewController alloc] init];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         [tempAppDelegate.mainNavigationController pushViewController:library animated:NO];
}


@end
