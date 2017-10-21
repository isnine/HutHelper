//
//  UserViewController.m
//  HutHelper
//
//  Creatde by nine on 2016/11/19.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "UserViewController.h"
#import "JSHeaderView.h"
#import "UserInfoCell.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UMMobClick/MobClick.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JSONKit.h"
#import "MBProgressHUD+MJ.h"
 
static NSString *const kUserInfoCellId = @"kUserInfoCellId";

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy)NSString *m_auth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JSHeaderView *headerView;
@end

@implementation UserViewController
UIImage* img ;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    self.headerView=[[JSHeaderView alloc] initWithImage:[self getImg]];
    self.navigationItem.titleView = self.headerView;

    [self.headerView reloadSizeWithScrollView:self.tableView];
    [self.headerView handleClickActionWithBlock:^{
        [self getImageFromIpc];
    }];
    
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:94/255.0 green:199/255.0 blue:217/255.0 alpha:1]];

}
- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    img = info[UIImagePickerControllerEditedImage]; //获得修改后
    // img = [info objectForKey:UIImagePickerControllerOriginalImage];   //获得原图
    NSData *imageData = UIImageJPEGRepresentation(img,1.0);
    int length = (short)[imageData length]/1024;
    if (length<=2500) {
        [self postimage:img];
    }
    else{
        UIAlertView *alertView                    = [[UIAlertView alloc] initWithTitle:@"头像大小过大"
                                                                               message:@"请重新选择"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"取消"
                                                                     otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
NSData* data;
- (void)postimage:(UIImage *)img
{
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *url_String=Config.getApiProfileAvatar;
    
    NSURL* url = [NSURL URLWithString:url_String];//请求url
    // UIImage* img = [UIImage imageNamed:@"header.jpg"];
    data = UIImagePNGRepresentation(img);
    //ASIFormDataRequest请求是post请求，可以查看其源码
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
    request.tag = 20;
    request.delegate = self;
    [request setPostValue:self.m_auth forKey:@"m_auth"];
    //    [request setFile:@"tabbar.png" forKey:@"haoyou"];//如果有路径，上传文件
    [request setData:data  withFileName:@"header.jpg" andContentType:@"image/jpg" forKey:@"file"];
    //               数据                文件名,随便起                 文件类型            设置key
    
    
    [request startAsynchronous];
    
    [request setDidFinishSelector:@selector(postsucces)];//当成功后会自动触发 headPortraitSuccess 方法
    [request setDidFailSelector:@selector(postfailure)];//如果失败会 自动触发 headPortraitFail 方法
    [MBProgressHUD showMessage:@"上传中" toView:self.view];
    // [request startSynchronous];
}

-(void)postsucces{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    HideAllHUD
    [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
    [defaults setObject:data forKey:@"head_img"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
    
}

-(void)postfailure{
    HideAllHUD
    [MBProgressHUD showError:@"上传失败" toView:self.view];
}

#pragma mark -
#pragma mark - tableView protocal methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 183.f;
    }
    return 86.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 15;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *TrueName=Config.getTrueName; //真实姓名
    NSString *studentKH=Config.getStudentKH; //学号
    NSString *dep_name=Config.getDepName; //学院
    NSString *class_name=Config.getClassName;  //班级
    NSString *sex=Config.getSex;  //性别
    if(sex ==NULL){
        sex=@"";
    }
    if (indexPath.section == 0) {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellId];
        if (!cell) {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUserInfoCellId];
        }
        return cell;
    }
    if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@", TrueName];
        return cell;
    }
    if(indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"性别:%@", sex];
        return cell;
    }
    if(indexPath.section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"学号:%@", studentKH];
        return cell;
    }
    if(indexPath.section == 4){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"学院:%@", dep_name];
        return cell;
    }
    if(indexPath.section == 5){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"班级:%@", class_name];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse" forIndexPath:indexPath];
    return cell;
    // cell.textLabel.text = [NSString stringWithFormat:@"ro %zd", indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(UIImage*)getImg{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults]; //得到用户数据
    NSString *Url=[NSString stringWithFormat:@"%@/%@",Config.getApiImg,Config.getHeadPicThumb];
    if ((!Config.getHeadPicThumb)||[Config.getHeadPicThumb isEqualToString:@""]) {
        if ([Config.getSex isEqualToString:@"男"]) {
            return [UIImage imageNamed:@"img_user_boy"];
        }else{
            return [UIImage imageNamed:@"img_user_girl"];
        }
    }
    else if ([defaults objectForKey:@"head_img"]){
        return [UIImage imageWithData:[defaults objectForKey:@"head_img"]];
    }else{
//        if ([Config.getSex isEqualToString:@"男"]) {
//            return [UIImage imageNamed:@"img_user_boy"];
//        }else{
//            return [UIImage imageNamed:@"img_user_girl"];
//        }
        NSURL *imageUrl = [NSURL URLWithString:Url];
        UIImage *Img=[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        NSData *data = UIImagePNGRepresentation(Img);
        [defaults setObject:data forKey:@"head_img"];
        [defaults synchronize];
        return Img;
    }
}
@end
