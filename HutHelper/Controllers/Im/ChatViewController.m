//
//  ChatViewController.m
//  HutHelper
//
//  Created by nine on 2017/7/30.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置当前用户信息
    RCUserInfo *currentUserInfo =[[RCIM sharedRCIM] currentUserInfo];
    currentUserInfo.userId=[Config getUserId];
    currentUserInfo.name=[Config getTrueName];
    if ((!Config.getHeadPicThumb)||[Config.getHeadPicThumb isEqualToString:@""]) {
        if ([Config.getSex isEqualToString:@"男"]) {
            currentUserInfo.portraitUri=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,@"\/head\/head-boy.png"];
        }else{
            currentUserInfo.portraitUri=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,@"\/head\/head-girl.png"];
        }
    }else{
        currentUserInfo.portraitUri=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,Config.getHeadPicThumb];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)didTapCellPortrait:(NSString *)userId{
//
//}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageContent {
    NSLog(@"%s",__FUNCTION__);
    //可以在这里修改将要发送的消息
    if ([messageContent isMemberOfClass:[RCTextMessage class]]) {
        // RCTextMessage *textMsg = (RCTextMessage *)messageContent;
        // textMsg.extra = @"";
    }
    return messageContent;
}

@end
