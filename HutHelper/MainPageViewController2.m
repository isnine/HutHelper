//
//  MainPageViewController2.m
//  HutHelper
//
//  Created by nine on 2016/11/15.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "MainPageViewController2.h"
#import "DayViewController.h"
#import "LostViewController.h"
#import "AppDelegate.h"
@interface MainPageViewController2 ()

@end

@implementation MainPageViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title                 = @"更多";
    UIColor *greyColor                        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor                 = greyColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Day:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController2 *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Day"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}

- (IBAction)Lost:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController2 *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Lost"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}


@end
