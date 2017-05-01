//
//  RecentViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentTableViewCell.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
//#import "ChatViewController.h"


@interface RecentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation RecentViewController

static NSString *RecentCellID = @"RecentCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentConversations) name:kNewMessageFromer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecentConversations) name:kNewMessagesNotifacation object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([BmobUser getCurrentUser]) {
        [self loadRecentConversations];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSubviews{
    self.tableView.rowHeight = 75;
    self.tableView.backgroundColor = kDefaultViewBackgroundColor;
}


-(void)loadRecentConversations{
    NSArray *array = [[BmobIM sharedBmobIM] queryRecentConversation];
    if (array && array.count > 0) {
        [self.dataArray setArray:array];
        [self.tableView reloadData];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecentCellID];
    
    if(cell == nil) {
        cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecentCellID];
    }
    
    BmobIMConversation *conversation = self.dataArray[indexPath.row];
    [cell setEntity:conversation];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BmobIMConversation *conversation = self.dataArray[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Contacts" bundle:nil];
//    ChatViewController *cvc = [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
//    cvc.conversation = conversation;
 //   [self.navigationController pushViewController:cvc animated:YES];
    
}

@end
