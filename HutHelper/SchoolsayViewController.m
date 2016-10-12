//
//  SchoolsayViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SchoolsayViewController.h"

@interface SchoolsayViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *Show;

@end

@implementation SchoolsayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"校园说说";
        NSURL *url = [[NSURL alloc]initWithString:@"http://love.zengheng.top:8888/moments"];
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
