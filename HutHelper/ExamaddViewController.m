//
//  ExamaddViewController.m
//  HutHelper
//
//  Created by nine on 2016/11/21.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "ExamaddViewController.h"

@interface ExamaddViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *OpenCet;
@end

@implementation ExamaddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加考试";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *examcet=[defaults objectForKey:@"examcet"];
    if ([examcet isEqualToString:@"打开"]) {
        [_OpenCet setOn:YES animated:NO];
    }
    else
        [_OpenCet setOn:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Cet:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (_OpenCet.isOn==1) {
        [defaults setObject:@"打开" forKey:@"examcet"];
        [defaults synchronize];
    }
    else
    {
        [defaults setObject:@"关闭" forKey:@"examcet"];
        [defaults synchronize];
    }
 
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
