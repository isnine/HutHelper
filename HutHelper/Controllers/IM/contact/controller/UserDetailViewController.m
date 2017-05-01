//
//  UserDetailViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "UserDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserService.h"
#import <BmobIMSDK/BmobIMSDK.h>
#import "ChatViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDefaultLeftBarButtonItem];
    [self setupSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSubviews{
    self.navigationItem.title = @"添加联系人";
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.nameLabel.text = self.userInfo.name;
//    self.descLabel.text = self.userInfo.desc;
//    if (self.userInfo.gender == BIMUserMan) {
//        self.genderImageView.image = [UIImage imageNamed:@"man"];
//    }else{
//        self.genderImageView.image = [UIImage  imageNamed:@"women"];
//    }
    
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"login_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView.layer setCornerRadius:22];
}



-(void)addFriend{
    [UserService addFriendNoticeWithUserId:self.userInfo.userId completion:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            [self showInfomation:error.localizedDescription];
        }else{
            [self showInfomation:@"已发送添加好友请求"];
        }
    }];
}

- (IBAction)chat:(id)sender {
    
    [[BmobIM sharedBmobIM] saveUserInfo:self.userInfo];
    
    [self performSegueWithIdentifier:@"toChatVC" sender:nil];
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toChatVC"]) {
        ChatViewController *cvc = segue.destinationViewController;
        BmobIMConversation *conversation = [BmobIMConversation conversationWithId:self.userInfo.userId conversationType:BmobIMConversationTypeSingle];
        conversation.conversationTitle = self.userInfo.name;
        cvc.conversation = conversation;
    }
    
    
}


@end
