//
//  DetailsCourseViewController.m
//  HutHelper
//
//  Created by 张驰 on 2019/9/4.
//  Copyright © 2019 nine. All rights reserved.
//

#import "DetailsCourseViewController.h"

#import "HutHelper-Swift.h"

@interface DetailsCourseViewController ()
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *courseRoom;
@property (weak, nonatomic) IBOutlet UILabel *courseTeacher;
@property (weak, nonatomic) IBOutlet UILabel *courseWeek;
@end


@implementation DetailsCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigation_item.title = @"课程详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _courseName.text = _name;
    _courseName.numberOfLines = 0;
    _courseRoom.text = _room;
    _courseTime.text = _time;
    _courseTeacher.text = _teacher;
    _courseWeek.text = _Week;
    
    [self setTitle];
    
}

- (void) setTitle{
    self.navigation_bar.isShadowHidden = true;
    self.navigation_bar.alpha = 0;
    /**按钮*/
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYReal(5), 0, SYReal(25), SYReal(25))];
    UIView *rightButtonView1 = [[UIView alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    
    mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20,0, 40, 40)];
    [rightButtonView1 addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_back"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView1];
    self.navigation_item.leftBarButtonItem  = rightCunstomButtonView1;
}
// 返回按钮按下
- (void)backBtnClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
