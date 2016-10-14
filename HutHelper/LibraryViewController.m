//
//  LibraryViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *views;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图书馆";
    NSString *Url_String=@"http://172.16.64.7:8080/opac/index";
    
    NSURL *url = [[NSURL alloc]initWithString:Url_String];
    [_views loadRequest:[NSURLRequest requestWithURL:url]];
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
