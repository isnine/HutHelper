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

@interface HandAddViewController ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextView *Describe;
@property (weak, nonatomic) IBOutlet UITextField *Price;
@property (weak, nonatomic) IBOutlet UITextField *Old;
@property (weak, nonatomic) IBOutlet UITextField *Phone;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextField *Wechat;
@property (weak, nonatomic) IBOutlet UITextField *Price_src;
@property (nonatomic,copy) NSString      *responstring;
@property (weak, nonatomic) IBOutlet UIImageView *Img1;
@property (weak, nonatomic) IBOutlet UIImageView *Img2;
@property (weak, nonatomic) IBOutlet UIImageView *Img3;
@property (weak, nonatomic) IBOutlet UIImageView *Img4;
@property  int getphoto;
@end

@implementation HandAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"发布商品";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /**按钮*/
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 50, 50)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(PostHand) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    _Describe.text = @"描述下你的商品...";
    _Describe.textColor = [UIColor lightGrayColor];
    _Describe.delegate=self;
    _Phone.delegate=self;
    _QQ.delegate=self;
    _Wechat.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    textView.text=@"";
    textView.textColor = [UIColor blackColor];
    
    return YES;
    
}
- (IBAction)AddImg:(id)sender {
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
//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    textView.text=@"";
//    textView.textColor = [UIColor blackColor];
//    return YES;
//}
-(void)PostHand{
    NSString *Url_String=Config.getApiGoodsCreate;
    
    NSLog(@"二手发布请求地址%@",Url_String);
    if (_selectedPhotos.count!=0) {
        _responstring=@"";
        _getphoto=0;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 5.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        NSDictionary *dict = @{@"username":@"Saup"};
        if ([_Describe.text isEqualToString:@"描述下你的商品..."]) {
            [MBProgressHUD showError:@"必须输入商品描述"];
        }
        else if(!([_Old.text isEqualToString:@"99成新"]||[_Old.text isEqualToString:@"95成新"]||[_Old.text isEqualToString:@"9成新"]||[_Old.text isEqualToString:@"8成新"]||[_Old.text isEqualToString:@"7成新及以下"])){
            [MBProgressHUD showError:@"请按格式输入成色,比如:99成新"];
        }
        else{
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
                    NSLog(@"上传成功 %@", responseObject);
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
                                                     @"tit":_Title.text,
                                                     @"content" : _Describe.text,
                                                     @"prize"  : _Price.text,
                                                     @"prize_src"  : _Price_src.text,
                                                     @"attr"  : attr,
                                                     @"class" :@"0",
                                                     @"hidden"  : _responstring,
                                                     @"phone":_Phone.text,
                                                     @"qq":_QQ.text,
                                                     @"wechat":_Wechat.text
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
    else
        [MBProgressHUD showError:@"必须添加图片"];
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
    const int movementDistance = SYReal(160); // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}
@end
