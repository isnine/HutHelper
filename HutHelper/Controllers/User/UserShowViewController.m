//
//  UserShowViewController.m
//  HutHelper
//
//  Created by nine on 2017/9/3.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "UserShowViewController.h"

@interface UserShowViewController ()

@end

@implementation UserShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_user_bcg"]];
    [self draw];
    // Do any additional setup after loading the view.
}
-(void)draw{
    UIView *whitebackground = [[UIView alloc] init];
    whitebackground.frame = CGRectMake(SY_Real(27), SY_Real(196), SY_Real(321), SY_Real(275));
    whitebackground.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self.view addSubview:whitebackground];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(SY_Real(145), SY_Real(288.5), SY_Real(59.5), SY_Real(26.5));
    label.text = @"au小鹿";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:19];
     [self.view addSubview:label];
    
//    UIButton *imBtn = [[UIButton alloc] init];
//    imBtn.frame = CGRectMake(84, 385, 207, 35);
//    imBtn.imageView=[]
//    [self.view addSubview:imBtn];
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
