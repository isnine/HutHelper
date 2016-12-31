//
//  NoticeViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/13.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "NoticeViewController.h"
#import "JSONKit.h"
@interface NoticeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextView *Content;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        NSString *Url_String=@"http://www.wxz.name/data.json";
    NSURL *url             = [NSURL URLWithString: Url_String];//接口地址
    NSError *error         = nil;
    NSString *jsonString   = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];//Url -> String
    NSData* jsonData       = [jsonString dataUsingEncoding:NSUTF8StringEncoding];//地址 -> 数据
    NSDictionary *User_All = [jsonData objectFromJSONData];//数据 -> 字典
    NSString *title=[User_All objectForKey:@"title"];
    NSString *content=[User_All objectForKey:@"content"];
    if(User_All!=NULL){
    _Title.text            = title;
    _Content.text          = content;
    }
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
