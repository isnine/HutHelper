//
//  CourseSetViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "CourseSetViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface CourseSetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *OpenClass;
@property (weak, nonatomic) IBOutlet UISwitch *OpenXp;


@end

@implementation CourseSetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    if ([autoclass isEqualToString:@"打开"]) {
           [_OpenClass setOn:YES animated:NO];
    }
    else
        [_OpenClass setOn:NO animated:NO];

    NSString *OpenXp=[defaults objectForKey:@"show_xp"];
    if ([OpenXp isEqualToString:@"打开"]) {
        [_OpenXp setOn:YES animated:NO];
    }
    else
        [_OpenXp setOn:NO animated:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)Set:(id)sender {

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (_OpenClass.isOn==1) {
        [defaults setObject:@"打开" forKey:@"autoclass"];
        [defaults synchronize];
    }
    else
    {
        [defaults setObject:@"关闭" forKey:@"autoclass"];
        [defaults synchronize];
    }
}

- (IBAction)SetXP:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (_OpenXp.isOn==1) {
        [defaults setObject:@"打开" forKey:@"show_xp"];
        [defaults synchronize];
    }
    else
    {
        [defaults setObject:@"关闭" forKey:@"show_xp"];
        [defaults synchronize];
    }
}





@end
