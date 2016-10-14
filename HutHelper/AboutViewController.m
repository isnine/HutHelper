//
//  AboutViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/11.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"关于";
    UIColor *greyColor= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)a:(id)sender {
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:2 forKey:@"tes"];
    
}
- (IBAction)b:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger *as = [defaults integerForKey:@"tes"];
    NSLog(@"%d",(short)as+1);
}


@end
