//
//  SetViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *OpenClass;


@end

@implementation SetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    UIColor *greyColor= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    if ([autoclass isEqualToString:@"打开"]) {
           [_OpenClass setOn:YES animated:NO];
    }
    else
        [_OpenClass setOn:NO animated:NO];
    
    
   
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
    
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    if ([autoclass isEqualToString:@"打开"]) {
        NSLog(@"Ture");
    }
    else
        NSLog(@"Flas");
}



@end
