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
}

- (IBAction)Appscore:(id)sender {
    [Config showAppStore];
}
- (IBAction)helpBtn:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Web"];
    webViewController.urlString=@"http://hugongda.com:8888/home/post/39";
    webViewController.viewTitle=@"Q&A";
    [self.navigationController pushViewController:webViewController animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
