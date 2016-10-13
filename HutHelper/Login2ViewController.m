//
//  Login2ViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "Login2ViewController.h"

@interface Login2ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation Login2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    NSString *Url_String=@"http://218.75.197.121:8888/auth/resetPass";

    NSURL *url = [[NSURL alloc]initWithString:Url_String];
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*

*/

@end
