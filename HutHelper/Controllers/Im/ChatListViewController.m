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
#import "ChatChoiceTableViewController.h"
#import "ChatUser.h"
@interface ChatListViewController()<UISearchBarDelegate,RCIMUserInfoDataSource>{
}
@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIControl *searchBg;
@property (nonatomic,copy) NSMutableArray *chatChoiceArray;
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
    //按钮
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_im_find"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
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
    //设置tableView样式
    self.conversationListTableView.separatorColor =
    RGB(223, 223, 223, 1);
    self.conversationListTableView.tableFooterView = [UIView new];
    //显示重连状态
    self.showConnectingStatusOnNavigatorBar=YES;
     //设置用户信息代理
     [[RCIM sharedRCIM] setUserInfoDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获得列表头像昵称
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    [APIRequest GET:[Config getApiImUserInfo:userId] parameters:nil
            success:^(id responseObject) {
                RCUserInfo *userInfo=[[RCUserInfo alloc]init];
                NSLog(@"list他人:%@",responseObject[@"data"][@"TrueName"]);
                userInfo.userId=userId;
                userInfo.name=responseObject[@"data"][@"TrueName"];
                userInfo.portraitUri=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,responseObject[@"data"][@"head_pic_thumb"]];
                return completion(userInfo);
            } failure:^(NSError *error) {
                NSLog(@"失败");
                return completion(nil);
            }];
}
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    NSLog(@"%@",model.targetId);
    conversationVC.title = model.conversationTitle;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
    
}
-(void)find{
    ChatChoiceTableViewController *chatChoiceTableViewController=[[ChatChoiceTableViewController alloc]init];
    [self.navigationController pushViewController:chatChoiceTableViewController animated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
}
-(void)loadData:(NSArray*)JSONArray{
    self.chatChoiceArray = [[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONArray) {
        NSLog(@"%@",eachDic);
        ChatUser *chatUser=[[ChatUser alloc]initWithDic:eachDic];
        [self.chatChoiceArray addObject:chatUser];
    }
}
// 将点击tableviewcell的时候收回 searchBar 键盘
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_searchBar resignFirstResponder];
    return indexPath;
}
// 滑动的时候 searchBar 回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
@end
