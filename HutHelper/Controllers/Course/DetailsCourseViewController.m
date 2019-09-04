//
//  DetailsCourseViewController.m
//  HutHelper
//
//  Created by 张驰 on 2019/9/4.
//  Copyright © 2019 nine. All rights reserved.
//

#import "DetailsCourseViewController.h"
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
    self.navigationItem.title = @"课程详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _courseName.text = _name;
    _courseName.numberOfLines = 0;
    _courseRoom.text = _room;
    _courseTime.text = _time;
    _courseTeacher.text = _teacher;
    _courseWeek.text = _Week;
    
}
@end
