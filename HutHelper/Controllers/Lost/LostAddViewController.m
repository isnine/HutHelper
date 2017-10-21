//
//  LostAddViewController2.m
//  HutHelper
//
//  Created by nine on 2017/8/5.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostAddViewController.h"
#import "TZImagePickerController.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

#import "UINavigationBar+Awesome.h"
@interface LostAddViewController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
}
@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UIImageView *backImgView;
@property (nonatomic,strong)  UITextField *titleField;
@property (nonatomic,strong)  UITextView *describeText;
@property (nonatomic,strong)  UITextField *lostsField;

@property (nonatomic,copy) NSString      *responstring;
@property  int getphoto;
@end

@implementation LostAddViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"添加失物";
    self.view.backgroundColor=RGB(239, 239, 239, 1);
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_hand_ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    [self setHeadImg];
    [self setText];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //标题透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //黑线消失
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //标题白色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //返回箭头白色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //返回箭头还原
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:29/255.0 green:203/255.0 blue:219/255.0 alpha:1];
    //标题透明还原
    [self.navigationController.navigationBar lt_reset];
    //状态栏还原
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //标题还原
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}
#pragma mark - 界面绘制
-(void)setHeadImg{
    //背景放大并高斯模糊
    _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, SYReal(390))];
    //中心切割
    _backImgView.contentMode =UIViewContentModeScaleAspectFill;
    _backImgView.clipsToBounds = YES;
    _backImgView.backgroundColor=RGB(169, 195, 224, 1);
    [self.view addSubview:_backImgView];
    //商品图
    _goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(26), SYReal(85), SYReal(120), SYReal(120))];
    _goodsImgView.contentMode =UIViewContentModeScaleAspectFill;
    _goodsImgView.clipsToBounds = YES;
    _goodsImgView.image=[UIImage imageNamed:@"img_hand_addpic"];
    [self.view addSubview:_goodsImgView];
    //点击图片事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImg)];
    [_goodsImgView addGestureRecognizer:tapGestureRecognizer];
    [_goodsImgView setUserInteractionEnabled:YES];
}
-(void)setText{
    //商品描述
    _describeText=[[UITextView alloc]initWithFrame:CGRectMake(SYReal(23), SYReal(210), SYReal(375), SYReal(100))];
    _describeText.textColor=[UIColor whiteColor];
    _describeText.font=[UIFont systemFontOfSize:SYReal(15)];
    _describeText.backgroundColor=[UIColor clearColor];
    _describeText.text=@"请输入商品详情描述..";
    _describeText.delegate=self;
    [self.view addSubview:_describeText];
    //白色卡片背景
    UIImageView *blackImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(20), SYReal(330), SYReal(374), SYReal(355))];
    blackImgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:blackImgView];
    //卡片内容
    NSArray *labTitle=@[@"拾到物品",@"拾到时间",@"拾到地点",@"联系电话"];
    NSArray *icoViewArray=@[@"ico_lost_lost",@"ico_lost_time",@"ico_lost_address",@"ico_lost_tel"];
    NSArray *fieldHolder=@[@"请输入拾到物品名字",@"请输入拾到物品时间,格式2017-01-01",@"请输入拾到物品的地点",@"请输入拾到者的手机"];
    int LabY=370;
    for (int i=0; i<4; i++) {
        //固定标签
        UILabel *Lab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(90), SYReal(LabY), SYReal(50), SYReal(30))];
        Lab.textColor=[UIColor lightGrayColor];
        Lab.font=[UIFont systemFontOfSize:SYReal(12)];
        Lab.text=labTitle[i];
        [self.view addSubview:Lab];
        //ico图标
        UIImageView *icoImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(45), SYReal(LabY+20), SYReal(25), SYReal(25))];
        icoImgView.image=[UIImage imageNamed:icoViewArray[i]];
        [self.view addSubview:icoImgView];
        
        _lostsField=[[UITextField alloc]initWithFrame:CGRectMake(SYReal(90), SYReal(LabY+20), SYReal(300), SYReal(40))];
        _lostsField.textColor=[UIColor blackColor];
        _lostsField.font=[UIFont systemFontOfSize:SYReal(17)];
        _lostsField.placeholder=fieldHolder[i];
        _lostsField.tag=100+i;
        _lostsField.font=[UIFont systemFontOfSize:SYReal(15)];
        _lostsField.delegate=self;
        [_lostsField setValue:RGB(202, 202, 202, 1) forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:_lostsField];
        
        LabY+=75;
    }
    
}
#pragma  mark - 方法
-(void)addImg{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        int imgX=26;
        for (int i=0 ; i<_selectedPhotos.count; i++) {
            UIImageView *selectedImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(imgX), SYReal(85), SYReal(120), SYReal(120))];
            selectedImgView.image=_selectedPhotos[i];
            [self.view addSubview:selectedImgView];
            imgX+=125;
        }
        //不满3个图片时显示添加按钮
        if (_selectedPhotos.count<3) {
            _goodsImgView.frame=CGRectMake(SYReal(imgX), SYReal(85), SYReal(120), SYReal(120));
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)post{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    NSString *Url_String=Config.getApiLostCreate;
    UITextField *titField=[self.view viewWithTag:100];
    UITextField *timeField=[self.view viewWithTag:101];
    UITextField *locateField=[self.view viewWithTag:102];
    UITextField *phoneField=[self.view viewWithTag:103];
    
    NSLog(@"失物发生请求地址%@",Url_String);
    if([_describeText.text isEqual:@"请输入商品详情描述.."]||[_describeText.text isEqual:@""]){
        [MBProgressHUD showError:@"必须输入失物详情" toView:self.view];
        return;
    }
    //有图时先上传图片
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if (_selectedPhotos.count!=0) {
        _responstring=@"";
        _getphoto=0;
        NSDictionary *dict = @{@"username":@"Saup"};
        for (int i = 0; i < _selectedPhotos.count; i++) {
            UIImage *image = _selectedPhotos[i];
            [manager POST:Config.getApiLostImgUpload parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *msg=[responseObject objectForKey:@"msg"];
                if ([msg isEqualToString:@"ok"]) {
                    _responstring=[_responstring stringByAppendingString:[responseObject objectForKey:@"data"]];
                    _responstring=[_responstring stringByAppendingString:@"//"];
                    _getphoto++;
                    while (_getphoto==_selectedPhotos.count) {
                        
                        NSDictionary *params = @{
                                                 @"tit" : titField.text,
                                                 @"locate" : locateField.text,
                                                 @"time" : timeField.text,
                                                 @"content" : _describeText.text,
                                                 @"phone" : phoneField.text,
                                                 @"qq" : @"",
                                                 @"wechat" : @"",
                                                 @"hidden"  : _responstring
                                                 };
                        [MBProgressHUD showMessage:@"发表中" toView:self.view];
                        
                        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                            HideAllHUD
                            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
                            NSString *Msg=[response objectForKey:@"msg"];
                            if ([Msg isEqualToString:@"ok"]){
                                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                            } else if ([Msg isEqualToString:@"令牌错误"]){
                                [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                            }else{
                                [MBProgressHUD showError:Msg toView:self.view];
                            }
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            HideAllHUD
                            [MBProgressHUD showError:@"网络错误" toView:self.view];
                        }];
                        break;
                    }
                    
                }else{
                    HideAllHUD
                    [MBProgressHUD showError:@"发表失败" toView:self.view];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                HideAllHUD
                [MBProgressHUD showError:@"网络错误" toView:self.view];
            }];
        }
    }else{
        //没有图片上传时
        NSDictionary *params = @{
                                 @"tit" : titField.text,
                                 @"locate" : locateField.text,
                                 @"time" : timeField.text,
                                 @"content" : _describeText.text,
                                 @"phone" : phoneField.text,
                                 @"qq" : @"",
                                 @"wechat" : @"",
                                 @"hidden"  : @""
                                 };
        [MBProgressHUD showMessage:@"发表中" toView:self.view];
        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            HideAllHUD
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *Msg=[response objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"]){
                [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            } else if ([Msg isEqualToString:@"令牌错误"]){
                [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            }else{
                [MBProgressHUD showError:Msg toView:self.view];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            HideAllHUD
            [MBProgressHUD showError:@"网络错误" toView:self.view];
        }];
    }
    
}

#pragma  mark - 代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入商品详情描述.."]) {
            textView.text=@"";
    }
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //用户结束输入
    [textField  resignFirstResponder];
    return  YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const int movementDistance = SYReal(190); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

@end
