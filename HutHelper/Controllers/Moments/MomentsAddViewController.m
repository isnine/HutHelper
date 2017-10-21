//
//  MomentsAddViewController.m
//  HutHelper
//
//  Created by nine on 2017/1/15.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "MomentsAddViewController.h"
#import "TZImagePickerController.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface MomentsAddViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *Img1;
@property (weak, nonatomic) IBOutlet UIImageView *Img2;
@property (weak, nonatomic) IBOutlet UIImageView *Img3;
@property (weak, nonatomic) IBOutlet UIImageView *Img4;
@property (weak, nonatomic) IBOutlet UITextView *Say_Text;
@property (nonatomic,copy) NSString      *responstring;
@property  int getphoto;
@end

@implementation MomentsAddViewController{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title          = @"发表说说";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(postsay) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    _Say_Text.text = @"请输入发表内容...";
    _Say_Text.textColor = [UIColor lightGrayColor];
    _Say_Text.delegate=self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Add:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        switch (_selectedPhotos.count) {
            case 1:
                _Img1.image=_selectedPhotos[0];
                break;
            case 2:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                break;
            case 3:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                _Img3.image=_selectedPhotos[2];
                break;
            default:
                _Img1.image=_selectedPhotos[0];
                _Img2.image=_selectedPhotos[1];
                _Img3.image=_selectedPhotos[2];
                _Img4.image=_selectedPhotos[3];
                break;
        }
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)postsay{
    NSString *Url_String=Config.getApiMomentsCreate;
    NSLog(@"说说发生请求地址%@",Url_String);
    if (_selectedPhotos.count!=0) {
        
        _responstring=@"";
        _getphoto=0;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSDictionary *dict = @{@"username":@"Saup"};
        if ([_Say_Text.text isEqualToString:@"请输入发表内容..."]) {
            [MBProgressHUD showError:@"必须输入发表内容" toView:self.view];
        }
        else{
            //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
             [MBProgressHUD showMessage:@"发表中" toView:self.view];
            for (int i = 0; i < _selectedPhotos.count; i++) {
                UIImage *image = _selectedPhotos[i];
                [manager POST:Config.getApiMomentsImgUpload parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
                    NSString *dateString = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
                    [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSLog(@"上传成功 %@", responseObject);
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
                            NSDictionary *params = @{
                                                     @"content" : _Say_Text.text,
                                                     @"hidden"  : _responstring
                                                     };
                           
                            [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
                                NSLog(@"%@",response);
                                NSString *Msg=[response objectForKey:@"msg"];
                                if ([Msg isEqualToString:@"ok"])
                                {
                                    HideAllHUD
                                //[MBProgressHUD showSuccess:@"发表成功" toView:self.view];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                    
                                }
                                else if ([Msg isEqualToString:@"令牌错误"]){
                                    HideAllHUD
                                    [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                }
                                else{
                                    HideAllHUD
                                    [MBProgressHUD showError:Msg];}
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                HideAllHUD
                                [MBProgressHUD showError:@"网络错误" toView:self.view];
                            }];
                            
                            
                            
                            break;
                        }
                        
                    }
                    else{
                        HideAllHUD
                        [MBProgressHUD showError:@"发表失败" toView:self.view];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    HideAllHUD
                    [MBProgressHUD showError:@"网络错误" toView:self.view];
                }];
            }
        }
    }
    else if([_Say_Text.text isEqual:@"请输入发表内容..."]||[_Say_Text.text isEqual:@""]){
        [MBProgressHUD showError:@"文本不能为空" toView:self.view];
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 利用AFN管理者发送请求
        NSDictionary *params = @{
                                 @"content" : _Say_Text.text,
                                 @"hidden"  :@""
                                 };
        [MBProgressHUD showMessage:@"发表中" toView:self.view];
        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *Msg=[response objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"])
            {
                HideAllHUD
                [MBProgressHUD showSuccess:@"评论成功" toView:self.view];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            }
            else if ([Msg isEqualToString:@"令牌错误"]){
                HideAllHUD
                [MBProgressHUD showError:@"登录过期，请重新登录" toView:self.view];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            }
            
            else{
                HideAllHUD
                [MBProgressHUD showError:Msg toView:self.view];
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            HideAllHUD
            [MBProgressHUD showError:@"网络错误" toView:self.view];
        }];}
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入发表内容..."]) {
            textView.text=@"";
    }
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}

-(void)reload{
    [Config setNoSharedCache];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [APIRequest GET:[Config getApiMoments:1] parameters:nil success:^(id responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     HideAllHUD
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                 }
                 else{
                     HideAllHUD
                     [MBProgressHUD showError:@"网络错误" toView:self.view];
                 }
             }
             else{
                 HideAllHUD
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"] toView:self.view];
             }             HideAllHUD
         }failure:^(NSError *error) {
             [MBProgressHUD showError:@"网络错误" toView:self.view];
             HideAllHUD
         }];
    
}


@end
