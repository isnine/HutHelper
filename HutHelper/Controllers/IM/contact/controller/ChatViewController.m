//
//  ChatViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/21.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "ChatViewController.h"
#import "TextChatTableViewCell.h"
#import "ImageChatTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ChatBottomControlView.h"
#import "BmobIMDemoPCH.h"
#import <BmobSDK/Bmob.h>
#import "BmobIMDemoPCH.h"
#import "ChatBottomContentView.h"
#import "Masonry.h"
#import "ViewUtil.h"
#import "CommonUtil.h"
#import "MessageService.h"
#import "AudioTableViewCell.h"
#import "BmobIMMessage+SubClass.h"
#import "LocationTableViewCell.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ChatBottomContolViewDelegate>

@property (weak, nonatomic) IBOutlet ChatBottomControlView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint    *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView           *tableView;

@property (strong, nonatomic) NSMutableArray     *messagesArray;
@property (strong, nonatomic) BmobIM             *sharedIM;
@property (strong, nonatomic) BmobUser           *loginUser;
@property (strong, nonatomic) UIRefreshControl   *freshControl;
@property (assign, nonatomic) NSUInteger         page;
@property (assign, nonatomic) BOOL               finished;
@property (strong, nonatomic) ChatBottomContentView *contentView;
@property (strong, nonatomic) BmobIMUserInfo *userInfo;

@end

@implementation ChatViewController

static NSString *kTextCellID     = @"ChatCellID";
static NSString *kImageCellID    = @"imageChatCellID";
static NSString *kAudioCellID    = @"audioCellID";
static NSString *kLocationCellID = @"locationCellID";

static CGFloat  kBottomContentViewHeight = 105.0f;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    _messagesArray = [[NSMutableArray alloc] init];

    self.loginUser = [BmobUser getCurrentUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomViewFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBottomView) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:kNewMessagesNotifacation object:nil];
    self.page = 0;
    
    [self loadMessageRecords];
    
    _freshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.freshControl];
    [self.freshControl addTarget:self action:@selector(loadMoreRecords) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.userInfo = [self.sharedIM userInfoWithUserId:self.conversation.conversationId];
    
    //更新缓存
    [self.conversation updateLocalCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupSubviews{
    [self setDefaultLeftBarButtonItem];
    [self setupRightBarButtonItem];
    self.navigationItem.title = self.conversation.conversationTitle;
    self.bottomView.textField.delegate = self;
    self.bottomView.delegate = self;
    self.view.backgroundColor = kDefaultViewBackgroundColor;
    self.tableView.backgroundColor = kDefaultViewBackgroundColor;
    
    [self.bottomView.typeButton addTarget:self action:@selector(showBottomContentView) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView = [[ChatBottomContentView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.bottomView.mas_bottom);
    }];
    [self.contentView setupSubviews];
    [self.contentView.photoLibButton addTarget:self action:@selector(toPhotoLib) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.photoTakeButton addTarget:self action:@selector(toTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.locateButton addTarget:self action:@selector(toLocate) forControlEvents:UIControlEventTouchUpInside];
}


-(BOOL)hidesBottomBarWhenPushed{
    return YES;
}

-(void)setupRightBarButtonItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    [button setTitle:@"清空消息" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:13]];
}

-(void)clearCache{
    [self.conversation deleteMessageWithdeleteMessageListOrNot:NO updateTime:[[NSDate date] timeIntervalSince1970] * 1000];
    [self.messagesArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - load messages

-(void)loadMessageRecords{
    
    
    NSArray *array = [self.conversation queryMessagesWithMessage:nil limit:10];
    
    
    if (array && array.count > 0) {
        NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
            if (obj1.updatedTime > obj2.updatedTime) {
                return NSOrderedDescending;
            }else if(obj1.updatedTime <  obj2.updatedTime) {
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
            
        }];
        [self.messagesArray setArray:result];
        
        
        
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)loadMoreRecords{
    if (!self.finished) {
        self.page ++;
        [self.freshControl beginRefreshing];
        
        if (self.messagesArray.count <= 0) {
            [self.freshControl endRefreshing];
            return;
        }
        BmobIMMessage *msg = [self.messagesArray firstObject];
        
        NSArray *array = [self.conversation queryMessagesWithMessage:msg limit:10];
        
        if (array && array.count > 0) {
            NSMutableArray *messages = [NSMutableArray arrayWithArray:self.messagesArray];
            [messages addObjectsFromArray:array];
            NSArray *result = [messages sortedArrayUsingComparator:^NSComparisonResult(BmobIMMessage *obj1, BmobIMMessage *obj2) {
                if (obj1.updatedTime > obj2.updatedTime) {
                    return NSOrderedDescending;
                }else if(obj1.updatedTime <  obj2.updatedTime) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedSame;
                }
                
            }];
            [self.messagesArray setArray:result];
            [self.tableView reloadData];
        }else{
            self.finished = YES;
            [self showInfomation:@"没有更多的历史消息"];
        }
        
    }else{
        [self showInfomation:@"没有更多的历史消息"];
    }
    
    [self.freshControl endRefreshing];
}

-(void)goback{
    
    //更新缓存
    [self.conversation updateLocalCache];
    
    [super goback];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveMessage:(NSNotification *)noti{
    BmobIMMessage *message = noti.object;
    
    NSLog(@"%@",message.extra);
    
    if (message.extra[KEY_IS_TRANSIENT] && [message.extra[KEY_IS_TRANSIENT] boolValue]) {
        return;
    }
    if ([message.fromId isEqualToString:self.conversation.conversationId]) {
        
        BmobIMMessage *tmpMessage = nil;
        if ([message.msgType isEqualToString:kMessageTypeSound]) {
            tmpMessage = [[BmobIMAudioMessage alloc] initWithMessage:message];
        }else if([message.msgType isEqualToString:kMessageTypeImage]){
            tmpMessage = [[BmobIMImageMessage alloc] initWithMessage:message];
        }else{
            tmpMessage =  message;
        }
        
        
        [self.messagesArray addObject:tmpMessage];
        [self scrollToBottom];
    }
    
}

#pragma mark - bottom view

-(void)bottomViewFrameChange:(NSNotification *)noti{
    NSValue *aValue = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGFloat height = keyboardSize.height;
    self.bottomConstraint.constant = height;
    [UIView animateWithDuration:0.3f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view updateConstraints];
            if (self.messagesArray.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
    }];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)hideBottomView{
    self.bottomConstraint.constant = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view updateConstraints];
    }];
}

-(void)showBottomContentView{
    [self.bottomView.textField resignFirstResponder];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(kBottomContentViewHeight));
    }];
    self.bottomConstraint.constant = kBottomContentViewHeight;
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    CGFloat height = 0;
    BmobIMMessage *msg = self.messagesArray[indexPath.row];
    
    if ([msg.msgType isEqualToString:kMessageTypeText]) {
        height =   [tableView fd_heightForCellWithIdentifier:kTextCellID  configuration:^(TextChatTableViewCell *cell) {
            [self configCell:cell message:msg];
            
        }];
    }else if ([msg.msgType isEqualToString:kMessageTypeImage]){
        height = [tableView fd_heightForCellWithIdentifier:kImageCellID configuration:^(ImageChatTableViewCell *cell) {
            [self configImageCell:cell message:msg];
        }];
    }else if ([msg.msgType isEqualToString:kMessageTypeSound]){
        height =  [tableView fd_heightForCellWithIdentifier:kAudioCellID configuration:^(AudioTableViewCell *cell) {
            [self configAudioCell:cell message:msg];
        }];
    }else if ([msg.msgType isEqualToString:kMessageTypeLocation]){
        height = [tableView fd_heightForCellWithIdentifier:kLocationCellID configuration:^(LocationTableViewCell *cell) {
            [self configLocationCell:cell message:msg];
        }];
    }

    
    if (height < 85) {
        height = 85;
    }
    return height;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BmobIMMessage *msg = self.messagesArray[indexPath.row];
    if ([msg.msgType isEqualToString:kMessageTypeText]) {
        return [self textCellWithTableView:tableView cellForRowAtIndexPath:indexPath message:msg];
    }else if ([msg.msgType isEqualToString:kMessageTypeImage]){
        return [self imageCellWithTableView:tableView cellForRowAtIndexPath:indexPath message:msg];
    }else if ([msg.msgType isEqualToString:kMessageTypeSound]){
        return [self audioCellWithTableView:tableView cellForRowAtIndexPath:indexPath message:msg];
    }else if ([msg.msgType isEqualToString:kMessageTypeLocation]){
        return [self locationCellWithTableView:tableView cellForRowAtIndexPath:indexPath message:msg];
    }

    return nil;
}

#pragma mark - config Cells

-(TextChatTableViewCell *)textCellWithTableView:(UITableView *)tableView
                          cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                        message:(BmobIMMessage *)msg{
    TextChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCellID];
    if(cell == nil) {
        cell = [[TextChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configCell:cell message:msg];
    return cell;

}



-(void)configCell:(TextChatTableViewCell *)cell message:(BmobIMMessage *)msg{
    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
        [cell setMsg:msg userInfo:nil] ;
    }else{
        [cell setMsg:msg userInfo:self.userInfo] ;
    }
}

-(ImageChatTableViewCell *)imageCellWithTableView:(UITableView *)tableView
                            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                          message:(BmobIMMessage *)msg{
    ImageChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kImageCellID];
    if(cell == nil) {
        cell = [[ImageChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kImageCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configImageCell:cell message:msg];
    return cell;
    
    
};

-(void)configImageCell:(ImageChatTableViewCell *)cell message:(BmobIMMessage *)msg{
    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
        [cell setMsg:msg userInfo:nil] ;
    }else{
        [cell setMsg:msg userInfo:self.userInfo] ;
    }
}

-(AudioTableViewCell *)audioCellWithTableView:(UITableView *)tableView
                            cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                          message:(BmobIMMessage *)msg{
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAudioCellID];
    if(cell == nil) {
        cell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAudioCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configAudioCell:cell message:msg];
    return cell;
    
    
};

-(void)configAudioCell:(AudioTableViewCell *)cell message:(BmobIMMessage *)msg{
    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
        [cell setMsg:msg userInfo:nil] ;
    }else{
        [cell setMsg:msg userInfo:self.userInfo] ;
    }
}


-(LocationTableViewCell *)locationCellWithTableView:(UITableView *)tableView
                              cellForRowAtIndexPath:(NSIndexPath *)indexPath
                                            message:(BmobIMMessage *)msg{
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLocationCellID];
    if(cell == nil) {
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLocationCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configLocationCell:cell message:msg];
    return cell;
    
    
};

-(void)configLocationCell:(LocationTableViewCell *)cell message:(BmobIMMessage *)msg{
    if ([self.loginUser.objectId isEqualToString:msg.fromId]) {
        [cell setMsg:msg userInfo:nil] ;
    }else{
        [cell setMsg:msg userInfo:self.userInfo] ;
    }
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bottomConstraint.constant != 0.0f) {
        [self.view endEditing:YES];
    }
}


#pragma mark - textfield delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendTextWithTextField:textField];
    return YES;

}



#pragma mark - message

-(void)sendTextWithTextField:(UITextField *)textField{
    if (textField.text.length == 0) {
        [self showInfomation:@"请输入内容"];
    }else{
        
        BmobIMTextMessage *message = [BmobIMTextMessage messageWithText:textField.text attributes:nil];
        message.conversationType =  BmobIMConversationTypeSingle;
        message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
        message.updatedTime = message.createdTime;
        [self.messagesArray addObject:message];
        [self scrollToBottom];
        self.bottomView.textField.text = nil;
        
        __weak typeof(self)weakSelf = self;
        [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
            [weakSelf reloadLastRow];
        
        }];
        
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


#pragma mark - image picker
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    UIImage *resizeImage = nil;
    static CGFloat imageLimitWidth = 150;
    if (image.size.width > imageLimitWidth) {
        resizeImage = [ViewUtil resizeImageWithWidth:imageLimitWidth sourceImage:image];
    }else{
        resizeImage = image;
    }
    
   
    [MessageService uploadImage:resizeImage completion:^(BmobIMImageMessage *message, NSError *error) {
        if (!error) {
            [self.messagesArray addObject:message];
            [self scrollToBottom];
             __weak typeof(self)weakSelf = self;
            
            [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
                [weakSelf reloadLastRow];
            }];
        }else{
            [self showInfomation:error.localizedDescription];
        }
    } progress:^(CGFloat progress) {
        [self showProgress:progress];
    }];
    
   
    
}

-(void)reloadLastRow{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)scrollToBottom{
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messagesArray.count-1 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - some action

-(void)toPhotoLib{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsCompact];
    
    imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)toTakePhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        [imagePickerController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar"] forBarMetrics:UIBarMetricsCompact];
        
        imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        [self showInfomation:@"无可用摄像头"];
    }
}


-(void)toLocate{
    BmobIMLocationMessage *message = [BmobIMLocationMessage messageWithAddress:@"广州大学城" attributes:@{KEY_METADATA:@{KEY_LATITUDE:@(23.039),KEY_LONGITUDE:@(113.388)}}];
    message.conversationType =  BmobIMConversationTypeSingle;
    message.createdTime = (uint64_t)([[NSDate date] timeIntervalSince1970] * 1000);
    message.updatedTime = message.createdTime;
    [self.messagesArray addObject:message];
    [self scrollToBottom];
    
    __weak typeof(self)weakSelf = self;
   
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        [weakSelf reloadLastRow];
    }];
    
}

-(void)sendTempMessage{
    BmobIMMessage *message = [[BmobIMMessage alloc] init];

    message.msgType = @"notice";
    message.conversationType = BmobIMConversationTypeSingle;
    message.extra = @{KEY_IS_TRANSIENT:@(YES)};
    message.content = @"添加好友";
    [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"error %@",error.localizedDescription);
    }];
}

#pragma mark -
-(void)recordCompletedWithData:(NSData *)data duration:(NSTimeInterval)duration localPath:(NSString *)localPath{
   
    if (duration > 1.0f && duration < 60.0f) {
        [MessageService uploadAudio:data
                           duration:duration
                         completion:^(BmobIMAudioMessage *message, NSError *error) {
                             if (!error) {
                               
                                 [self.messagesArray addObject:message];
                                 [self scrollToBottom];
                                 __weak typeof(self)weakSelf = self;
                                 
                                 [self.conversation sendMessage:message completion:^(BOOL isSuccessful, NSError *error) {
                                     [weakSelf reloadLastRow];
                                 }];
                             }
                         } progress:nil];
    }
    
    

    
}
@end
