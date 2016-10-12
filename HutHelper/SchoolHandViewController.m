//
//  SchoolHandViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SchoolHandViewController.h"

@interface SchoolHandViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;

@end

@implementation SchoolHandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园二手";
    NSURL *url = [[NSURL alloc]initWithString:@"http://love.zengheng.top:8888/trade/goods"];
    [_Show loadRequest:[NSURLRequest requestWithURL:url]];
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
