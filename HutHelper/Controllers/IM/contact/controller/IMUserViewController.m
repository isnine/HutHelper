//
//  UserViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "IMUserViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserService.h"
#import "UserDetailViewController.h"


@interface IMUserViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *userArray;
@end




@implementation IMUserViewController


static NSString *cellId = @"UserInfoCellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    _userArray = [[NSMutableArray alloc] init];
    [self loadUsers];
    self.title=@"添加好友";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}




-(void)setupSubviews{
//[self setDefaultLeftBarButtonItem];
    UINib *nib = [UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = 60;
    self.searchBar.delegate = self;
}


-(void)loadUsers{
   // [self showLoading];
    [UserService loadUsersWithDate:[NSDate date] completion:^(NSArray *array, NSError *error) {
        if (error) {
//            [self showInfomation:error.localizedDescription];
        }else{
            if (array && array.count > 0) {
                [self.userArray setArray:array];
                [self.tableView reloadData];
            }}
//            [self hideLoading];
//        }
   }];
    
}


#pragma mark - UITableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    [cell setInfo:info];
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobIMUserInfo *info = self.userArray[indexPath.row];
    [self performSegueWithIdentifier:@"toUserDetail" sender:info];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - search delegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
      //  [self showLoading];
        [UserService loadUsersWithDate:[NSDate date] keyword:searchBar.text completion:^(NSArray *array, NSError *error) {
            if (error) {
        //        [self showInfomation:error.localizedDescription];
            }else{
                if (array) {
                    [self.userArray setArray:array];
                    
                }else{
                    [self.userArray removeAllObjects];
                }
                [self.tableView reloadData];
//                [self hideLoading];
            }
        } ];
        
    }
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"toUserDetail"]) {
         UserDetailViewController *udvc = segue.destinationViewController;
         udvc.userInfo = sender;
     }
 }


@end
