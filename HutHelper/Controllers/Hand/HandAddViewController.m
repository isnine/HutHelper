//
//  HandAddViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/19.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "HandAddViewController.h"
#import "TZImagePickerController.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

#import "UINavigationBar+Awesome.h"
@interface HandAddViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    
}
@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UIImageView *backImgView;
@property (nonatomic,strong)  UITextField *titleField;
@property (nonatomic,strong)  UITextView *describeText;
@property (nonatomic,strong)  UITextField *goodsField;

@property (nonatomic,copy) NSString      *responstring;

@property  int getphoto;
@end

@implementation HandAddViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"添加商品";
    self.view.backgroundColor=[UIColor whiteColor];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ico_hand_ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(PostHand) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    //空白收起键盘
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self setHeadImg];
    [self setText];
    [self setFoot];
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
    _backImgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backImgView];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _backImgView.frame.size.width, _backImgView.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [_backImgView addSubview:toolbar];
    //商品图
    _goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SYReal(26), SYReal(110), SYReal(120), SYReal(120))];
    //中心切割
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
    //商品名称
    _titleField=[[UITextField alloc]initWithFrame:CGRectMake(SYReal(26), SYReal(230), SYReal(375), SYReal(50))];
    _titleField.textColor=[UIColor whiteColor];
    _titleField.placeholder=@"请输入商品名称...";
    _titleField.font=[UIFont systemFontOfSize:SYReal(15)];
    [_titleField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_titleField];
    //商品描述
    _describeText=[[UITextView alloc]initWithFrame:CGRectMake(SYReal(23), SYReal(270), SYReal(375), SYReal(100))];
    _describeText.textColor=[UIColor whiteColor];
    _describeText.font=[UIFont systemFontOfSize:SYReal(15)];
    _describeText.backgroundColor=[UIColor clearColor];
    _describeText.text=@"请输入商品详情描述..";
    _describeText.delegate=self;
    [self.view addSubview:_describeText];
    //四个块的标题
    NSArray *LabTitle=@[@"价格",@"成色",@"联系电话",@"发布区域"];
    int LabX[5]={26,233,26,233};
    int LabY[5]={425,425,560,560};
    for (int i=0; i<4; i++) {
        UILabel *Lab=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(LabY[i]), SYReal(50), SYReal(30))];
        Lab.textColor=[UIColor lightGrayColor];
        Lab.text=LabTitle[i];
        Lab.font=[UIFont systemFontOfSize:SYReal(12)];
        [self.view addSubview:Lab];
    }
    //四个块的数据
    NSArray *fieldHolder=@[@"请输入价格",@"99成新/95成新/9成新/8成新",@"请输入手机号",@"五食堂？东门?"];
    for (int i=0; i<4; i++) {
        _goodsField=[[UITextField alloc]initWithFrame:CGRectMake(SYReal(LabX[i]), SYReal(LabY[i]+15), SYReal(175), SYReal(80))];
        _goodsField.textColor=[UIColor blackColor];
        _goodsField.font=[UIFont systemFontOfSize:SYReal(17)];
        _goodsField.placeholder=fieldHolder[i];
        _goodsField.tag=100+i;
        _goodsField.font=[UIFont systemFontOfSize:SYReal(15)];
        _goodsField.delegate=self;
        [_goodsField setValue:RGB(202, 202, 202, 1) forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:_goodsField];
    }
}
-(void)setFoot{
    //绘制底部背景
    UIImageView *foodImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SYReal(680), DeviceMaxWidth, SYReal(56))];
    foodImgView.backgroundColor=RGB(239, 239, 239, 1);
    [self.view addSubview:foodImgView];
}
#pragma  mark - 方法
-(void)addImg{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        int imgX=26;
        for (int i=0 ; i<_selectedPhotos.count; i++) {
            UIImageView *selectedImgView=[[UIImageView alloc]initWithFrame:CGRectMake(SYReal(imgX), SYReal(110), SYReal(120), SYReal(120))];
            selectedImgView.image=_selectedPhotos[i];
            [self.view addSubview:selectedImgView];
            imgX+=125;
        }
        //不满3个图片时显示添加按钮
        if (_selectedPhotos.count<3) {
            _goodsImgView.frame=CGRectMake(SYReal(imgX), SYReal(110), SYReal(120), SYReal(120));
        }
        //设置第一个图片为背景
        if (_selectedPhotos.count!=0) {
            _backImgView.image=_selectedPhotos[0];
        }
     }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)PostHand{
    if ([Config isTourist]) {
        [MBProgressHUD showError:@"游客请登录" toView:self.view];
        return;
    }
    NSString *Url_String=Config.getApiGoodsCreate;
    UITextField *_Price=[self.view viewWithTag:100];
    UITextField *_Old=[self.view viewWithTag:101];
    UITextField *_Phone=[self.view viewWithTag:102];
    UITextField *_address=[self.view viewWithTag:103];
    NSLog(@"二手发布请求地址%@",Url_String);
    if ([_describeText.text isEqualToString:@"描述下你的商品..."]) {
        [MBProgressHUD showError:@"必须输入商品描述" toView:self.view];
        return;
    }else if(!([_Old.text isEqualToString:@"99成新"]||[_Old.text isEqualToString:@"95成新"]||[_Old.text isEqualToString:@"9成新"]||[_Old.text isEqualToString:@"8成新"]||[_Old.text isEqualToString:@"7成新及以下"])){
        [MBProgressHUD showError:@"请按格式输入成色,比如:99成新"toView:self.view];
        return;
    }
    [MBProgressHUD showMessage:@"发布中" toView:self.view];
    if (_selectedPhotos.count!=0) {
        _responstring=@"";
        _getphoto=0;
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSDictionary *dict = @{@"username":@"Saup"};
            //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            for (int i = 0; i < _selectedPhotos.count; i++) {
                UIImage *image = _selectedPhotos[i];
                [manager POST:Config.getApiGoodsImgUpload parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                            manager.requestSerializer.timeoutInterval = 5.f;
                            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                            // 利用AFN管理者发送请求
                            NSString *attr;
                            if ([_Old.text isEqualToString:@"99成新"])  attr=@"1";
                            else if([_Old.text isEqualToString:@"95成新"]) attr=@"2";
                            else if([_Old.text isEqualToString:@"9成新"])attr=@"3";
                            else if([_Old.text isEqualToString:@"8成新"])attr=@"4";
                            else if([_Old.text isEqualToString:@"7成新及以下"])attr=@"5";
                            NSDictionary *params = @{
                                                     @"tit":_titleField.text,
                                                     @"content" : _describeText.text,
                                                     @"prize"  : _Price.text,
                                                     @"prize_src"  : _Price.text,
                                                     @"attr"  : attr,
                                                     @"class" :@"0",
                                                     @"address" :_address.text,
                                                     @"hidden"  : _responstring,
                                                     @"phone":_Phone.text,
                                                     @"qq":@"",
                                                     @"wechat":@""
                                                     };
                            [MBProgressHUD showMessage:@"发表中" toView:self.view];
                            [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                     HideAllHUD
                                NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
                                NSString *Msg=[response objectForKey:@"msg"];
                                if ([Msg isEqualToString:@"ok"])
                                {
                                    [MBProgressHUD showSuccess:@"发布成功" toView:self.view];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                    
                                }else if ([Msg isEqualToString:@"令牌错误"]){
                                    [MBProgressHUD showError:@"登录过期，请重新登录"toView:self.view];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                }else{
                                    [MBProgressHUD showError:Msg toView:self.view];
                                }
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                HideAllHUD
                                [MBProgressHUD showError:@"网络错误"toView:self.view];
                            }];
                            break;
                        }
                    }else{
                        HideAllHUD
                        [MBProgressHUD showError:@"发表失败"toView:self.view];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    HideAllHUD
                    [MBProgressHUD showError:@"网络错误"toView:self.view];
                }];
        }
    }else
        [MBProgressHUD showError:@"必须添加图片"toView:self.view];
}


#pragma  mark - 代理


-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

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
    const int movementDistance = SYReal(220); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

@end
