//
//  ChatListViewController.m
//  HutHelper
//
//  Created by nine on 2017/7/29.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "ChatListViewController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "ChatViewController.h"
@interface ChatListViewController(){
}

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题设置
    self.navigationItem.title=@"私信";
    //返回箭头
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
//    if (conversationModelType ==RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
//        ChatListViewController *temp=[[ChatListViewController alloc]init];
//        NSArray *array=[NSArray arrayWithObjects:[NSNumber numberWithInt:model.conversationType] ];
//        [temp setDisplayConversationTypes:array];
//        [temp setCollectionConversationType:nil];
//        temp.isEnteredToCollectionViewController=YES;
//        [self.navigationController pushViewController:temp animated:YES];
//    }
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    NSLog(@"%@",model.targetId);
    conversationVC.title = @"私信";
    
    [self.navigationController pushViewController:conversationVC animated:YES];
        
}


@end
