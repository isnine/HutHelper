//
//  IMViewController.m
//  HutHelper
//
//  Created by Nine on 2017/4/26.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "IMViewController.h"
#import "UserService.h"
#import <BmobSDK/Bmob.h>
#import <BmobIMSDK/BmobIMSDK.h>
@interface IMViewController ()
@property (strong, nonatomic) NSMutableArray     *messagesArray;
@property (strong, nonatomic) BmobIM             *sharedIM;
@property (strong, nonatomic) BmobUser           *loginUser;
@property (strong, nonatomic) UIRefreshControl   *freshControl;
@property (assign, nonatomic) NSUInteger         page;
@property (assign, nonatomic) BOOL               finished;
@property (strong, nonatomic) BmobIMUserInfo *userInfo;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation IMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"私信";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    _dataArray= [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self registerIM];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerIM{
    BmobUser *user = [[BmobUser alloc] init];
    user.username = [Config getStudentKH];
    user.password = @"123456";
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:user.objectId];
            NSLog(@"注册成功");
        }else{
            [self LoginIM];
            NSLog(@"%@",error);
        }
    } ];
}
-(void)LoginIM{
    [BmobUser loginInbackgroundWithAccount:[Config getStudentKH]
                               andPassword:@"123456"
                                     block:^(BmobUser *user, NSError *error) {
                                         if (user) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:user.objectId];
                                             NSLog(@"登录成功");
                                             if ([BmobUser getCurrentUser]) {
                                                 NSLog(@"get完毕");
                                                 [UserService loadUsersWithDate:[NSDate date] completion:^(NSArray *array, NSError *error) {
                                                     if (error) {
                                                         NSLog(@"搜索错误");
                                                     }else{
                                                         if (array && array.count > 0) {
                                                            //NSArray *arrays = [[BmobIM sharedBmobIM] queryRecentConversation];
                                                             [self.dataArray setArray:array];
                                                          
                                                             NSLog(@"%@",array[0]);
                                                             [self sendMessage];
                                                         }
                                                       
                                                     }
                                                 }];
                                                 
                                             }else{
                                                 NSLog(@"get失败");
                                             }
                                             
                                         }else{
                                             NSLog(@"%@",error);
                                         }
                                     }];
    
}

-(void)sendMessage{
    self.userInfo = _dataArray[0];

    BmobIMConversation *conversation = [BmobIMConversation conversationWithId:self.userInfo.userId conversationType:BmobIMConversationTypeSingle];
    conversation.conversationTitle = self.userInfo.name;
    self.conversation = conversation;

    
    BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:@"123" attributes:nil];
    message.conversationType =  BmobIMConversationTypeSingle;
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    [self.messagesArray addObject:message];
    
    __weak typeof(self)weakSelf = self;
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"信息发送成功");
        }else{
            NSLog(@"%@",error);
        }
        
    }];
}

@end
