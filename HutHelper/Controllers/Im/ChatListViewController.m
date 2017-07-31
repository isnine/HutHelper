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
@interface ChatListViewController()<UISearchBarDelegate,RCIMUserInfoDataSource>{
}
@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIControl *searchBg;
@end

@implementation ChatListViewController
//- (UISearchBar *)searchBar{
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
//        
//    }
//    return _searchBar;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题设置
    self.navigationItem.title=@"私信";
    //搜索栏
    self.searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width,SYReal(60))];
    self.searchBar.delegate = self;
    self.searchBar.placeholder=@"搜索对方的姓名";
    self.searchBar.barTintColor=RGB(240, 240, 240, 1);
    self.headerView= [[UIView alloc]initWithFrame:CGRectMake(0,0,DeviceMaxWidth,SYReal(60))];
    [self.headerView addSubview:self.searchBar];
    self.conversationListTableView.delegate=self;
    self.conversationListTableView.tableHeaderView =self.headerView;
    [self.searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBar sizeToFit];
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
    //设置tableView样式
    self.conversationListTableView.separatorColor =
    RGB(223, 223, 223, 1);
    self.conversationListTableView.tableFooterView = [UIView new];
    //显示重连状态
    self.showConnectingStatusOnNavigatorBar=YES;
}
//-(void)viewWillAppear:(BOOL)animated{
//
//}
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
                return completion(nil);
            }];
    
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
    conversationVC.title = model.conversationTitle;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSDictionary *dic=@{
                        @"name":[searchBar text]
                        };
    [APIRequest POST:[Config getApiImStudent] parameters:dic
             success:^(id responseObject) {
                 NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 NSArray *resultArray   = [resultDictionary objectForKey:@"data"];
                 NSLog(@"%@",resultArray[0]);
                 
                 if (resultArray.count==1) {
                     ChatViewController *conversationVC = [[ChatViewController alloc]init];
                     conversationVC.conversationType = ConversationType_PRIVATE;
                     conversationVC.targetId = [resultArray[0] objectForKey:@"id"];
                     conversationVC.title = [searchBar text];
                     [self.navigationController pushViewController:conversationVC animated:YES];
                 }else{
                     NSLog(@"多个用户");
                 }

             }
             failure:^(NSError *error) {
                 NSLog(@"请求失败");
             }];
    

    
    NSLog(@"search text :%@",[searchBar text]);
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
