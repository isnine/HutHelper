//
//  SystemMessageViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/20.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "MessageService.h"
#import "BmobIMDemoPCH.h"
#import "SystemTableViewCell.h"
#import "UserService.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    _dataArray = [[NSMutableArray alloc] init];
    [self loadMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSubviews{
  //  [self setDefaultLeftBarButtonItem]
    ;    self.view.backgroundColor = kDefaultViewBackgroundColor;
    self.tableView.backgroundColor = kDefaultViewBackgroundColor;
    self.tableView.rowHeight = 60;
    self.navigationItem.title = @"好友通知";
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)loadMessages{
    [MessageService inviteMessages:[NSDate date] completion:^(NSArray *array, NSError *error) {
        if (error) {
 //           [self showInfomation:error.localizedDescription];
        }else{
            if (array && array.count > 0) {
                [self.dataArray setArray:array];
                [self.tableView reloadData];
            }
        }
    }];

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
    static NSString *cellIdentifier = @"SystemMessageCellID";
    
    SystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[SystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SysMessage *msg = self.dataArray[indexPath.row];
    if (msg.type.intValue == SystemMessageContactAdd) {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@请求添加您为好友",msg.fromUser.username];
        cell.replyButton.tag = indexPath.row;
        [cell.replyButton addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
        cell.replyButton.hidden = NO;
    }else{
        cell.contentLabel.text = [NSString stringWithFormat:@"%@已同意添加您为好友",msg.fromUser.username];
        cell.replyButton.hidden = YES;
    }
   
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(void)agree:(UIButton *)button{
    SysMessage *msg = self.dataArray[button.tag];
    
    
    [UserService agreeFriendWithObejctId:msg.objectId userId:msg.fromUser.objectId completion:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [UserService addFriendWithUser:msg.toUser friend:msg.fromUser completion:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
 //                   [self showInfomation:@"已同意添加好友"];
                    [button setTitle:@"已同意" forState:UIControlStateNormal];
                    button.enabled = NO;
                }else{
 //                   [self showInfomation:@"请稍后再试"];
                }
            }];
        }else{
  //          [self showInfomation:@"请稍后再试"];
        }
    }];
    
}



@end
