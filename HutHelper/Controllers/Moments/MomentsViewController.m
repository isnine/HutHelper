//
//  MomentsViewController.m
//  HutHelper
//
//  Created by Nine on 2017/3/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsViewController.h"
#import "MomentsTableView.h"
#import "MomentsModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "YYFPSLabel.h"

#import "YCXMenu.h"
#import "User.h"
#import "AppDelegate.h"

#import "MomentsAddViewController.h"
@interface MomentsViewController (){
    MomentsTableView *momentsTableView;
    NSMutableArray *datas;
}
@property (nonatomic , strong) NSMutableArray *items;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end
@implementation MomentsViewController
@synthesize items = _items;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];
    /** FTP */
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 5, 60, 30)]];
    if([Config getIs]==0){
        UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
        [rightButtonView addSubview:mainAndSearchBtn];
        [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_menu_menu"] forState:UIControlStateNormal];
        [mainAndSearchBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
        self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        momentsTableView = [[MomentsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain withSay:[Config getSay] withSayLike:[Config getSayLike]];
        momentsTableView.beginload;
        [self.view addSubview:momentsTableView];
        
    }else{
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *JSONDic=[defaults objectForKey:@"otherSay"];
        [self reLoadData:JSONDic];
        MomentsModel *momentsModel=datas[0];
        if(momentsModel.username){
            self.navigationItem.title = [NSString stringWithFormat:@"%@的说说",momentsModel.username];
            momentsTableView = [[MomentsTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain withSay:[defaults objectForKey:@"otherSay"] withSayLike:[Config getSayLike]];
            momentsTableView.HiddenMJ;
            [self.view addSubview:momentsTableView];
        }
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers count]==2&&[Config getIs]==1) {
        [Config setIs:0];
    }
}
-(void)reLoadData:(NSDictionary*)JSONDic{
    datas = [[NSMutableArray alloc]init];
    for (NSDictionary *eachDic in JSONDic) {
        MomentsModel *momentsModel=[[MomentsModel alloc]initWithDic:eachDic];
        [datas addObject:momentsModel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)menu{
    [YCXMenu setTintColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [YCXMenu setSeparatorColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    //    [YCXMenu setTitleFont:[UIFont systemFontOfSize:19.0]];
    //    [YCXMenu setSelectedColor:[UIColor redColor]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        UIView *blindView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        blindView.backgroundColor = [UIColor blackColor];
        blindView.alpha=0.5;
        blindView.tag=99;
        [[[UIApplication  sharedApplication]  keyWindow] addSubview:blindView];
        [YCXMenu showMenuInView:[[UIApplication  sharedApplication]  keyWindow] fromRect:CGRectMake(self.view.frame.size.width - 50, 70, 50, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            
        }];
    }
    
}
- (NSMutableArray *)items {
    if (!_items) {
        YCXMenuItem *firstTitle = [YCXMenuItem menuItem:@"添加说说" image:[UIImage imageNamed:@"adds"] target:self action:@selector(addSay)];
        firstTitle.foreColor = [UIColor blackColor];
        firstTitle.alignment = NSTextAlignmentCenter;
        //set logout button
        YCXMenuItem *SecondTitle = [YCXMenuItem menuItem:@"我的说说" image:[UIImage imageNamed:@"mine"] target:self action:@selector(mySay)];
        SecondTitle.foreColor = [UIColor blackColor];
        SecondTitle.alignment = NSTextAlignmentCenter;
        
        _items = [@[firstTitle,
                    SecondTitle
                    ] mutableCopy];
    }
    return _items;
}
-(void)mySay{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [Config setNoSharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=[NSString stringWithFormat:@"%@/%@",Config.getApiMomentsUser,Config.getUserId];
    [APIRequest GET:Url_String parameters:nil success:^(id responseObject) {
        NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
            NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
            NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
            if (Say_content.count!=0) {
                [defaults setObject:Say_content forKey:@"otherSay"];
                [defaults synchronize];
                HideAllHUD
                [Config setIs:1];
                MomentsViewController *Say      = [[MomentsViewController alloc] init];
                AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
            }else{
                HideAllHUD
                [MBProgressHUD showError:@"您没有发布的说说" toView:self.view];
            }
        }
        else{
            HideAllHUD
            [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
        }
    }failure:^(NSError *error) {
        HideAllHUD
        [MBProgressHUD showError:@"网络超时" toView:self.view];
        
    }];
}
-(void)addSay{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    [Config pushViewController:@"AddSay"];
}
- (id) init{
    self = [super init];
    if(self != nil){
        //监听一个通知，当收到通知时，调用notificationAction方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeYCXMenuBlind) name:@"YCXMenuWillDisappearNotification" object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YCXMenuWillDisappearNotification" object:nil];
}
-(void)removeYCXMenuBlind{
    UIView *blindView=[[[UIApplication  sharedApplication]  keyWindow] viewWithTag:99];
    [blindView removeFromSuperview];
}
@end
