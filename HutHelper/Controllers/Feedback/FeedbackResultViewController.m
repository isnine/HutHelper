//
//  FeedbackResultViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "FeedbackResultViewController.h"

@interface FeedbackResultViewController ()

@end

@implementation FeedbackResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"反馈";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnhome:(id)sender {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)] animated:YES];  //返回Home
}
- (IBAction)returnfeed:(id)sender {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
}



@end
