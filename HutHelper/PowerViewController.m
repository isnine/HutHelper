//
//  PowerViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/12.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "PowerViewController.h"
#import "JSONKit.h"
@interface PowerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Building;
@property (weak, nonatomic) IBOutlet UITextField *Room;

@end

@implementation PowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电费查询";
    UIColor *greyColor= [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Mark:(id)sender {
    NSString *Url_String_1=@"http://218.75.197.121:8888/api/v1/get/power/";
    NSString *Url_String_2=@"/";
    NSString *Build_String=_Building.text;
    NSString *Room_String=_Room.text;
    NSString *Url_String=[Url_String_1 stringByAppendingString:Build_String];
              Url_String=[Url_String stringByAppendingString:Url_String_2];
              Url_String=[Url_String stringByAppendingString:Room_String];
   
    NSURL *url = [NSURL URLWithString: Url_String]; //接口地址
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *User_All = [jsonData objectFromJSONData];//数据 -> 字典
    
    NSString *power_du=[User_All objectForKey:@"oddl"];
    NSString *power_money=[User_All objectForKey:@"prize"];
    
     NSLog(@"度数%@",power_du);
     NSLog(@"电费%@",power_money);
    
    NSString *power_String=@"剩余:";
    power_String=[power_String stringByAppendingString:power_du];
    NSString *power2_String=@"度\n余额:";
    NSString *power3_String=@"元";
    power_String=[power_String stringByAppendingString:power2_String];
    power_String=[power_String stringByAppendingString:power_money];
    power_String=[power_String stringByAppendingString:power3_String];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"查询成功"
                                                        message:power_String
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
}


@end
