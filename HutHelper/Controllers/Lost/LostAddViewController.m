//
//  LostAddViewController.m
//  HutHelper
//
//  Created by nine on 2017/2/8.
//  Copyright © 2017年 nine. All rights reserved.
//

#import "LostAddViewController.h"
#import "TZImagePickerController.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
 
@interface LostAddViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    
}
@property (nonatomic,copy) NSString      *responstring;
@property  int getphoto;
@end

@implementation LostAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle];
    _content.text = @"失物详情，比如班级姓名，证件尾号等";
    _content.textColor = [UIColor lightGrayColor];
    _content.delegate=(id)self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddPhoto:(id)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
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

-(void)post{
    NSString *Url_String=[NSString stringWithFormat:API_LOSES_CREATE,Config.getStudentKH,Config.getRememberCodeApp];
    NSLog(@"失物发生请求地址%@",Url_String);
    if (_selectedPhotos.count!=0) {
        _responstring=@"";
        _getphoto=0;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSDictionary *dict = @{@"username":@"Saup"};
        if ([_content.text isEqualToString:@"失物详情，比如班级姓名，证件尾号等"]) {
            [MBProgressHUD showError:@"必须输入失物详情"];
        }
        else{
            //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            for (int i = 0; i < _selectedPhotos.count; i++) {
                UIImage *image = _selectedPhotos[i];
                [manager POST:API_LOSES_IMG_UPLOAD parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
                                                     @"tit" : _tit.text,
                                                     @"locate" : _locate.text,
                                                     @"time" : _time.text,
                                                     @"content" : _content.text,
                                                     @"phone" : _phone.text,
                                                     @"qq" : _qq.text,
                                                     @"wechat" : _wechat.text,
                                                     @"hidden"  : _responstring
                                                     };
                            [MBProgressHUD showMessage:@"发表中" toView:self.view];
                            [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                                NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
                                NSString *Msg=[response objectForKey:@"msg"];
                                if ([Msg isEqualToString:@"ok"])
                                {
                                    HideAllHUD
                                    [MBProgressHUD showSuccess:@"发布成功"];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                    
                                }
                                else if ([Msg isEqualToString:@"令牌错误"]){
                                    HideAllHUD
                                    [MBProgressHUD showError:@"登录过期，请重新登录"];
                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
                                }
                                else{
                                    HideAllHUD
                                    [MBProgressHUD showError:Msg];}
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                HideAllHUD
                                [MBProgressHUD showError:@"网络错误"];
                            }];
                            
                            
                            
                            break;
                        }
                        
                    }
                    else{
                        HideAllHUD
                        [MBProgressHUD showError:@"发表失败"];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    HideAllHUD
                    [MBProgressHUD showError:@"网络错误"];
                }];
            }
        }
    }
    else if([_content.text isEqual:@"失物详情，比如班级姓名，证件尾号等"]||[_content.text isEqual:@""]){
        [MBProgressHUD showError:@"必须输入失物详情"];
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        // 利用AFN管理者发送请求
        NSDictionary *params = @{
                                 @"tit" : _tit.text,
                                 @"locate" : _locate.text,
                                 @"time" : _time.text,
                                 @"content" : _content.text,
                                 @"phone" : _phone.text,
                                 @"qq" : _qq.text,
                                 @"wechat" : _wechat.text,
                                 @"hidden"  : @""
                                 };
        [MBProgressHUD showMessage:@"发表中" toView:self.view];
        [manager POST:Url_String parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
            NSString *Msg=[response objectForKey:@"msg"];
            if ([Msg isEqualToString:@"ok"])
            {
                HideAllHUD
                [MBProgressHUD showSuccess:@"发表成功"];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            }
            else if ([Msg isEqualToString:@"令牌错误"]){
                HideAllHUD
                [MBProgressHUD showError:@"登录过期，请重新登录"];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];  //返回Home
            }
            
            else{
                HideAllHUD
                [MBProgressHUD showError:Msg];}
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            HideAllHUD
            [MBProgressHUD showError:@"网络错误"];
        }];}
}



-(void)setTitle{
    self.navigationItem.title          = @"添加失物";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
@end
